#!/usr/bin/python

from threading import Timer
from datetime import datetime
from subprocess import call
import os.path
import urllib2
import json

SCHEDULER_INTERVAL = 10
ADDRESSES = [ '10.0.1.16', '192.168.13.6' ]

# TODO capture timestamp instead of away_flag
# TODO only turn on lights on night time

def log(msg):
    print "%s: %s" % (msg, datetime.now().strftime('%Y-%m-%d %H:%M:%S'))

def is_home():
    for ip in ADDRESSES:
        DEVNULL = open(os.devnull, 'w') # TODO move outside loop
        found_ip = call(['ping', ip, '-q', '-w', '1', '-c', '1'], stdout=DEVNULL, close_fds=True)
        if found_ip == 0:
            return True
    return False

def have_guests():
    os.path.isfile('/etc/shawmut/have_guests')

def light_data():
    data = urllib2.urlopen('http://localhost:5000/api/environment').read()
    json.loads(data)

def on_lights():
    list(name for (name, data) in light_data().iteritems() if data['state'] == 0)

def off_lights():
    list(name for (name, data) in light_data().iteritems() if data['state'] == 1)

def toggle_lights(lights):
    for l in lights:
        urllib2.urlopen("http://localhost:5000/api/device/%s" %l, '{"state":"toggle"}')

def turn_on_lights():
    log('Turning on lights')
    toggle_lights(off_lights())

def turn_off_lights():
    log('Turning off lights')
    toggle_lights(on_lights())

def main():
    if have_guests():
        next
    elif is_home() and away_flag:
        # Just got home
        away_flag = False
        turn_on_lights()
    elif not (is_home() and away_flag):
        # Just left
        turn_off_lights()
        away_flag = True


if __name__ == '__main__':

    timer = Timer(SCHEDULER_INTERVAL, main()).start()
    timer.start()
