from src import app
from flask import render_template
from flask import jsonify
from flask import request
from flask import abort
from flask import redirect
from .hasura import query
import json

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
                ensembl_id
                protein_name
              }
            }
        ''', {"ARG": "%"+search_arg+"%"})
    return render_template(
        'home.html',
        **{
            "search": is_search_page,
            "search_arg": search_arg,
            "results": result['gene'],
        }
    )

@app.route("/genes/")
def genes():
    data = query('''
    query {
        is_cardiomyopathy {
            gene {
                name
                protein_name
                ensembl_id
                uniprot_id
                mgi_id
                ncbi_id
                tags {
                    tags
                }
                source {
                    source
                }
            }
        }
    }
    ''')
    # tags=data['gene'][0]['tags']
    # tags=[dict(t) for t in {tuple(d.items()) for d in tags if d['tags']!=''}] #edit
    

    return render_template(
        'list.html', 
        genes=data['is_cardiomyopathy'],
        # tags=tags
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
    return redirect("/gene/"+gene['name']+"/basic")

# --------------------------------------------------------------

@app.route("/drug/")
def drug():
    data = query('''
        query {
        drug {
            drug_type
            drug_type_id     
         
        }
        }
    ''', )  
    if data != None:
        if len(data['drug']) == 0:
            drug = {}
        else:
            drug = data['drug']
    else:
        drug = {}
    drug=[dict(t) for t in {tuple(d.items()) for d in drug}]
    return render_template(
        'drug.html',
        drug=drug,     
    )
# --------------------------------------------------------------

# --------------------------------------------------------------

@app.route("/help/")
def help():
     return render_template(
        'help.html',
    )

# -------------------------------------------------------------

@app.route("/drug/<id>")
def get_drug(id):
    data = query('''
        query getDrugs($id: Int!){
        drug(where: {drug_type_id: {_eq: $id}}) {
            drug_name
            drug_type
            drug_type_id
            drug_product
            drugbank_id
            drug_to_pathway{
              pathway
              smpdb{
                smpdb_id
                description
              }
            }
        }
        }
    ''', {'id': id}) 

    if data != None:
        if len(data['drug']) == 0:
            drug = {}
        else:
            drug = data['drug']
    else:
        drug = {}
    
    c=[]
    child=[]
    for i in drug:
        if len(i['drug_to_pathway'][0]['pathway']) != 0:
            # print(i['drug_to_pathway'])
            for j in i['drug_to_pathway']:
                c.append(j)
        child.append({"drug_name":i['drug_name'], "children":c})
        c=[]
    data={'name':drug[0]['drug_type'],'children':child}      
    return render_template(
        'drugnetwork.html',
        data=data,
        drug=drug
    )


# -------------------------------------------------------------

@app.route("/ppi/<name>")
def ppi(name):
    data = query('''
        query getGene($name: String!){
            gene (where: {name: {_eq: $name}}) {
                compartment {
                    derived_location   
                }
            }
        }
    ''', {'name': name})

    if data != None:
        if len(data['gene']) == 0:
            gene = {}
        else:
            gene = data['gene'][0]
    else:
        gene = {}

    # u_location=[dict(t) for t in {tuple(d.items()) for d in location}]
    
    return render_template(
        'ppi.html',
        gene=gene
    )
