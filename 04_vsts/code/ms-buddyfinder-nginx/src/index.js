var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var redis = require("redis");
var serveStatic = require('serve-static');
var sleep = require('system-sleep');

var subscriber= redis.createClient(6380,process.env.REDIS_URL, {auth_pass:process.env.REDIS_PASSWORD, tls: {servername: process.env.REDIS_URL}});

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});


subscriber.subscribe("MSBUDDYFINDER_BROADCAST");
subscriber.on("message", function(channel, message) {
   sleep(3000);
   io.emit('MSBUDDYFINDER_BROADCAST', message);
});




subscriber.subscribe("MSBUDDYFINDER_STATUS");
subscriber.on("message", function(channel, message) {
    console.log("Message '" + message + "' on channel '" + channel + "' arrived!")
    io.emit('MSBUDDYFINDER_STATUS_FE', message);
});

app.get("/in", function(req, res) {

  var user=req.query.user;
  var message=req.query.message;

  pointx=Math.round(Math.random() * 1024);
  pointy=Math.round(Math.random() * 768);

  var status = {
      "user": user,
      "message": message,
      "pointx": pointx,
      "pointy": pointy
   }
   subscriber.publish("MSBUDDYFINDER_BROADCAST", JSON.stringify(status));
   
   return res.send(status);
});



http.listen(3000, function(){
  //app.use(serveStatic(__dirname, {'index': ['images/ms-officemap.png']}));
  app.use(serveStatic(__dirname, {'index': ['images/logo-solvinity.png']}));
  console.log('listening on *:3000');
  console.log('REDIS URL : '+process.env.REDIS_URL);
  console.log('REDIS PASSWORD : '+process.env.REDIS_PASSWORD);
});
