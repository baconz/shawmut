# OuiMeaux Dependencies
shawmut_packages:
  pkg.installed:
    - pkgs:
      - python-all-dev
      - libevent-dev
      - daemon

{{ venv }}:
  virtualenv.managed:
    - user: {{ app_user }}
    - requirements: salt://shawmut/files/requirements.txt
