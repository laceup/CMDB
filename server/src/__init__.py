import os
from flask import Flask

app = Flask(__name__)

PRODUCTION = os.getenv('PRODUCTION')
APP_ROOT = os.getenv('APP_ROOT', '/')

if PRODUCTION is None:
    app.config.update(
        TESTING = True,
        TEMPLATES_AUTO_RELOAD = True,
    )
    app.debug = True

if APP_ROOT is not None:
    app.config.update(
        APPLICATION_ROOT = APP_ROOT,
    )

from .info import *
from .server import *
from .gene import *
