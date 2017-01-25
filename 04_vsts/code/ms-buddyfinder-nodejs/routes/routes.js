var appRouter = function(app) {
var redis = require("redis");
var log4js = require('log4js');
var module = require('./getAll');

log4js.configure('log4j.properties')

var loggerinfo = log4js.getLogger('info');
var client = redis.createClient(6380,'datalinks.redis.cache.windows.net', {auth_pass: 'PASS', tls: {servername: 'datalinks.redis.cache.windows.net'}});


  // STATUS CALL
  app.get("/status", function(req, res) {

    loggerinfo.info("status called");
     res.setHeader('Access-Control-Allow-Origin', 'http://msbf.datalinks.nl:8080');
     module.getItems(function(result){
        return res.send(result);
     });
  });

  // REGISTER OUT CALL (APP)
  app.get("/out", function(req, res) {
    res.setHeader('Access-Control-Allow-Origin', 'http://msbf.datalinks.nl:8080');
    client.hdel('msbuddies',req.query.id);
    loggerinfo.info("removed client with ID: "+req.query.id);
    return res.send("OK removed key "+req.query.id);
  });


  // BROADCAST MESSAGE
  // params: 1 = from, 2 = message
  app.get("/broadcast", function(req, res) {
    res.setHeader('Access-Control-Allow-Origin', 'http://msbf.datalinks.nl:8080');
    var result = {
        "from": req.query.from,
        "message": req.query.message
    }
    loggerinfo.info("message send by: "+req.query.from+" message: "+req.query.message );
    client.publish("MSBUDDYFINDER_BROADCAST", JSON.stringify(result));
    return res.send("BROADCAST OK");
  });


  // REGISTER IN CALL (MOBILE)
  // params: 1 = uuid , 2 = user , 3 = beacon , 4 = state , 5 = (logo later)
  app.get("/in", function(req, res) {

    res.setHeader('Access-Control-Allow-Origin', 'http://msbf.datalinks.nl:8080');
    var user=req.query.user;
    var uuid=req.query.uuid;
    var beacon=req.query.beacon;
    var state=req.query.state;
    var logo="https://datalinks.blob.core.windows.net/buddytracker/chris2.png"

    topc=0;
    leftc=0;

    // determine beacon coordinates for app on screen
    // LUNCH : X should be between 30 and 600
    //         Y should be between 600 and 750
    if(beacon=="lunch"){
      pointx=Math.round(Math.random() * (600-30) +30 );
      pointy=Math.round(Math.random() * (750-600) +600 );
    // COFFEE: X should be between 630 and 1000
    //         Y should be between 420 and 350
    }else if(beacon=="coffee"){
      pointx=Math.round(Math.random() * (1000-630) + 630);
      pointy=Math.round(Math.random() * (420-350) + 350);
    // CSA : X should be between 630 and 1000
    //       Y should be between 60 and 350
    }else{

      pointx=Math.round(Math.random() * (1000-630) + 630);
      pointy=Math.round(Math.random() * (350-60) + 60);
    }

    // store to redis (alternative publish to topic...multiple subscribers can pick this up)
    var status = {
        "uuid": uuid,
        "left": pointy,
        "top": pointx,
        "name": user,
        "state": state,
        "beacon": beacon,
        "logo":  logo
    }
    // Next to putting the stuff in the redis cache...we also publish it to the subscribers
    client.hmget('msbuddies',uuid, function(err, result) {
         // only process if user (UUID) does not exists already
         if(result == null || result[0] == null){
            // only store if all values are present
            if(user!=null && uuid!=null && beacon!=null && state!=null){
              console.log("storing status: ");
              client.hmset("msbuddies",uuid, JSON.stringify(status));
            }
         }else{
            console.log("user already exists: "+user);
            client.hdel("msbuddies",uuid);
            client.hmset("msbuddies",uuid, JSON.stringify(status));
         }
    });
    loggerinfo.info("uuid: "+uuid+" user: "+user+" entered on location: "+beacon);
    client.publish("MSBUDDYFINDER_STATUS", JSON.stringify(status));
    return res.send(status);
  });
}

module.exports = appRouter;
                                                            
