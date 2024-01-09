const Koa = require('koa');
const logger = require('koa-logger');
const { koaBody } = require('koa-body');

const sampleScores = require('./scoreboard-sample.json')
const {uploadFromMemory, downloadIntoMemory} = require("./storage");
let memoryScores = []
// let memoryScores = [{ name: 'POP', score: 700 },{ name: 'POP', score: 700 },{ name: 'POP', score: 700 },{ name: 'POE', score: 701 },{ name: 'PKP', score: 722 },{ name: 'POP', score: 700 },{ name: 'POP', score: 700 },{ name: 'POE', score: 701 },{ name: 'PKP', score: 722 },{ name: 'POP', score: 700 }].sort((a, b) => b.score - a.score).slice(0,10)

downloadIntoMemory()
    .then((data) => {
        const stringData = data.toString()
        const parsedData = JSON.parse(stringData)
        if (JSON.stringify(memoryScores) !== stringData) {
            console.log('updating scores from bucket')
            console.log('memory:', memoryScores)
            console.log('bucket:', parsedData)
        }
        memoryScores = parsedData
    })
    .catch(console.error);

const addScore = ({name, score}) => {
    memoryScores.push({name, score})
    memoryScores = memoryScores.sort((a, b) => b.score - a.score).slice(0,10)
    uploadFromMemory(JSON.stringify(memoryScores)).catch(console.error);
}

const handleScoreSubmit = ({name, score}) => {
    let didUpdate = false
    if (memoryScores.length >= 10) {
        const lowestScore = memoryScores.slice(-1)[0]
        if (score > lowestScore.score) {
            addScore({name, score})
            didUpdate = true
        }
    } else {
        addScore({name, score})
        didUpdate = true
    }
    console.log('score log:', name, score, didUpdate? 'updated': 'too low')
    return didUpdate
}

const app = new Koa();
app.use(logger());
app.use(koaBody({ multipart: true }));

// POST to add score
app.use(async function(ctx, next) {
    if ('POST' !== ctx.method) return await next();
    const body = ctx.request.body;
    console.log('body:', body)
    await downloadIntoMemory()
    let scoreUpdated = false
    if (body.name && body.score) {
        scoreUpdated = handleScoreSubmit(body)
    }

    if (memoryScores.length > 0) {
        ctx.body = {data: memoryScores, scoreUpdated}
    } else {
        ctx.body = {data: sampleScores.data, scoreUpdated}
    }
});

// GET to get scoreboard
app.use(async function(ctx, next) {
    if ('GET' !== ctx.method) return await next();

    const scoreUpdated = false
    if (memoryScores.length > 0) {
        ctx.body = {data: memoryScores, scoreUpdated}
    } else {
        ctx.body = {data: sampleScores.data, scoreUpdated}
    }
});

app.listen(process.env.PORT || 3000);

