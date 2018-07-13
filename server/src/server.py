from src import app
from flask import render_template
from flask import jsonify
from flask import request
from .hasura import query

@app.route("/")
def home():
    search_arg = request.args.get('search')
    result = {"gene":[]}
    is_search_page = False
    if search_arg:
        is_search_page = True
        result = query('''
            query getEnsembl ($ARG: String){
              gene (where: {name: {_ilike: $ARG}}) {
                name
                protein_name
              }
            }
        ''', {"ARG": "%"+search_arg+"%"})
    return render_template(
        'home.html',
        **{
            "search": is_search_page,
            "results": result['gene'],
        }
    )

@app.route("/genes/")
def genes():
    data = query('''
    query {
        gene {
            name
            protein_name
            ensembl_id
            uniprot_id
            mgi_id
            ncbi_id
        }
    }
    ''')

    return render_template(
        'list.html', genes=data['gene']
    )

@app.route("/gene/<name>")
def gene_details(name):
    data = query('''
        query getGeneDetails ($NAME: String) {
            gene (where: {name: {_eq: $NAME}}) {
                name
                protein_name
                ensembl_id
                uniprot_id
                mgi_id
                ncbi_id
                
                ensembl {
                    chromosome_scaffold_name
                    start_bp
                    end_bp
                    transcript_count
                    percentage_gc_content
                }
                go_cellular_component {
                    go {
                        id
                        text
                    }
                }
                go_molecular_function {
                    go {
                        id
                        text
                    }
                }
                go_biological_process {
                    go {
                        id
                        text
                    }
                }
                phenotypes {
                    phenotype
                    term
                    definition
                }
                exac{
                    variant_id
                    allele_freq
                    allele_num
                    allele_count
                    major_consequence
                
                }
                pathways{
                    data
                    external_id
                    source
                }
                ppi_a{
                    interactor_b
                }
                ppi_b{
                    interactor_a
                }
            }
        }
    ''', {'NAME': name})

    if data != None:
        if len(data['gene']) == 0:
            gene = {}
        else:
            gene = data['gene'][0]
    else:
        gene = {}
    
    # result = data['gene'][0]
    my_sample_data = [{"name": name,"size":50}]
    my_connections = []
    interactors = []

    for g in gene['ppi_b']:
        interactors.append(g["interactor_a"])

    for g in gene['ppi_a']:
        interactors.append(g["interactor_b"])

    # remove duplicates
    interactors = list(set(interactors))

    for interactor in interactors:
        my_sample_data.append({"name": interactor,"size":20})
        my_connections.append({"source": name, "target": interactor})

    return render_template(
        'details.html',
        gene=gene,
        my_sample_data= my_sample_data,
        my_connections=my_connections
    )
# --------------------------------------------------------------
@app.route("/ppi/<name>")
def ppi_a(name):
    data = query('''
        query getPpi ($NAME: String) {
            gene (where: {name: {_eq: $NAME}}) {
                 ppi_a{
                    interactor_b
                }
                ppi_b{
                    interactor_a
                }
            }
        }
    ''', {'NAME': name})
    
    gene = name
    result = data['gene'][0]
    my_sample_data = [{"name": gene,"size":2}]
    my_connections = []
    interactors = []

    for g in result['ppi_b']:
        interactors.append(g["interactor_a"])

    for g in result['ppi_a']:
        interactors.append(g["interactor_b"])

    # remove duplicates
    interactors = list(set(interactors))

    for interactor in interactors:
        my_sample_data.append({"name": interactor,"size":1})
        my_connections.append({"source": gene, "target": interactor})

    return render_template(
        'ppi.html',
        gene=gene,
        my_sample_data= my_sample_data,
        my_connections=my_connections
    )
