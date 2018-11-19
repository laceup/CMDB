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

# ---------- details.html -----------------        

# @app.route("/gene/<name>")
# def gene_details(name):
    # data = query('''
    #     query getGeneDetails ($NAME: String) {
    #         all_genes: gene {
    #             uniprot_id
    #         }
    #         gene (where: {name: {_eq: $NAME}}) {
    #             name
    #             protein_name
    #             ensembl_id
    #             uniprot_id
    #             mgi_id
    #             ncbi_id

    #             proteins {
    #                 gene_synonyms
    #             }
                
    #             ensembl {
    #                 chromosome_scaffold_name
    #                 start_bp
    #                 end_bp
    #                 transcript_count
    #                 percentage_gc_content
    #             }
    #             go_cellular_component {
    #                 go {
    #                     id
    #                     text
    #                 }
    #             }
    #             go_molecular_function {
    #                 go {
    #                     id
    #                     text
    #                 }
    #             }
    #             go_biological_process {
    #                 go {
    #                     id
    #                     text
    #                 }
    #             }
    #             phenotype{
    #                 mp_id
    #                 mp_def{
    #                     term
    #                     definition
    #                 }
    #             }
    #             exac{
    #                 variant_id
    #                 allele_freq
    #                 allele_num
    #                 allele_count
    #                 major_consequence
    #                 rsid
    #                 HGVSc
    #                 pop_ans
    #                 pop_acs           
    #             }
    #             nhlbi{
    #                 base_ncbi_37
    #                 rsid
    #                 function_gvs
    #                 hgvs_protein_variant
    #                 african_american_allele_count
    #                 european_american_allele_count
    #             }
    #             pathways{
    #                 data
    #                 external_id
    #                 source
    #             }
    #             ppi_a{
                    
    #                 interactor_b
    #                 interactor_b_full
    #                 taxid_b

    #             }
    #             ppi_b{
                    
    #                 interactor_a
    #                 interactor_a_full
    #                 taxid_a
    #             }
    #             drug_target{
    #               drug_id
    #               gene_name
    #               drug_name{
    #                 drug_name
    #               }
    #             }
    #               clinvar{
    #                 hgvsc
    #                 hgvsp
    #                 type
    #                 phenotypelist
    #                 clinical_significance
    #                 phenotypeids
    #                 rs_dbsnp    
    #             }
    #         }
    #     }
    # ''', {'NAME': name})

    # if data != None:
    #     if len(data['gene']) == 0:
    #         gene = {}
    #     else:
    #         gene = data['gene'][0]
    # else:
    #     gene = {}

    # gene_list = [x['uniprot_id'] for x in data['all_genes'] if x is not None]
    # # for ppi------------------------------

    # # link_ppi=[]
    # # for g in gene['ppi_b']:
    # #     link_ppi.append(g["interactor_a"])

    # # for g in gene['ppi_a']:
    # #     link_ppi.append(g["interactor_b"])

    # # 
    # # link_ppi = list(set(link_ppi))

    # # link_ppi = [{'interactor': x} for x in link_ppi]

    # link_ppi_a=gene['ppi_a']
    # link_ppi_b=gene['ppi_b']
    # for i in link_ppi_a:
    #     i['interactor']=i.pop('interactor_b')
    #     i['organism']=i.pop('taxid_b')
    #     i['interactor_full']=i.pop('interactor_b_full')
    # for j in link_ppi_b:
    #     j['interactor']=j.pop('interactor_a')
    #     j['organism']=j.pop('taxid_a')
    #     j['interactor_full']=j.pop('interactor_a_full')    
    # link_ppi=link_ppi_a + link_ppi_b
    # link_ppi=[dict(t) for t in {tuple(d.items()) for d in link_ppi}] # remove duplicates
    
    # linksp=[]
    # for i in link_ppi:
    #     linksp.append ({'source': {'interactor':name,'organism':'human','interactor_full':name},'target': i})
    
    # node=link_ppi
    # # source_node={'interactor':name,'organism':'human','interactor_full':name}
    # node.append({'interactor':name,'organism':'human','interactor_full':name})
    # ppidata={"nodes":node,"links":linksp}

    # # for drug d3 network -----------------------
    # if data != None:
    #     if len(data['gene']) == 0:
    #         link = {}
    #     else:
    #         link = data['gene'][0]['drug_target']
    # else:
    #     link = {}
    # drug_link= [x for x in link if x['drug_name'] != None]

    # return render_template(
    #     'details.html',
    #     gene=gene,
    #     drug_link=drug_link,
    #     name=name,
    #     link_ppi=link_ppi,
    #     gene_list= gene_list,
    #     data=ppidata,
       
    # )

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

# @app.route("/drug/<id>")
# def get_drug(id):
#     data = query('''
#         query getDrug($id: Int!){
#         drug(where: {drug_type_id: {_eq: $id}}) {
#             drug_name
#             drug_type
#             drug_type_id
#             drug_product
#             drugbank_id
#             drug_to_target(where: {david: {}}){
#               gene_name
#               david{
#                 category
#                 term_def
#               }
#             }
#         }
#         }
#     ''', {'id': id})   
#     if data != None:
#         if len(data['drug']) == 0:
#             drug = {}
#         else:
#             drug = data['drug']
#     else:
#         drug = {}
#     c=[]
#     child=[]
#     for i in drug:
#         if len(i['drug_to_target']) != 0:
#             for j in i['drug_to_target'][0]['david']:
#                 c.append(j)
#         child.append({"drug_name":i['drug_name'], "children":c})
#         c=[]


#     data={'name':drug[0]['drug_type'],'children':child} 
#     return render_template(
#         'drugnetwork.html',
#         data=data,
#         drug=drug,

#     )

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


# mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

@app.route("/ppi/<name>")
def ppi(name):
    data = query('''
        query getGene($NAME: String){
            compartment(where: {gene_name: {_eq: $NAME}}) {
                derived_location   
            }
        }
    ''', {'NAME': name})

    if data != None:
        if len(data['compartment']) == 0:
            location = {}
        else:
            location = data['compartment']
    else:
        location = {}

    u_location=[dict(t) for t in {tuple(d.items()) for d in location}]
    
    return render_template(
        'ppi.html',
        u_location=u_location,

    )
