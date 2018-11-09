import requests
import json

HASURA_URL = 'http://raven:8080/v1alpha1/graphql'

def query(q, v=None):
    payload = {
        "query": q,
        "variables": v
    }

    print("===============================================")
    print("query: ", q)
    print("variables: ", v)
    r = requests.post(HASURA_URL, data=json.dumps(payload).encode('utf-8'))
    if r.status_code != 200:
        print("request failed: ", r.status_code)
        print("response text: ", r.text)
        print("===============================================")
        return None
    else:
        print("response code: ", r.status_code)
        print("===============================================")
        return r.json()['data']
