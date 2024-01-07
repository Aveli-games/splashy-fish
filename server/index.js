const Koa = require('koa');
const logger = require('koa-logger');
const { koaBody } = require('koa-body');

const sampleScores = require('./scoreboard-sample.json')
let memoryScores = []
// let memoryScores = [{ name: 'POP', score: 700 },{ name: 'POP', score: 700 },{ name: 'POP', score: 700 },{ name: 'POE', score: 701 },{ name: 'PKP', score: 722 },{ name: 'POP', score: 700 },{ name: 'POP', score: 700 },{ name: 'POE', score: 701 },{ name: 'PKP', score: 722 },{ name: 'POP', score: 700 }].sort((a, b) => b.score - a.score).slice(0,10)

const addScore = ({name, score}) => {
    memoryScores.push({name, score})
    memoryScores = memoryScores.sort((a, b) => b.score - a.score).slice(0,10)
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
    // TODO: load scoreboard from local file
    
    const scoreUpdated = false
    if (memoryScores.length > 0) {
        ctx.body = {data: memoryScores, scoreUpdated}
    } else {
        ctx.body = {data: sampleScores.data, scoreUpdated}
    }
});

app.listen(process.env.PORT || 3000);

