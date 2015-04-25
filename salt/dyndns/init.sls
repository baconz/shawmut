{%- from 'dyndns/settings.sls' import dyndns with context %}

{% set passwd_file = '/etc/nginx/dyndns.htapasswd' %}

include:
  - formulas.nginx
  - formulas.node

/etc/dyndns.json:
  file.managed:
    - mode: 0655
    - show_diff: false
    - contents: '{{ dyndns.conf | json() | indent(8) }}'

htpasswd_file:
  webutil.user_exists:
    - name: {{ dyndns.username }}
    - password: {{ dyndns.password }}
    - htpasswd_file: {{ passwd_file }}
    - watch_in:
      - service: nginx

/etc/nginx/sites-available/dyndns:
  file.managed:
    - mode: 0755
    - template: jinja
    - source: salt://dyndns/templates/dyndns.template
    - defaults:
      passwd_file: {{ passwd_file }}
      host: {{ dyndns.host }}
      ssl_cert_path: {{ dyndns.ssl_cert_path }}
    - watch_in:
      - service: nginx

/etc/nginx/sites-enabled/dyndns:
  file.symlink:
    - target: /etc/nginx/sites-available/dyndns
