var AWS = require('aws-sdk');

function getHostedZone(name, data) {
  hostedZone = ''
  data.HostedZones.forEach(function(z) {
    var awsName = z.Name;
    var targetName = name + '.';
    if (awsName.indexOf(name) == awsName.length - targetName.length) {
      hostedZone = z.Id;
    }
  });
  return hostedZone;
}

function updateHostedZone(hostedZone, name, ip, cb) {
  var route53 = new AWS.Route53();
  var params = {
    "HostedZoneId": hostedZone,
    "ChangeBatch": {
      "Changes": [
        {
          "Action": "UPSERT",
          "ResourceRecordSet": {
            "Name": name,
            "Type": "A",
            "TTL": 60,
            "ResourceRecords": [
              {
                "Value": ip
              }
            ]
          }
        }
      ]
    }
  };
  route53.changeResourceRecordSets(params, function(err, data) {
    var status = {}
    if (err) {
      console.log(err)
      status = {success: false, msg: "Unable to update  " + name + " to " + ip};
    } else {
      status = {success: true, msg: "Updated " + name + " to " + ip};
    }
    cb(status);
  });
}

function update(config, name, ip, cb){
  var route53, status;
  AWS.config.update({
    accessKeyId: config.accessKeyId,
    secretAccessKey: config.secretAccessKey
  });
  route53 = new AWS.Route53();

  route53.listHostedZones({}, function(err, data) {
    if(!err) {
      hostedZone = getHostedZone(name, data);
      if (hostedZone.length == 0) {
        status = {success: false, msg: "Could not find hosted zone with name: "+ name};
        console.log(data);
        cb(status);
      } else {
        updateHostedZone(hostedZone, name, ip, cb)
      }
    } else {
      console.log(err)
      status = {success: false, msg: "Could not get hosted zones"}
      cb(status);
    }
  });

  return status;
}

module.exports = {
  update: update
}
