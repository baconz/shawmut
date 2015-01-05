#!/usr/bin/env python

import socket
import urllib2
import json
import time
import logging
import bluetooth
import os.path
from datetime import datetime
from optparse import OptionParser

from shawmut.settings import conf
from shawmut.weather import ShawmutWeather

SCHEDULER_INTERVAL = 5


class AutoOffPoller(object):
    def __init__(self, verbose=False):
        self.is_away = False
        self.weather = ShawmutWeather()
        self.verbose = verbose
        logging.basicConfig(level=logging.INFO,
                            format='%(asctime)s %(message)s')


    def check_if_home(self):
        for bd_addr in conf.bd_addrs:
            res = bluetooth.lookup_name(bd_addr)
            if res is not None:
                return True
        return False

    def has_guests(self):
        os.path.isfile('/etc/shawmut/has_guests')

    def get_light_data(self):
        try:
            data = urllib2.urlopen('http://localhost:5000/api/environment').read()
            return json.loads(data)
        except Exception as e:
            logging.error("Rescuing exception %s %s" %(e, e.message))
            return {}

    def off_lights(self):
        return list(name for (name, data) in self.get_light_data().iteritems() if data['state'] == 0)

    def on_lights(self):
        return list(name for (name, data) in self.get_light_data().iteritems() if data['state'] == 1)

    def toggle_lights(self, lights):
        # Race condition if someone turns on lights manually between finding off/on lights and toggling
        for l in lights:
            try:
                urllib2.urlopen("http://localhost:5000/api/device/%s" %l, '{"state":"toggle"}')
            except Exception as e:
                logging.error("Rescuing exception %s %s" %(e, e.message))

    def turn_on_lights(self):
        found_off_lights = self.off_lights()
        if found_off_lights:
            logging.debug("Turning on lights: %s" %(',').join(found_off_lights))
            self.toggle_lights(found_off_lights)

    def turn_off_lights(self):
        found_on_lights = self.on_lights()
        if found_on_lights:
            logging.debug("Turning off lights: %s" %(',').join(found_on_lights))
            self.toggle_lights(found_on_lights)

    def poll(self):
        logging.debug("Starting poll - is_away set to %s" % self.is_away)
        arrived_home = self.check_if_home()

        if self.has_guests():
            return
        elif arrived_home and self.is_away:
            logging.debug('Home james: Turning on any off lights and setting self.is_away to False')
            self.is_away = False
            if self.weather.is_dark():
                logging.debug("It's dark out: Turning off any on lights")
                self.turn_on_lights()
        elif not arrived_home and not self.is_away:
            logging.debug("Gonzo: Setting self.is_away to True and cheking if it's dark out")
            self.is_away = True
            self.turn_off_lights()
        else:
            logging.debug('No changes, doing nothing')


def main():
    parser = OptionParser()
    parser.add_option('-v', '--verbose',
                      action='store_true', dest='verbose', default=False,
                      help='Verbose logging')
    (options, args) = parser.parse_args()

    auto_off = AutoOffPoller(options.verbose)

    while True:
        auto_off.poll()
        time.sleep(SCHEDULER_INTERVAL)


if __name__ == '__main__':

    main()
