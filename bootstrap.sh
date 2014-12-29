#!/bin/bash

if ! [ `id -u` -eq 0 ] ; then
    echo "You must run this script as root" >&2
    exit 1
fi

SRC_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "deb http://debian.saltstack.com/debian wheezy-saltstack main" \
     > /etc/apt/sources.list.d/salt.list

wget -q -O /tmp/debian-salt-team-joehealy.gpg.key http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key
echo 'b702969447140d5553e31e9701be13ca11cc0a7ed5fe2b30acb8491567560ee62f834772b5095d735dfcecb2384a5c1a20045f52861c417f50b68dd5ff4660e6  /tmp/debian-salt-team-joehealy.gpg.key' | sha512sum -c
if ! [ $? -eq 0 ] ; then
    echo "Bad key: /tmp/debian-salt-team-joehealy.gpg.key" >&2
    exit 1
fi

wget -q -O- "http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key" | apt-key add -

apt-get update
apt-get install -y python-apt salt-minion

# Setup our salt configuration file, and source directory
cat <<-EOF > /etc/salt/minion
file_client: local
file_roots:
  base:
    - /srv/salt/
pillar_roots:
 base:
   - /srv/pillar
EOF

# Set up simple pillar data
ln -s "$SRC_DIR/salt" /srv/salt
mkdir -p /srv/pillar
cat <<-EOF > /srv/pillar/top.sls
base:
  '*':
    common
EOF
cp "$SRC_DIR/salt/pillar.example" /srv/pillar/common.sls

sudo service salt-minion restart
