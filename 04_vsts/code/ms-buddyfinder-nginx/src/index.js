var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var redis = require("redis");
var serveStatic = require('serve-static');

var subscriber= redis.createClient(6380,'datalinks.redis.cache.windows.net', {auth_pass: 'PASS', tls: {servername: 'datalinks.redis.cache.windows.net'}});
var bc_subscriber= redis.createClient(6380,'datalinks.redis.cache.windows.net', {auth_pass: 'PASS', tls: {servername: 'datalinks.redis.cache.windows.net'}});

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});


bc_subscriber.subscribe("MSBUDDYFINDER_BROADCAST");
bc_subscriber.on("message", function(channel, message) {
    io.emit('MSBUDDYFINDER_BROADCAST', message);
});

subscriber.subscribe("MSBUDDYFINDER_STATUS");
subscriber.on("message", function(channel, message) {
    console.log("Message '" + message + "' on channel '" + channel + "' arrived!")
    io.emit('MSBUDDYFINDER_STATUS_FE', message);
});

http.listen(3000, function(){
  app.use(serveStatic(__dirname, {'index': ['images/ms-officemap.png']}));
  console.log('listening on *:3000');
});
