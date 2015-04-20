passenger_repo:
  pkgrepo.managed:
    - names:
        - "deb https://oss-binaries.phusionpassenger.com/apt/passenger wheezy main"
    - dist: wheezy
    - file: /etc/apt/sources.list.d/passenger.list
    - keyid: 561F9B9CAC40B2F7
    - keyserver: hkp://keyserver.ubuntu.com:80

passenger: pkg.installed

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

/etc/nginx/sites-enabled/default: file.absent

/etc/nginx/conf/ssl.include:
  file.managed:
    - source: salt://formulas/nginx/files/ssl.include
