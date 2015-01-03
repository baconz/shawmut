#!/usr/bin/env python

import socket
import urllib2
import json
import os.path
import time
from datetime import datetime
from shawmut.settings import conf
from shawmut.weather import ShawmutWeather

SCHEDULER_INTERVAL = 5
CONNECTION_TIMEOUT = 10

class AutoOffPoller(object):
    def __init__(self):
        self.is_away = False
        self.weather = ShawmutWeather()

    def log(self, msg):
        print "%s: %s" % (datetime.now().strftime('%Y-%m-%d %H:%M:%S'), msg)

    def check_if_home(self):
        for ip in conf.iphone_ips:
            try:
                conn = socket.create_connection((ip, 62078), CONNECTION_TIMEOUT)
                return True
            except socket.timeout:
                self.log("Timed out: %s is not connected to our network" % ip)
        return False

    def have_guests(self):
        os.path.isfile('/etc/shawmut/have_guests')

    def light_data(self):
        try:
            data = urllib2.urlopen('http://localhost:5000/api/environment').read()
            return json.loads(data)
        except Exception as e:
            self.log("Rescuing exception %s %s" %(e, e.message))
            return {}

    def off_lights(self):
        return list(name for (name, data) in self.light_data().iteritems() if data['state'] == 0)

    def on_lights(self):
        return list(name for (name, data) in self.light_data().iteritems() if data['state'] == 1)

    def toggle_lights(self, lights):
        # Race condition if someone turns on lights manually between finding off/on lights and toggling/
        for l in lights:
            try:
                urllib2.urlopen("http://localhost:5000/api/device/%s" %l, '{"state":"toggle"}')
            except Exception as e:
                self.log("Rescuing exception %s %s" %(e, e.message))

    def turn_on_lights(self):
        found_off_lights = self.off_lights()
        if found_off_lights:
            self.log("Turning on lights: %s" %(',').join(found_off_lights))
            self.toggle_lights(found_off_lights)

    def turn_off_lights(self):
        found_on_lights = self.on_lights()
        if found_on_lights:
            self.log("Turning off lights: %s" %(',').join(found_on_lights))
            self.toggle_lights(found_on_lights)

    def poll(self):
        self.log("Starting. is_away set to %s" % self.is_away)
        is_home = self.check_if_home()

        if self.have_guests():
            next
        elif is_home and self.is_away:
            self.log('Home james: Turning on any off lights and setting self.is_away to False')
            self.turn_on_lights()
            self.is_away = False
        elif not is_home and not self.is_away:
            self.log('Gonzo: setting self.is_away to True and cheking if it\'s dark out')
            self.is_away = True
            if self.weather.is_dark():
                self.log('It\s nightime: Turning off any on lights')
                self.turn_off_lights()
        else:
            self.log('No changes, doing nothing')

def main():
    auto_off = AutoOffPoller()

    while True:
        auto_off.poll()
        time.sleep(SCHEDULER_INTERVAL)


if __name__ == '__main__':
    main()
