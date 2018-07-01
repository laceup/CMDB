from src import app
from flask import render_template
from flask import jsonify
from .hasura import query

@app.route("/")
def home():
    return render_template('home.html')

# Uncomment to add a new URL at /new


@app.route("/genes")
def genes():
    data = query('''
    query {
      ensembl {
        name
        ensembl_id
        start_bp
        end_bp
        chromosome_scaffold_name
      }
    }
    ''')

    return render_template(
        'list.html',
        **{
            'genes': data['ensembl']
        }
    )
