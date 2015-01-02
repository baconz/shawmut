#!/usr/bin/env

import time
from datetime import datetime
from subprocess import call
import os.path
import urllib2
import json

SCHEDULER_INTERVAL = 5
ADDRESSES = [ '10.0.1.16', '192.168.13.6' ]

# TODO capture timestamp instead of away_flag
# TODO only turn on lights on night time

def log(msg):
    print "%s: %s" % (datetime.now().strftime('%Y-%m-%d %H:%M:%S'), msg)

def is_home():
    for ip in ADDRESSES:
        DEVNULL = open(os.devnull, 'w') # TODO move outside loop
        ip_status = call(['ping', ip, '-q', '-w', '1', '-c', '1'], stdout=DEVNULL, close_fds=True)
        log("Found status of %s pinging %s" %(ip_status, ip))
        if ip_status == 0:
            print('returning true')
            return True
    print('returning false')
    return False

def have_guests():
    os.path.isfile('/etc/shawmut/have_guests')

def light_data():
    data = urllib2.urlopen('http://localhost:5000/api/environment').read()
    return json.loads(data)

def on_lights():
    list(name for (name, data) in light_data().iteritems() if data['state'] == 0)

def off_lights():
    list(name for (name, data) in light_data().iteritems() if data['state'] == 1)

def toggle_lights(lights):
    for l in lights:
        urllib2.urlopen("http://localhost:5000/api/device/%s" %l, '{"state":"toggle"}')

def turn_on_lights():
    found_off_lights = off_lights()
    if found_off_lights:
        log("Turning on lights: %s" %found_off_lights)
        toggle_lights(found_off_lights)

def turn_off_lights():
    found_on_lights = on_lights()
    if found_on_lights:
        log("Turning off lights: %s" %found_on_lights)
        toggle_lights(found_on_lights)

def main(away_flag):
    log("Starting. Away_flag set to %s" %away_flag)

    if have_guests():
        next
    elif is_home() and away_flag:
        # Just got home
        log('Just got home: Turning on any off lights and setting away_flag to False')
        turn_on_lights()
        away_flag = False
    elif not (is_home() and away_flag):
        #if we_are_away && !away_flag: turn off all lights and set away_flag
        # if not home, and away_flag is set to false => if not(false and true)
        # not (false and true)
        # Just left
        log('Just left: Turning off any on lights and setting away_flag to True')
        turn_off_lights()
        away_flag = True
    else:
        log("No changes, doing nothing")
    return away_flag


if __name__ == '__main__':

    away_flag = False
    while True:
        time.sleep(SCHEDULER_INTERVAL)
        away_flag = main(away_flag)
