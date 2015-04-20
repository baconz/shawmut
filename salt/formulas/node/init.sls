nodejs: pkg.installed

node_alternative:
  cmd.run:
    - name: "update-alternatives --install /usr/bin/node nodejs /usr/bin/nodejs 100"
    - creates: /usr/bin/node

npm:
  cmd.run:
    - name: "curl https://www.npmjs.com/install.sh | sh"
    - creates: /usr/bin/npm
