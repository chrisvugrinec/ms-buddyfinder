'use strict';
var util = require('util');

module.exports = {
  twitterfeed: twitterfeed 
};

function twitterfeed(req, res) {
  // variables defined in the Swagger document can be referenced using req.swagger.params.{parameter_name}
  var tuser= req.swagger.params.user.value || 'cvugrinec';
  var tmessage= req.swagger.params.message.value || 'hello world';

  res.json(tmessage);
}
