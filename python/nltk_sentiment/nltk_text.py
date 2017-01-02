#!/usr/bin/env python
# -*- coding: utf-8 -*-
from konlpy.utils import pprint
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import io

f = io.open('tokens1.csv','r',encoding='utf-8')
s = f.read()
tokens = s.split()
f.close()

print(len(tokens))

import nltk
text = nltk.Text(tokens, name='LDWS')
print(text)


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
