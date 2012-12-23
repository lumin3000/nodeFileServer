http = require "http"
fs = require "fs"

onRequest = (request, response) ->
  
  pureUrl = request.url
  return  if pureUrl is "/favicon.ico"
  candidateQS = require("url").parse(request.url)["query"]
  pureUrl = UrlToFsPath(pureUrl)
  console.log pureUrl + " is requested"
  try
    if candidateQS?

      # a file is requested
      candidateQS = candidateQS.substr(5, candidateQS.lenght)
      fileData = fs.readFileSync(candidateQS)
      response.writeHead 200
      response.write fileData
      response.end()
    else
      htmlOutput = FormatHtmlFileList(pureUrl)
      response.writeHead 200,
        "Content-Type": "text/html"

      response.end htmlOutput, "utf8"
  catch error
    response.writeHead 404,
      "Content-Type": "text/html"

    response.end()
    
serverCreated_callback = ->
  console.log "HttpFileSystem Server running"

UrlToFsPath = (pureUrl) ->
  pureUrl += "/"  unless pureUrl.substr(-1) is "/"
  unescape(pureUrl.replace(/\+/g, " "))
FormatHtmlTableRow = (absolutePath, filename) ->
  fileStats = fs.statSync(absolutePath)
  htmlRow = undefined
  if fileStats.isFile()
    htmlRow = "<tr><td>[-]</td><td style='width:300px'><a href='/?file=" + absolutePath + "'>" + filename + "</a> </td><td>" + fileStats["ctime"] + "</td><td>" + fileStats["size"] + "</td>"
  else
    htmlRow = "<tr><td>[+]</td><td style='width:300px'><a href='" + absolutePath + "'> " + filename + "</a> </td><td>" + fileStats["ctime"] + "</td>"
  htmlRow
FormatHtmlFileList = (pureUrl) ->
  htmlOutput = "<h3>Folder: " + pureUrl + "</h3>"
  htmlOutput += "<a href='" + pureUrl + "' >Go back</a>"
  htmlOutput += "<table>"
  htmlOutput += "<tr><td> </td><td style='width:300px'> Name </td><td>Create Date</td><td>Size</td>"
  directories = fs.readdirSync(pureUrl)
  for i of directories
    absolutePath = pureUrl + directories[i]
    htmlOutput += FormatHtmlTableRow(absolutePath, directories[i])
  htmlOutput += "</table>"
  htmlOutput




httpserver = http.createServer(onRequest)
httpserver.listen 8124, "127.0.0.1", serverCreated_callback