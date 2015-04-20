{% set dyndns = {
  'conf'          : salt['pillar.get']('dyndns:conf'),
  'password'      : salt['pillar.get']('dyndns:password'),
  'username'      : salt['pillar.get']('dyndns:username'),
  'host'          : salt['pillar.get']('dyndns:host'),
  'ssl_cert_path' : salt['pillar.get']('dyndns:ssl_cert_path'),
  'names'         : salt['pillar.get']('dyndns:names'),
} %}
