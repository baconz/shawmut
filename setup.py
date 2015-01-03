#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys

here = lambda *a: os.path.join(os.path.dirname(__file__), *a)

try:
    from setuptools import setup, find_packages
except ImportError:
    from distutils.core import setup

requirements = [x.strip() for x in open(here('requirements.txt')).readlines()]

setup(
    name='shawmut',
    version='0.0.1',
    description='Shawmut home automation suite',
    url='https://github.com/baconz/shawmut',
    packages=[ 'shawmut', ],
    package_dir={'shawmut': 'shawmut'},
    include_package_data=True,
    install_requires=requirements,
    zip_safe=False,
    entry_points={
        'console_scripts': [
            'auto_offd = shawmut.services.autooff:main'
        ]
    }
)
