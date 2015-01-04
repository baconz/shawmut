{% set app_user = 'pi' %}
{% set venv = '/home/pi/shawmut-venv-salt' %}

include:
  - .packages
  - .conf
  - .services
