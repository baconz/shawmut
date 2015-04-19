common_packages:
  pkg.installed:
    - pkgs:
      - python-setuptools
      - emacs
      - screen

salt-minion:
  service:
    - running
    - enable: true

