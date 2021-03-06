Our mini home-automation suite!

To bootstrap
------------
(1) Clone this repo to your desired machine
(2) Run `sudo ./bootstrap.sh` -- optionally pass roles as arguments
(3) Customize the pillar data in `/srv/pillar/common.sls`
(4) Make sure to set static IPs for the raspberry pi
(5) Set the IP of the Raspberry Pi as your DNS server
(6) Run `sudo salt-call state.highstate`

Pairing Your iPhone
-------------------
(1) Settings -> Bluetooth and switch Bluetooth on
(2) `hcitool scan` and note the address of your iPhone
(3) Make sure your phone is awake and discoverable and run:
        sudo bluez-simple-agent -c DisplayYesNo <YOUR_DEV (eg hci0)> <BD_ADDR>
(4) Tap "Pair" on your iPhone
(5) Add the address of your iPhone to bd_addrs in pillar data (eg `/srv/pillar/common.sls`)
(7) Run `sudo salt-call state.highstate`

To deploy
---------
(1) Go to /home/pi/src/shawmut (or your local) checkout and do a git pull
(2) Run `sudo salt-call state.highstate`
