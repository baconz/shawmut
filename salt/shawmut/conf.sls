{%- from 'shawmut/settings.sls' import shawmut with context %}

/etc/shawmut: file.directory

# Application config file
/etc/shawmut/shawmut.yml:
  file.serialize:
    - user: {{ shawmut.app_user }}
    - mode: 0600
    - show_diff: false
    - dataset: {{ shawmut.conf }}
    - formatter: yaml
