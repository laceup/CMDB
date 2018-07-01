
# coding: utf-8

# In[1]:


import csv

FILE_NAME = "uniprot-go-correct.csv"
## Columns:
# 0: "Entry"
# 1: "Gene ontology (biological process)"
# 2: "Gene ontology (cellular component)"
# 3: "Gene ontology (GO)"
# 4: "Gene ontology (molecular function)"
# 5: "Gene ontology IDs"

def loadData():
    all_data = []
    with open(FILE_NAME) as f:
        r = csv.reader(f)
        for row in r:
            all_data.append(row)
    return all_data[1:]
    
all_data = loadData()


# In[2]:


import re
regex = r"\ *(.+)\ \[(GO:\d{7})\]"

def parseGO():
    all_go = {}
    raw_data = {}
    for row in all_data:
        i_col = -1
        name = ""
        for col in row:
            i_col+=1
            if i_col == 0:
                name = col
                raw_data[col] = {
                    "bp": [],
                    "cc": [],
                    "go": [],
                    "mf": []
                }
                continue
            if i_col == 5:
                continue
            gos = col.split(";")
            for go in gos:
                matches = re.search(regex, go)
                if matches != None:
                    go_string = matches.group(1)
                    go_id = matches.group(2)
                    all_go[go_id] = go_string
                    if i_col == 1:
                        raw_data[name]["bp"].append(go_id)
                    if i_col == 2:
                        raw_data[name]["cc"].append(go_id)
                    if i_col == 3:
                        raw_data[name]["go"].append(go_id)
                    if i_col == 4:
                        raw_data[name]["mf"].append(go_id)
                        
    return raw_data, all_go

raw_data, all_go = parseGO()


# In[4]:


HASURA_URL = "http://localhost:8080/v1/query"
import requests
import json

def insertGOdata():
    q = {
        "type": "insert",
        "args": {
            "table": "gene_ontology",
            "on_conflict": {
                "action": "update",
                "constraint_on": ["id"]
            },
            "objects": [{"id": k, "text": all_go[k]} for k in all_go]
        }
    }
    r = requests.post(HASURA_URL, data=json.dumps(q))
    print r.json()

insertGOdata()


# In[6]:


def insertRawData():
    for_cc = []
    for_bp = []
    for_go = []
    for_mf = []
    for gene in raw_data:
        for cat in raw_data[gene]:
            for go in raw_data[gene][cat]:
                if cat == "cc":
                    for_cc.append({"name": gene, "go_id": go})
                if cat == "bp":
                    for_bp.append({"name": gene, "go_id": go})
                if cat == "go":
                    for_go.append({"name": gene, "go_id": go})
                if cat == "mf":
                    for_mf.append({"name": gene, "go_id": go})
    q = {
        "type": "bulk",
        "args": [
            {
                "type": "insert",
                "args": {
                    "table": "go_cellular_component",
                    "objects": for_cc
                }
            },
            {
                "type": "insert",
                "args": {
                    "table": "go_biological_process",
                    "objects": for_bp
                }
            },
            {
                "type": "insert",
                "args": {
                    "table": "go_molecular_function",
                    "objects": for_mf
                }
            }
        ]
    }
    r = requests.post(HASURA_URL, data=json.dumps(q))
    print r.json()
    #print for_cc

insertRawData()

