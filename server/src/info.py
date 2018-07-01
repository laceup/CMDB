import requests, json
from flask import jsonify, request, render_template
from src import app

@app.route("/info")
def info():
    return render_template(
        'info.html',
        **{
            'base_domain': 'X-Hasura-Base-Domain',
            'user_id': 'X-Hasura-User-Id',
            'roles': 'X-Hasura-Allowed-Roles'
        }
    )
