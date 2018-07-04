import requests
import json
import urllib
from graphqlclient import GraphQLClient

client = GraphQLClient('http://raven:8080/v1alpha1/graphql')

def query(q, v=None):
    result=""
    try:
        result= client.execute(q, v)
    except urllib.error.HTTPError as e:
        print(e.code, e.reason)
    return json.loads(result)['data']
