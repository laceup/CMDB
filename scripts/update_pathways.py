from __future__ import print_function
import csv
import requests
import json

HASURA_URL = 'http://localhost:8080/v1/query'

def read_csv_file(name):
    """
    Reads the CSV file 'name' which contains column names
    as first row and return the data as array of arrays
    """
    with open(name) as f:
        data = []
        r = csv.reader(f)
        for row in r:
            data.append(row)
    return data[:]

def chunkify(data, size):
    """
    Splits array data into chunks of 'size' elements
    returns an array of arrays
    """
    chunks=[]
    for i in range(0,len(data),size):
        chunks.append(data[i:i+size])
    return chunks

def upsert(table, data):
    """
    Insert or update if exists to the specified table
    """
    payload = {
        'type': 'insert',
        'args': {
            'table': table,
            'on_conflict': {
                'action': 'update',
                'constraint_on': ["name","data","external_id"]
            },
            'objects': data
        }
    }
    r = requests.post(HASURA_URL, data=json.dumps(payload)) 
    return r.status_code, r.json()


def main():
    data = read_csv_file('../data/pathways_new.csv')
    upsert_data = []
    for row in data:
        upsert_data.append({
            'name': row[0],
            'data': row[1],
            'external_id': row[2] if row[2] else None,
            'source': row[3],
        })
    chunks = chunkify(upsert_data, 1000)
    for chunk in chunks:
        status_code, response = upsert('pathway', chunk)
        if status_code != 200:
            print('upsert failed!', response)
        else:
            print('updated {} rows'.format(len(chunk)))

if __name__=='__main__':
    main()


    