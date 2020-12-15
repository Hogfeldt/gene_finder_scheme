#!/bin/python
import sys

annotation = 'CCCNRRR'

predictions = [p.split() for p in sys.stdin.read()[2:-3].split(') (')]
for i, pred in enumerate(predictions):
    print(f">pred-ann{i+6}")
    anno = ''.join([annotation[int(s)] for s in pred])
    for j in range(60,len(anno),60):
        print(anno[j-60:j])
