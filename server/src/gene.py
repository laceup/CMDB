from src import app
from flask import render_template
from flask import jsonify
from flask import request
from flask import abort
from flask import redirect
from .hasura import query
import json

from .graphql import QUERY_GENE_BASIC, QUERY_GENE_GO, QUERY_GENE_EXAC,  QUERY_GENE_NHLBI, QUERY_GENE_PHENOTYPE , QUERY_GENE_PATHWWAYS, QUERY_GENE_PPI , QUERY_GENE_DRUG , QUERY_GENE_CLINVAR

@app.route("/gene/<name>/<tabname>")
def render_gene(name, tabname):
    queryString = getQueryForTab(tabname)
    if queryString is None:
        abort(404)
    
    all_genes = []
    response = query(queryString, {'name': name})
    if response is not None:
        if len(response['gene']) == 0:
            abort(404)
        else:
            gene = response['gene'][0]
        if 'all_genes' in response:
            all_genes = response['all_genes']
    else:
        abort(500)

    return render_template(
        't_'+tabname+'.html',
        gene=gene,
        tabname=tabname,
        all_genes=all_genes,
    )

def getQueryForTab(tabname):
    query_map = {
        'basic': QUERY_GENE_BASIC,
        'go': QUERY_GENE_GO,
        'exac':QUERY_GENE_EXAC,
        'nhlbi':QUERY_GENE_NHLBI,
        'phenotype':QUERY_GENE_PHENOTYPE,
        'ppi':QUERY_GENE_PPI,
        'pathways':QUERY_GENE_PATHWWAYS,
        'clinvar':QUERY_GENE_CLINVAR,
        'drug':QUERY_GENE_DRUG
    }
    if tabname in query_map:
        return query_map[tabname]
    return None