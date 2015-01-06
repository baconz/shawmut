{%- from 'shawmut/settings.sls' import shawmut with context %}

# Daemon functions shared by all services
/lib/init/shawmut-daemon-functions:
  file.managed:
    - source: salt://shawmut/files/shawmut-daemon-functions

/etc/logrotate.d/shawmut:
  file.managed:
    - source: salt://shawmut/files/shawmut.logrotate

# Arguments to pass to the shawmut wemo service
/etc/shawmut/shawmut_wemo_flags:
  file.managed:
    - contents: "-d server\n"

/etc/shawmut/shawmut_auto_offd_flags:
  file.managed:
    - contents: "-d\n"

{% for service in ['wemo', 'auto_offd'] %}
{{ service }}:
  file.managed:
    - name: /etc/init.d/{{ service }}
    - source: salt://shawmut/templates/service.template
    - template: jinja
    - mode: 755
    - defaults:
        service_name: {{ service }}
        venv: {{ shawmut.venv }}
        service_user: {{ shawmut.app_user }}
  service.running:
    - enable: true
    - watch:
      - file: /etc/shawmut/shawmut.yml
      - virtualenv: {{ shawmut.venv }}
      - file: /etc/shawmut/shawmut_{{ service }}_flags
{% endfor %}
