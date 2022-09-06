const http = require('http');
http.createServer((request, response) => {
    response.writeHead(200, {
        'Content-Type': 'text/plain'
    });
    response.write(`Hello, World!, Request Path: ${request.url}`);
    response.end();

}).listen(3001,()=>{
    console.log("Node Server Started !");
});