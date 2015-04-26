base:
  '*':
    - common

  'raspberrypi':
    - raspberrypi
    - dyndns.client
    - shawmut
    - alexa

  'roles:dyndns':
    - match: grain
    - dyndns

  'roles:elkaflame':
    - match: grain
    - elkaflame
