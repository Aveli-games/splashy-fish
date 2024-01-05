const Koa = require('koa');
const logger = require('koa-logger');
const koaBody = require('koa-body');


const app = new Koa();
app.use(logger());
app.use(koaBody({ multipart: true }));

// POST to add score
app.use(async function(ctx, next) {
    if ('POST' !== ctx.method) return await next();
    const body = ctx.request.body;
    console.log('body:', body)
    ctx.body = 'POST'
});

// GET to get scoreboard
app.use(async function(ctx, next) {
    if ('GET' !== ctx.method) return await next();
    // get scoreboard
    ctx.body = 'GET'
});

app.listen(3000);

