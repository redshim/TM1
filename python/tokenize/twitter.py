#!/usr/bin/env python
# -*- coding: utf-8 -*-

from konlpy.utils import pprint
from konlpy.tag import Twitter


twitter = Twitter()
pprint(twitter.morphs(u'작고 노란 강아지가 페르시안 고양이에게 짖었다'))
pprint(twitter.nouns(u'작고 노란 강아지가 페르시안 고양이에게 짖었다'))
pprint(twitter.phrases(u'작고 노란 강아지가 페르시안 고양이에게 짖었다'))
pprint(twitter.pos(u'작고 노란 강아지가 페르시안 고양이에게 짖었다', norm=True))
