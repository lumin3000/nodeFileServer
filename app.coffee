fs = require('fs')
node_static = require('node-static')
 
file = new(node_static.Server)('./public')
server = require('http').createServer (request, response)->
  request.addListener 'end', ->
    file.serve request, response
server.listen(3789)