const http = require('http')
const { promises } = require('fs')
const path = require('path')

const PORT = 3000 || process.env.PORT

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
          res.writeHead(404, { 'Content-Type': contentTypes[fileExtension] });
        } else {
          res.writeHead(500, { 'Content-Type': contentTypes[fileExtension] });
        }
        res.write(JSON.stringify(e));
        res.end()
      })
  }
}

function newRouteHandler(req, res) {
  if (req.url === validRoutes.new) {
    res.end('yeiiii')
  }
}

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

