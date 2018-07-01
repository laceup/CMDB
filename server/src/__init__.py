from flask import Flask

app = Flask(__name__)

from .info import *
from .server import *
