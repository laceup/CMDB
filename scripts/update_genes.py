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
    return data[1:]

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
                'constraint_on': 'name'
            },
            'objects': data
        }
    }
    r = requests.post(HASURA_URL, data=json.dumps(payload)) 
    return r.status_code, r.json()


def main():
    data = read_csv_file('../data/gene_new_list.csv')
    upsert_data = []
    for row in data:
        upsert_data.append({
            'name': row[0],
            'uniprot_id': row[1],
            'ncbi_id': row[2] if row[2] else None,
            'ensembl_id': row[3],
            'mgi_id': row[4],
            'protein_name': row[5],
            'hgnc_id': row[6]
        })
    status_code, response = upsert('gene', upsert_data)
    if status_code != 200:
        print('upsert failed!', response)
    else:
        print('updated {} rows'.format(len(upsert_data)))

if __name__=='__main__':
    main()