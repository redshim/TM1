#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf-8')
from konlpy.utils import pprint


from konlpy.corpus import kobill
docs_ko = [kobill.open(i).read() for i in kobill.fileids()]


from konlpy.tag import Twitter; t=Twitter()
pos = lambda d: ['/'.join(p) for p in t.pos(d, stem=True, norm=True)]
texts_ko = [pos(doc) for doc in docs_ko]


#encode tokens to integers
from gensim import corpora
dictionary_ko = corpora.Dictionary(texts_ko)
dictionary_ko.save('ko.dict')  # save dictionary to file for future use

#calulate TF-IDF
from gensim import models
tf_ko = [dictionary_ko.doc2bow(text) for text in texts_ko]
tfidf_model_ko = models.TfidfModel(tf_ko)
tfidf_ko = tfidf_model_ko[tf_ko]
corpora.MmCorpus.serialize('ko.mm', tfidf_ko) # save corpus to file for future use

#train topic model
#LSI
ntopics, nwords = 3, 5
lsi_ko = models.lsimodel.LsiModel(tfidf_ko, id2word=dictionary_ko, num_topics=ntopics)
pprint(lsi_ko.print_topics(num_topics=ntopics, num_words=nwords))

#LDA
import numpy as np; np.random.seed(42)  # optional
lda_ko = models.ldamodel.LdaModel(tfidf_ko, id2word=dictionary_ko, num_topics=ntopics)
pprint(lda_ko.print_topics(num_topics=ntopics, num_words=nwords))

#HDP
import numpy as np; np.random.seed(42)  # optional
hdp_ko = models.hdpmodel.HdpModel(tfidf_ko, id2word=dictionary_ko)
pprint(hdp_ko.print_topics(topics=ntopics, topn=nwords))
