{%- from 'shawmut/settings.sls' import shawmut with context %}

# OuiMeaux Dependencies
shawmut_packages:
  pkg.installed:
    - pkgs:
      - python-all-dev
      - libevent-dev
      - daemon
      - bluez
      - libbluetooth-dev

{{ shawmut.venv }}:
  virtualenv.managed:
    - user: {{ shawmut.app_user }}
    - requirements: salt://shawmut/files/requirements.txt
