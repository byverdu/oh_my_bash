const http = require('http')
const { promises } = require('fs')
const path = require('path')

const PORT = 3000 || process.env.PORT

const contentTypes = {
  '.html': 'text/html',
  '.js': 'text/javascript',
  '.ico': 'image/x-icon'
}

http.createServer((req, res) => {
  let fileName
  if (req.url === '/') {
    fileName = path.join(__dirname, './index.html')
  } else {
    fileName = path.join(__dirname, req.url)
  }
  const fileExtension = path.extname(fileName)
  console.log(req.url, '=>', fileName)

  promises.readFile(fileName).then(fileContent => {
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
}).listen(PORT, () => console.log(`App running at port http://localhost:${PORT}`)) 