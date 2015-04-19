var express = require('express');
var dns = require('./route53');
var conf = require('./config');
var app = express();


function startServer(config) {
  app.get('/:name', function (req, res) {
    var ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
    var name = req.params.name;
    status = dns.update(config, name, ip, function (status){
      res.json(status);
    });
  });

  var server = app.listen(3000, function () {
    var host = server.address().address;
    var port = server.address().port;
  });

}

conf.getConfig(startServer);
