include:
  - formulas.nginx
  - formulas.node

/etc/nginx/sites-available/alexa:
  file.managed:
    - mode: 0755
    - template: jinja
    - source: salt://alexa/files/alexa.site
    - watch_in:
      - service: nginx

/etc/nginx/sites-enabled/alexa:
  file.symlink:
    - target: /etc/nginx/sites-available/alexa
