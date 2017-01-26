var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var redis = require("redis");
var serveStatic = require('serve-static');

var subscriber= redis.createClient(6380,process.env.REDIS_URL, {auth_pass:process.env.REDIS_PASSWORD, tls: {servername: process.env.REDIS_URL}});

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});


subscriber.subscribe("MSBUDDYFINDER_BROADCAST");
subscriber.on("message", function(channel, message) {
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
