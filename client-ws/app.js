const WebSocket = require('ws');
 
const ws = new WebSocket('http://sync-gateway:4984/main-bucket/_changes?feed=websocket');
 
ws.on('open', function open() {
  console.log("Socket opened")
  ws.send('{"include_docs": true}')
});
 
ws.on('message', function incoming(data) {
  console.log(data);
});

