{% set backup = salt['pillar.get']('backup') %}
{% if backup %}
backup_deps:
  pkg.installed:
    - pkgs:
      - gnupg
      - s3cmd
      - bsd-mailx

/etc/s3cfg-backup:
  file.managed:
    - template: jinja
    - mode: 0600
    - source: salt://backup/templates/s3cfg.template
    - defaults:
      gpg_passphrase: {{ backup.gpg_passphrase }}
      access_key: {{ backup.accessKeyId }}
      secret_key: {{ backup.secretAccessKey }}

/usr/local/bin/backup_to_s3:
  file.managed:
    - source: salt://backup/files/backup_to_s3
    - mode: 0755

{% for target in backup.targets %}
backup_{{ target.name }}:
  cron.present:
    - name: /usr/local/bin/backup_to_s3 {{ backup.bucket }} {{ target.dir }} {{ target.name }} {{ target.retain }} > /var/log/{{ target.name }}.last_backup 2>&1 || mail -s "{{ target.name }} backup failed on `hostname`" {{ backup.admin_email }}
    - hour: "{{ target.hour }}"
    - minute: 1
    - identifier: backup_{{ target.name }}
{% endfor %}

{% endif %}
