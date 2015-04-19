/etc/resolv.conf:
  file:
    - managed
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
      - {{ salt['pillar.get']('raspberrypi:base_ip') }}
    - names:
      - {{ salt['pillar.get']('raspberrypi:base_hostname') }}

{% set keys = salt['pillar.get']('raspberrypi:authorized_keys', []) %}
{% if keys %}
sshkeys:
  ssh_auth.present:
    - user: pi
    - names:
{% for key in keys %}
      - {{ key }}
{% endfor %}
{% endif %}
