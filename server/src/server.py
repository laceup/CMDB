from src import app
from flask import render_template
from flask import jsonify
from flask import request
from flask import abort
from flask import redirect
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
@app.route("/uniprot/<id>")
def get_uniprot(id):
    data = query('''
        query getGeneByUniprot($id: String) {
            gene (where: {uniprot_id: {_eq: $id}}) {
                name
            }
        }
    ''', {'id': id})
    if data != None:
        if len(data['gene']) == 0:
            return abort(404)
        else:
            gene = data['gene'][0]
    else:
        return abort(404)
    return redirect("/gene/"+gene['name'])
        

@app.route("/gene/<name>")
def gene_details(name):
    data = query('''
        query getGeneDetails ($NAME: String) {
            all_genes: gene {
                uniprot_id
            }
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
                drug_target{
                  drug_id
                  gene_name
                  drug_name{
                    drug_name
                  }
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

    gene_list = [x['uniprot_id'] for x in data['all_genes']]
    # for ppi------------------------------

    link_ppi=[]
    for g in gene['ppi_b']:
        link_ppi.append(g["interactor_a"])

    for g in gene['ppi_a']:
        link_ppi.append(g["interactor_b"])

    # remove duplicates
    link_ppi = list(set(link_ppi))

    link_ppi = [{'interactor': x} for x in link_ppi]

    # for drug d3 network -----------------------
    if data != None:
        if len(data['gene']) == 0:
            link = {}
        else:
            link = data['gene'][0]['drug_target']
    else:
        link = {}

    return render_template(
        'details.html',
        gene=gene,
        link=link,
        name=name,
        link_ppi=link_ppi,
        gene_list= gene_list,
       
    )


# --------------------------------------------------------------


@app.route("/drug/<name>")
def drug(name):
    data = query('''
        query getDrug ($NAME: String) {
            gene (where: {name: {_eq: $NAME}}) {
                 drug_target{
                  drug_id
                  gene_name
                  drug_name{
                    drug_name
                  }
                }
            }
        }
    ''', {'NAME': name})

    if data != None:
        if len(data['gene']) == 0:
            link = {}
        else:
            link = data['gene'][0]['drug_target']
    else:
        link = {}
    
    return render_template(
        'drug.html',
        link=link,
        name=name
    )
