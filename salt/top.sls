base:
  '*':
    - common

  'raspberrypi':
    - raspberrypi
    - shawmut

  'roles:dyndns':
    - match: grain
    - dyndns
