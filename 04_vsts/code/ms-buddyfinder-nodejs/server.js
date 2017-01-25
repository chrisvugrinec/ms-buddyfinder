var express = require("express");
var bodyParser = require("body-parser");
var app = express();
var fs = require('fs');

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

var securityOptions = {
    key: fs.readFileSync('cert/msbfdatalinks.key'),
    cert: fs.readFileSync('cert/msbf_datalinks_nl.cer'),
    requestCert: true
};

var routes = require("./routes/routes.js")(app);

// enable this for https
//var secureServer = require('http').createServer(app);
var secureServer = require('https').createServer(securityOptions, app);
secureServer.listen (3000);
console.log("listening on port 3000");

//var server = require('http').createServer(app);
//server.listen (3000);
//console.log("listening on port 3000");
