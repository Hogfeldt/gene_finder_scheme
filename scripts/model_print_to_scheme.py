#!/bin/python
import sys

print(("(define model " 
    + "(list '(".join([s.replace('(', "'(") for s in 
        sys.stdin.read().replace('\n','').split('((')])
    + ")"))


