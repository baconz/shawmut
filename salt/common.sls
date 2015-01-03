common_packages:
  pkg.installed:
    - pkgs:
      - python-setuptools
      - emacs

salt-minion:
  service:
    - running
    - enable: true

/etc/resolv.conf:
  file:
    - present
    - contents: "nameserver 8.8.8.8\n"

dnsmasq:
  pkg:
    - installed
  service:
    - running
    - enable: true
    - watch:
      - host: dnsmasq
      - file: /etc/resolv.conf
  host:
    - present
    - ip:
      - {{ salt['pillar.get']('base_ip') }}
    - names:
      - {{ salt['pillar.get']('base_hostname') }}
