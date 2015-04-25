base:
  '*':
    - common

  'raspberrypi':
    - raspberrypi
    - dyndns.client
    - shawmut

  'roles:dyndns':
    - match: grain
    - dyndns

  'roles:elkaflame':
    - match: grain
    - elkaflame
