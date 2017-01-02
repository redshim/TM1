#!/usr/bin/env python
# -*- coding: utf-8 -*-

#Hannanum Class
from konlpy.utils import pprint
from konlpy.tag import Hannanum
hannanum = Hannanum()
pprint(hannanum.analyze(u'롯데마트의 흑마늘 양념 치킨이 논란이 되고 있다.'))
pprint(hannanum.morphs(u'롯데마트의 흑마늘 양념 치킨이 논란이 되고 있다.'))
pprint(hannanum.nouns(u'다람쥐 헌 쳇바퀴에 타고파'))
pprint(hannanum.pos(u'웃으면 더 행복합니다!'))
