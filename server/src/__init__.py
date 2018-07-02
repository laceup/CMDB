from flask import Flask

app = Flask(__name__)

app.config.update(
    TESTING = True,
    TEMPLATES_AUTO_RELOAD = True,
)

app.debug = True

from .info import *
from .server import *
