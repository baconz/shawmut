var express = require('express');
var bodyParser = require('body-parser');
var app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.post('/shawmut', function (req, res) {
  console.log(req.body);
  res.json(req.body);
});

var server = app.listen(3000, function () {
  var host = server.address().address;
  var port = server.address().port;
});
