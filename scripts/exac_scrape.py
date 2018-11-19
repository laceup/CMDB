# coding: utf-8

# In[21]:


import requests
import json
import time

def getUrlForEnsemblId(id):
    return "http://exac.hms.harvard.edu/rest/gene/variants_in_gene/"+id

HASURA_URL = "http://localhost:8080/v1/query"
HEADERS = {'X-HASURA-ACCESS-KEY':'abcd'}

def getEnsemblIds():
    q = {
        "type": "select",
        "args": {
            "table": "gene",
            "columns": ["ensembl_id", {"name": "exac", 'columns':['id']}]
        }
    }
    r = requests.post(HASURA_URL, data=json.dumps(q),headers=HEADERS)
    if r.status_code != 200:
        print('error: ', r.status_code, r.json())
        return None
    data = r.json()
    ret_data = []
    for row in data:
        if len(row['exac']) == 0: 
            ret_data.append(row)
    return ret_data

def getExacDataForEnsemblId(id):
    r = requests.get(getUrlForEnsemblId(id))
    if r.status_code != 200:
        print('failed getting exac data for', id, r.status_code)
        return None
    return r.json()

def split(arr, size):
     arrs = []
     while len(arr) > size:
         pice = arr[:size]
         arrs.append(pice)
         arr = arr[size:]
     arrs.append(arr)
     return arrs

def insertDataForEnsemblId(id, data):
    for el in data:
        el["ensembl_id"] = id
    decons_data = split(data, 50)
    q = {
        "type": "bulk",
        "args": [
        ]
    }
    for d in decons_data:
        q["args"].append(
            {
                "type": "insert",
                "args": {
                    "table": "exac",
                    "objects": d
                }
            }
        )
    # q["args"].append(
    #     {
    #         "type": "update",
    #         "args": {
    #             "table": "ensembl",
    #             "$set": {
    #                 "has_exac": True
    #             },
    #             "where": {
    #                 "ensembl_id": id
    #             }
    #         }
    #     }
    # )
    r = requests.post(HASURA_URL, data=json.dumps(q),headers=HEADERS)
    return r.status_code, r.json()

def run():
    objs = getEnsemblIds()
    for obj in objs:
        id = obj["ensembl_id"]
        print("processing ", id)
        data = getExacDataForEnsemblId(id)
        if data is not None:
            code, resp = insertDataForEnsemblId(id, data)
            if code != 200:
                print("failed ", id)
                print(id, code, data, resp)
            else:
                print("processed ", id)
                time.sleep(2)



# In[24]:


run()

# x = [e['ensembl_id'] for e in getEnsemblIds()]
# print(str(x))

