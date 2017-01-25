var redis = require("redis");
var client = redis.createClient(6380,'datalinks.redis.cache.windows.net', {auth_pass: 'PASS', tls: {servername: 'datalinks.redis.cache.windows.net'}});

var getItems = function(callback){

  console.log("running getitems");

  client.hgetall("msbuddies",function(err, res){
    var items = [];
    for (i in res) {
      items.push(JSON.parse(res[i]));
    }
    callback(items);
  });
};
exports.getItems = getItems;
