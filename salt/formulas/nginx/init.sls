{% if grains['cpuarch'] == 'armv6l' %}
{% set passenger_root = '' %}
passenger:
  gem.installed:
    - version: 5.0.6
libcurl4-openssl-dev: pkg.installed
ruby1.9.1-dev: pkg.installed
## TODO: Link /opt/nginx/sbin/nginx to /usr/sbin/nginx
## Need to run sudo passenger-install-nginx-module
{% else %}
{% set passenger_root = '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;' %}
passenger_repo:
  pkgrepo.managed:
    - names:
        - "deb https://oss-binaries.phusionpassenger.com/apt/passenger wheezy main"
    - dist: wheezy
    - file: /etc/apt/sources.list.d/passenger.list
    - keyid: 561F9B9CAC40B2F7
    - keyserver: hkp://keyserver.ubuntu.com:80

passenger: pkg.installed
{% endif %}

nginx:
  pkg:
    - installed
    - require:
      - pkgrepo: passenger_repo
  service:
    - running
    - watch:
      - file: /etc/nginx/sites-available/*

/etc/nginx/conf: file.directory
/etc/nginx/ssl: file.directory

dhparam:
  cmd.run:
    - name: "openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048"
    - creates: /etc/nginx/ssl/dhparam.pem

/etc/nginx/sites-enabled/default: file.absent

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://formulas/nginx/templates/nginx.conf.template
    - template: jinja
    - defaults:
      passenger_root: {{ passenger_root }}
    - watch_in:
      - service: nginx

/etc/nginx/conf/ssl.include:
  file.managed:
    - source: salt://formulas/nginx/files/ssl.include
    - watch_in:
      - service: nginx
