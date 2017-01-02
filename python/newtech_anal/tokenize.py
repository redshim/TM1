#!/usr/bin/env python
# -*- coding: utf-8 -*-
from konlpy.utils import pprint
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import nltk
# io module
import io
# Encoding Unicode to UTF-8

def read_data(filename):
    with io.open(filename, 'r', encoding='utf-8') as f:
        data = [line.split('\t') for line in f.read().splitlines()]
        #data = data[1:]   # header 제외
    return data
k1_data = read_data('/home/6546788/Crawler_N/export/K0000001_head.csv')


# row, column의 수가 제대로 읽혔는지 확인
#print(len(k1_data))      # nrows: 150000
#print(k1_data[0])   # ncols: 3
#pprint(k1_data[0])

##################################################################################
# 1. Data preprocessing (feat. KoNLPy)
##################################################################################
###    형태소로 토크나이징
##################################################################################
from konlpy.tag import Twitter
pos_tagger = Twitter()
def tokenize(doc):
    # norm, stem은 optional
    return ['/'.join(t) for t in pos_tagger.pos(doc, norm=True, stem=True)]
k1_docs = [tokenize(row[0]) for row in k1_data]
#pprint(k1_docs[0])


tokens = [t for d in k1_docs for t in d]
print(len(tokens))


f = open('tokens.csv','w')
for t in tokens:
        f.write(t+'\n')
f.close

