nodejs: pkg.installed

{% if grains['cpuarch'] == 'armv6l' %}
node_package:
  pkg.installed:
    - sources:
      - node: http://node-arm.herokuapp.com/node_latest_armhf.deb
{% else %}
node_alternative:
  cmd.run:
    - name: "update-alternatives --install /usr/bin/node nodejs /usr/bin/nodejs 100"
    - creates: /usr/bin/node
{% endif %}

npm:
  cmd.run:
    - name: "curl https://www.npmjs.com/install.sh | sh"
    - creates: /usr/bin/npm
