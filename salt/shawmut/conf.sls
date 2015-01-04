/etc/shawmut: file.directory

# Application config file
/etc/shawmut/shawmut.yml:
  file.serialize:
    - user: {{ app_user }}
    - mode: 0600
    - show_diff: false
    - dataset:
        iphone_ips: {{ salt['pillar.get']('iphone_ips') }}
        forecast_io_key: {{ salt['pillar.get']('forecasat_io_key') }}
        latitude: {{ salt['pillar.get']('latitude') }}
        longitude: {{ salt['pillar.get']('longitude') }}
    - formatter: yaml
