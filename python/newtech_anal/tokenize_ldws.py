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

# K0000001 : LDWS 차선이탈 경보 수집 파일
k1_data = read_data('/home/6546788/Crawler_N/export/K0000001_head.csv')


##################################################################################
### 1. Data preprocessing (feat. KoNLPy)
##################################################################################
###    - 형태소로 토크나이징
##################################################################################
from konlpy.tag import Twitter
pos_tagger = Twitter()
def tokenize(doc):
    # norm, stem은 optional
    return ['/'.join(t) for t in pos_tagger.pos(doc, norm=True, stem=True)]

#k1_docs = [tokenize(row[0]) for row in k1_data]
k1_docs_noun = [pos_tagger.nouns(row[0]) for row in k1_data]


tokens = [t for d in k1_docs_noun for t in d]


##################################################################################
### 2. 불용어 특수문자 제거 filter
##################################################################################
def token_filter(tokens) :
	f_tokens=[]
	for t in tokens:
		if t[0] == " ":
			continue
		elif t[0] == '.':
			continue
		elif len(t)<2:
			continue
		elif t[0] == '"':
			continue
		else:
			f_tokens.append(t)
	return f_tokens

tokens_fin = token_filter(tokens)

import nltk
text = nltk.Text(tokens_fin, name='LDWS Problem')

print(len(text.tokens))                 # returns number of tokens
print(len(set(text.tokens)))            # returns number of unique tokens
pprint(text.vocab().most_common(30))    # returns frequency distribution


#text.collocations()

selected_words = [f[0] for f in text.vocab().most_common(2000)]
#pprint(selected_words)


##################################################################################
### 3. 워드 카운트 파일 저장 
##################################################################################
f = io.open('word_count_ldws.csv','w',encoding='utf-8')
for t in text.vocab().most_common(2000):
        f.write(t[0]+','+str(t[1])+'\n')
f.close

