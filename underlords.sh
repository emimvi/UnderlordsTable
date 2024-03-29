#! /usr/bin/env python3
import csv
import sys
from collections import defaultdict

if len(sys.argv) != 2:
    print('Need a heroes.csv file argument')
    exit()

input_file = sys.argv[1]

Table = defaultdict(lambda: defaultdict(list))
Classes = set()

# Read into [Race][Class]=Heroes dictionary
# Keeping track of Classes to be used as header
with open(input_file, newline='') as csvfile:
    parser = csv.DictReader(csvfile, delimiter=',')
    for row in parser:
        c = row['Class']
        r = row['Race']
        c2 = row['Class2']
        r2 = row['Race2']
        h = row['Hero']
        Table[r][c].append(h)
        if c2 != '':
            Table[r][c2].append(h)
        if r2 != '':
            Table[r2][c].append(h)
        Classes |= {c, c2}

# Write to csv, converting Heroes lists to strings seperated by newline
w = csv.DictWriter(sys.stdout, sorted(Classes) )
w.writeheader()
for key,val in (sorted(Table.items())):
    strdict = {}
    for k,v in val.items():
        strdict[k] = '\n'.join(v)
    row = {'': key}
    row.update(strdict)
    w.writerow(row)
