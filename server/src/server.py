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
                    interactor_b_full
                    taxid_b

                }
                ppi_b{
                    
                    interactor_a
                    interactor_a_full
                    taxid_a
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


@app.route("/drug/")
def drug():
    return render_template(
        'drug.html',

    )
# --------------------------------------------------------------

@app.route("/drug/<id>")
def get_drug(id):
    data = query('''
        query getDrug($id: String){
        drug(where: {drug_type: {_eq: $id}}) {
            drug_name
            drug_type
            drug_product
            drugbank_id
            
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
    
    data={'name':id,'children':drug}
    
    

    
    return render_template(
        'drugnetwork.html',
        data=data,
        drug=drug,

    )
# mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

@app.route("/ppi/<name>")
def ppi(name):
    data = query('''
        query getPPI ($NAME: String) {
            all_genes: gene {
                uniprot_id
            }
            gene (where: {name: {_eq: $NAME}}) {
                uniprot_id
                ppi_a{
                    
                    interactor_b
                    interactor_b_full
                    taxid_b

                }
                ppi_b{
                    
                    interactor_a
                    interactor_a_full
                    taxid_a
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
    # source_uniprot =gene['uniprot_id']
    # if gene['ppi_a']['taxid_a']!=None:
    #     source_taxid = gene['ppi_a']['taxid_a']
    # else:
    #     source_taxid =gene['ppi_b']['taxid_b']
    # source_data={ interactor:name, organism:source_taxid ,interactor_full:name}

    link_ppi_a=gene['ppi_a']
    link_ppi_b=gene['ppi_b']
    for i in link_ppi_a:
        i['interactor']=i.pop('interactor_b')
        i['organism']=i.pop('taxid_b')
        i['interactor_full']=i.pop('interactor_b_full')
    for j in link_ppi_b:
        j['interactor']=j.pop('interactor_a')
        j['organism']=j.pop('taxid_a')
        j['interactor_full']=j.pop('interactor_a_full')    
    link_ppi=link_ppi_a + link_ppi_b
    link_ppi=[dict(t) for t in {tuple(d.items()) for d in link_ppi}]
    
    linksp=[]
    for i in link_ppi:
        linksp.append ({'source': {'interactor':name,'organism':'human','interactor_full':name},'target': i})
    
    node=link_ppi
    source_node={'interactor':name,'organism':'human','interactor_full':name}
    node.append({'interactor':name,'organism':'human','interactor_full':name})
    data={"nodes":node,"links":linksp}
    # for g in gene['ppi_b']:
    #     link_ppi.append(g["interactor_a"])

    # for g in gene['ppi_a']:
    #     link_ppi.append(g["interactor_b"])

    # # remove duplicates
    # link_ppi = list(set(link_ppi))

    # link_ppi = [{'interactor': x} for x in link_ppi]
    
    return render_template(
        'ppi.html',
        gene=gene,
        name=name,
        link_ppi=link_ppi,
        gene_list= gene_list,
        linksp=linksp,
        node=node,
        source_node=source_node,
        data=data,

    )
