{% set shawmut = {
  'app_user' : 'pi',
  'venv'     : '/home/pi/shawmut-venv-salt',
  'conf'     : salt['pillar.get']('shawmut'),
} %}
