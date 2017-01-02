#!/usr/bin/env python
# -*- coding: utf-8 -*-


from konlpy.corpus import kolaw
from konlpy.tag import Mecab
from konlpy import utils
constitution = kolaw.open('constitution.txt').read()
idx = utils.concordance(u'대한민국', constitution, show=True)
idx
