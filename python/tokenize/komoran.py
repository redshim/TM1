#!/usr/bin/env python
# -*- coding: utf-8 -*-

#Komoran Class
from konlpy.utils import pprint
from konlpy.tag import Komoran
komoran = Komoran()


pprint(komoran.morphs(u'우왕 코모란도 오픈소스가 되었어요'))
pprint(komoran.nouns(u'오픈소스에 관심 많은 멋진 개발자님들!'))
pprint(komoran.pos(u'원칙이나 기체 설계와 엔진·레이더·항법장비 등'))

