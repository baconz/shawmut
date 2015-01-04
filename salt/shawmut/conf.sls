{%- from 'shawmut/settings.sls' import shawmut with context %}

/etc/shawmut: file.directory

# Application config file
/etc/shawmut/shawmut.yml:
  file.managed:
    - mode: 0600
    - show_diff: false
    - contents: "{{ shawmut.conf | yaml() | indent(8) }}"
    - user: {{ shawmut.app_user }}


