http = require('http')
ecstatic = require('ecstatic')

http.createServer(ecstatic root:"#{__dirname}/public",showDir:true,autoIndex:true).listen(8080)
console.log('Listening on :8080')