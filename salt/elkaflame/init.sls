include:
  - formulas.nginx
  - formulas.ghost

/etc/nginx/sites-available/elkaflame:
  file.managed:
    - mode: 0755
    - source: salt://elkaflame/files/elkaflame
    - watch_in:
      - service: nginx

/etc/nginx/sites-enabled/elkaflame:
  file.symlink:
    - target: /etc/nginx/sites-available/elkaflame
