common_packages:
  pkg.installed:
    - pkgs:
      - python-setuptools
      - emacs
      - screen
      - curl
      - ca-certificates
      - apt-transport-https
      # Used for htpasswd
      - apache2-utils

salt-minion:
  service:
    - running
    - enable: true

# Daemon functions shared by all services
/lib/init/shawmut-daemon-functions:
  file.managed:
    - source: salt://shawmut/files/shawmut-daemon-functions

# Logrotate shared by all services
/etc/logrotate.d/shawmut:
  file.managed:
    - source: salt://shawmut/files/shawmut.logrotate
