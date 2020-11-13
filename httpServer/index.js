const http = require('http')
const { promises } = require('fs')
const path = require('path')
const url = require('url');

const PORT = process.env.PORT || 3000

const contentTypes = {
  '.html': 'text/html',
  '.js': 'text/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.wav': 'audio/wav',
  '.mp4': 'video/mp4',
  '.woff': 'application/font-woff',
  '.ttf': 'application/font-ttf',
  '.eot': 'application/vnd.ms-fontobject',
  '.otf': 'application/font-otf',
  '.wasm': 'application/wasm',
  '.ico': 'image/x-icon'
};

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

  const fileExtension = path.extname(fileName);

  if (fileExtension) {
    promises.readFile(fileName)
      .then(fileContent => {
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

