from datetime import datetime
from requests_forecast import Forecast
from shawmut.settings import conf

class ShawmutWeather(object):
    MAX_RETRIES = 500 # We are allowed 1000 API calls per today so this is pretty conservative

    def __init__(self):
        self.todays_data = None
        self.get_todays_data()

    def get_todays_data(self):
        if not self.todays_data or datetime.now() > self.todays_date():
            self.daily_retries = 0
            try:
                forecast = Forecast(apikey=conf.forecast_io_key, latitude=conf.latitude, longitude=conf.longitude)
                self.todays_data = forecast.get_daily()['data'][0]
            except Exception as e:
                if self.retries < MAX_RETRIES:
                    self.retries +=1
                    log("Rescuing exception trying to get forecast data: %s %s. Keeping yesterday's data cached" %(e, e.message))
                    if self.todays_data is None:
                        self.get_todays_data()
                else:
                    log("Reached max number of retries. Re-raising exception %s" % e)
                    raise e

    def todays_date(self):
        # TODO test on UTC, why is this necessary?
        return self.todays_data['time'].replace(tzinfo=None).date()

    def todays_sunset_time(self):
        # TODO test on UTC, why is this necessary?
        return self.todays_data['sunsetTime'].replace(tzinfo=None)

    def todays_sunrise_time(self):
        # TODO test on UTC, why is this necessary?
        return self.todays_data['sunriseTime'].replace(tzinfo=None)

    def is_night_time(self):
        return (datetime.now() > self.todays_sunset_time() or datetime.now() < self.todays_sunrise_time())

    def is_dark(self):
        self.get_todays_data()
        # Later we can also check for other conditions like snow/rain in case we prob want to turn on lights
        return self.is_night_time()
