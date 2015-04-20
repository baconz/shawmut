{%- from 'dyndns/settings.sls' import dyndns with context %}

curl: pkg.installed

{% for name in dyndns.names %}
dyndns_cron_{{ name }}:
  cron.present:
    - name: "/usr/bin/curl -u {{ dyndns.username }}:{{ dyndns.password }} https://{{ dyndns.host }}/{{ name }} > /var/log/shawmut_dyndns.log"
    - minute: '*/5'
{% endfor %}
