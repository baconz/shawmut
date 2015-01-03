import yaml

class Settings(object):
    def __init__(self, yml_file):
        stream = open(yml_file, 'r')
        self.data = yaml.load(stream)

    def __getattr__(self, name):
        if name in self.data:
            return self.data[name]
        else:
            raise AttributeError

conf = Settings('/etc/shawmut/shawmut.yml')
