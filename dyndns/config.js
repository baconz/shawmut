var fs = require('fs');

var configFile = '/etc/dyndns.json';

module.exports = {
  getConfig: function (cb) {
    fs.exists(configFile, function (exists){
      var config = {};
      if (exists) {
        config = JSON.parse(fs.readFileSync(configFile, 'utf8'));
        cb(config);
      }
      else {
        config = JSON.parse(fs.readFileSync('./config.json', 'utf8'));
        cb(config);
      }
      module.exports = config;
    });
  }
}
