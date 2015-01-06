from datetime import datetime
from requests_forecast import Forecast
from shawmut.settings import conf

MAX_RETRIES = 500 # We are allowed 1000 API calls per today so this is pretty conservative


class ShawmutWeather(object):

    def __init__(self):
        self.todays_data = None
        self.get_todays_data()

    def get_todays_data(self):
        if not self.todays_data or datetime.now().date() > self.todays_date():
            retries = 0
            try:
                forecast = Forecast(apikey=conf.forecast_io_key, latitude=conf.latitude, longitude=conf.longitude)
                self.todays_data = forecast.get_daily()['data'][0]
            except Exception as e:
                if retries < MAX_RETRIES:
                    retries +=1
                    logging.error("Rescuing exception trying to get forecast data: %s %s. Keeping yesterday's data cached" %(e, e.message))
                    if self.todays_data is None:
                        self.get_todays_data()
                else:
                    logging.critical("Reached max number of retries. Re-raising exception %s" % e)
                    raise e

    def todays_date(self):
        # Assumes prodcution env is UTC
        return self.todays_data['time'].utcnow().date()

    def todays_sunset_time(self):
        # Assumes prodcution env is UTC
        return self.todays_data['sunsetTime'].utcnow()

    def todays_sunrise_time(self):
        # Assumes prodcution env is UTC
        return self.todays_data['sunriseTime'].utcnow()

    def is_night_time(self):
        return (datetime.now() > self.todays_sunset_time() or datetime.now() < self.todays_sunrise_time())

    def is_dark(self):
        self.get_todays_data()
        # Later we can also check for other conditions like snow/rain in case we prob want to turn on lights
        return self.is_night_time()
