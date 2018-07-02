from src import app
from flask import render_template
from flask import jsonify
from flask import request
from .hasura import query

@app.route("/")
def home():
    search_arg = request.args.get('search')
    result = {"ensembl":[]}
    is_search_page = False
    if search_arg:
        is_search_page = True
        result = query('''
            query {
              ensembl (where: {name: {_ilike: $ARG}}) {
                name,
                ensembl_id
                start_bp
                end_bp
                chromosome_scaffold_name
              }
            }
        ''', {"ARG": "%"+search_arg+"%"})
    return render_template(
        'home.html',
        **{
            "search": is_search_page,
            "results": result['ensembl'],
        }
    )

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
        'list.html', genes=data['ensembl']
    )

@app.route("/gene/<name>")
def gene_details(name):
    data = query('''
        query {
          ensembl (where: {name: {_eq: $NAME}}) {
            name,
            ensembl_id
            start_bp
            end_bp
            chromosome_scaffold_name
          }
        }
    ''', {'NAME': name})

    if len(data['ensembl']) == 0:
        gene = {}
    else:
        gene = data['ensembl'][0]
    
    return render_template(
        'details.html',
        gene=gene
    )
