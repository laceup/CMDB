import requests
import json
from graphqlclient import GraphQLClient

client = GraphQLClient('http://raven:8080/v1alpha1/graphql')

def query(q, v=None):
    result = client.execute(q, v)
    return json.loads(result)['data']
