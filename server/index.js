const Koa = require('koa');
const logger = require('koa-logger');
const { koaBody } = require('koa-body');

const sampleScores = require('./scoreboard-sample.json')

const app = new Koa();
app.use(logger());
app.use(koaBody({ multipart: true }));

// POST to add score
app.use(async function(ctx, next) {
    if ('POST' !== ctx.method) return await next();
    const body = ctx.request.body;
    console.log('body:', body)
    // JSON parse body
    // check for name, score fields
    // if score in top 10
    //   add to scoreboard
    // else
    //   too bad
    //
    // return scoreboard

    ctx.body = 'POSTed'
});

// GET to get scoreboard
app.use(async function(ctx, next) {
    if ('GET' !== ctx.method) return await next();
    // load scoreboard from local file?
    ctx.body = sampleScores
});

app.listen(3000);

