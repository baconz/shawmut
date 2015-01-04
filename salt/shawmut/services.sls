# Daemon functions shared by all services
/lib/init/shawmut-exec-functions:
  file.managed:
    - source: salt://shawmut/files/shawmut-exec-functions

# Arguments to pass to the shawmut wemo service
/etc/shawmut/shawmut_wemo_flags:
  file.managed:
    - contents: "-d server\n"

{% for service in ['shawmut_wemo', 'shawmut_auto_offd'] %}
{{ service }}:
  file.managed:
    - name: /etc/init.d/{{ service }}
    - source: salt://shawmut/templates/service.template
    - template: jinja
    - mode: 755
    - defaults:
        service_name: {{ service }}
        venv: {{ venv }}
        service_user: {{ app_user }}
  service.running:
    - enable: true
    - watch:
      - file: /etc/shawmut/shawmut.yml
      - virtualenv: {{ venv }}
{% endfor %}
