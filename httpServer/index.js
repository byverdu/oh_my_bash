const http = require('http')
const { promises } = require('fs')
const path = require('path')
const url = require('url');
const mime = require('mime-types');

const PORT = process.env.PORT || 3000
const cacheFilesContent = {}


const validRoutes = {
  new: 'new',
  '/': '/'
}

/**
 * @param {http.IncomingMessage} req
 * @param {http.ServerResponse} res
 */
function staticFileHandler(req, res) {
  const fileName = req.url === validRoutes["/"] ? path.join(__dirname, './index.html') : path.join(__dirname, req.url)
  const contentType = mime.contentType(path.extname(fileName))

  if (cacheFilesContent[fileName]) {
    console.log(`${fileName} is served from cache`)

    res.writeHead(200, { 'Content-Type': contentType });
    res.end(cacheFilesContent[fileName])
  } else {
    promises.readFile(fileName)
      .then(fileContent => {
        console.log(`${fileName} has been saved in the cache`)

        cacheFilesContent[fileName] = fileContent;
        res.writeHead(200, { 'Content-Type': contentTypes[fileExtension] });
        res.end(fileContent)
      })
      .catch(e => {
        console.log(e)
        if (e.code === 'ENOENT') {
          res.writeHead(404);
        } else {
          res.writeHead(500);
        }
        res.write(JSON.stringify(e));
        res.end()
      })
  }
}

/**
 * @param {http.IncomingMessage} req
 * @param {http.ServerResponse} res
 */
function newRouteHandler(req, res) {

  if (req.url.includes(validRoutes.new)) {
    const { query } = url.parse(req.url, true);

    res.end(JSON.stringify(query))
  }
}

/**
 * @param {http.IncomingMessage} req
 * @param {http.ServerResponse} res
 */
function notFoundRouteHandler(req, res) {

  if (!contentTypes[path.extname(req.url)] && !Object.keys(validRoutes).includes(req.url)) {
    res.end('Not Found')
  }
}

(function (requests) {

  http.createServer((req, res) => {

    requests.forEach(handler => {
      handler(req, res)
    })

  }).listen(PORT, () => console.log(`App running at port http://localhost:${PORT}`))
})([
  staticFileHandler,
  newRouteHandler,
  notFoundRouteHandler
])

