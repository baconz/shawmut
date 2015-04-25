{%- from 'formulas/ghost/settings.sls' import conf with context %}

include:
  - formulas.node

ghost_deps:
  pkg.installed:
    - pkgs:
      - unzip
      - sqlite3

ghost_user:
  group.present:
    - name: {{ conf['group_name'] }}
  user.present:
    - name: {{ conf['user_name'] }}
    - shell: /bin/bash
    - groups:
      - {{ conf['group_name'] }}

app_dir:
  file.directory:
    - name: {{ conf['app_path'] }}
    - user: {{ conf['user_name'] }}
    - group: {{ conf['group_name'] }}
    - makedirs: true

build_dir:
  file.directory:
    - name: {{ conf['build_path'] }}
    - user: {{ conf['user_name'] }}
    - group: {{ conf['group_name'] }}
    - makedirs: true

ghost_get_src:
  cmd.run:
    - name: wget --no-check-certificate {{ conf['ghost_src'] }} -O {{ conf['build_path'] }}/ghost.zip
    - unless: test -f {{ conf['build_path'] }}/ghost.zip
    - cwd: {{ conf['build_path'] }}
    - user: {{ conf['user_name'] }}
    - group: {{ conf['group_name'] }}
    - timeout: 60

ghost_unzip_src:
  cmd.run:
    - name: unzip -q -o -d ghost ghost.zip
    - unless: test -d {{ conf['build_path'] }}/ghost
    - cwd: {{ conf['build_path'] }}
    - user: {{ conf['user_name'] }}
    - group: {{ conf['group_name'] }}
    - timeout: 60

#
# new ghost
#
ghost_install:
  cmd.run:
    - name: cp -R {{ conf['build_path'] }}/ghost/* {{ conf['app_path'] }}/
    - unless: test -f {{ conf['app_path'] }}/package.json
    - cwd: {{ conf['build_path'] }}
    - user: {{ conf['user_name'] }}
    - group: {{ conf['group_name'] }}
    - timeout: 60

ghost_modules:
  cmd.run:
    - name: npm install --production
    - unless: test -d node_modules
    - cwd: {{ conf['app_path'] }}
    - user: {{ conf['user_name'] }}
    - group: {{ conf['group_name'] }}
    - timeout: 600

{{ conf['app_path'] }}/config.js:
  file.managed:
    - source: salt://formulas/ghost/templates/config.js.template
    - template: jinja
    - user: {{ conf['user_name'] }}
    - group: {{ conf['group_name'] }}
    - mode: 640

# For passenger
{{ conf['app_path'] }}/app.js:
  file.managed:
    - source: salt://formulas/ghost/templates/app.js.template
    - template: jinja
    - user: {{ conf['user_name'] }}
    - group: {{ conf['group_name'] }}
    - mode: 640
