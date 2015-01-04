{%- from 'shawmut/settings.sls' import shawmut with context %}

/etc/shawmut: file.directory

# Application config file
/etc/shawmut/shawmut.yml:
  file.serialize:
    - user: {{ shawmut.app_user }}
    - mode: 0600
    - show_diff: false
    - dataset:
        bd_addrs: {{ salt['pillar.get']('bd_addrs') }}
        forecast_io_key: {{ salt['pillar.get']('forecasat_io_key') }}
        latitude: {{ salt['pillar.get']('latitude') }}
        longitude: {{ salt['pillar.get']('longitude') }}
    - formatter: yaml
