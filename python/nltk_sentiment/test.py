#!/usr/bin/env python
# -*- coding: utf-8 -*-
from konlpy.utils import pprint
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

# io module 
import io
# Encoding Unicode to UTF-8

def read_data(filename):
    with io.open(filename, 'r', encoding='utf-8') as f:
        data = [line.split('\t') for line in f.read().splitlines()]
        data = data[1:]   # header 제외
    return data
train_data = read_data('ratings_train.txt')
test_data = read_data('ratings_test.txt')


# row, column의 수가 제대로 읽혔는지 확인
print(len(train_data))      # nrows: 150000
print(train_data[0])   # ncols: 3
print(len(test_data))       # nrows: 50000
print(test_data[0])     # ncols: 3

pprint(train_data[0])
pprint(test_data[0])





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
train_docs = [(tokenize(row[1]), row[2]) for row in train_data]
test_docs = [(tokenize(row[1]), row[2]) for row in test_data]

pprint(train_docs[0])

tokens = [t for d in train_docs for t in d[0]]
print(len(tokens))
# => 2194536

import nltk
text = nltk.Text(tokens, name='NMSC')
print(text)
# => <Text: NMSC>

print(len(text.tokens))                 # returns number of tokens
# => 2194536
print(len(set(text.tokens)))            # returns number of unique tokens
# => 48765
pprint(text.vocab().most_common(10))    # returns frequency distribution


#text.collocations()

selected_words = [f[0] for f in text.vocab().most_common(2000)]


def term_exists(doc):
    #return {exists({}).format(word): (word in set(doc)) for word in selected_words}
    return {exists({}).format(word): (word in set(doc))}


# 시간 단축을 위한 꼼수로 training corpus의 일부만 사용할 수 있음



#train_docs = train_docs[:10000]
#train_xy = [(term_exists(d), c) for d, c in train_docs]
#test_xy = [(term_exists(d), c) for d, c in test_docs]
