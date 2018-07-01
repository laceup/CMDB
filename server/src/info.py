import requests, json
from flask import jsonify, request, render_template
from src import app
from .hasura import query

@app.route("/api/genes")
def json_message():
    result=query('''
    query {
      ensembl {
        name
      }
    }
    ''')
    return jsonify(result=result)
