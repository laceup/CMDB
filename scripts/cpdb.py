
# coding: utf-8

# In[21]:


import csv
data=[]
with open('david2.csv') as f:
    data=[]
    reader = csv.reader(f, delimiter=',')
    for row in reader:
        data.append(row)


# In[23]:


newdata=[]
for row in data:
    genes = row[5]
    for gene in genes.split(','):
        newrow = [gene]
        newrow.extend(row[:-1])
        newdata.append(newrow)
print newdata

with open('david3_new.csv', 'wb') as csvfile:
    writer = csv.writer(csvfile, delimiter=',', quotechar='"')
    for row in newdata:
        writer.writerow(row)
