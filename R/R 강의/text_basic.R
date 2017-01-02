#
# 라이브러리 설치
#

install.packages('rvest')
install.packages('dplyr')

#
# 라이브러리 불러오기
#

library(httr)
library(dplyr)
library(rvest)


#
# 1 페이지 게시물 제목 보기
#
bobaedream = 'http://www.bobaedream.co.kr/list?code=national&s_cate=&maker_no=&model_no=&or_gu=10&or_se=desc&s_selday=&pagescale=30&info3=&noticeShow=&s_select=&s_key=&level_no=&vdate=&type=list&page=2'

page = 1
url = modify_url(bobaedream, query=list(page=1))
board = read_html(url,encoding="UTF-8")
board

board %>% html_nodes('.bsubject') %>% html_text()



board %>%
  html_node('ul') %>% html_node('a') %>%
  html_attr('href')



#
# 1 페이지 게시물 주소(URL) 보기
#
posts = board %>%
  html_nodes('.content-list.li.a') %>%
  html_attr('href')
posts

#
# 상대 주소를 절대 주소로 바꾸기
#
posts = board %>%
  html_nodes('a.bodyCont') %>%
  html_attr('href') %>%
  xml2::url_absolute(bobaedream)
posts

#
# 10번째 게시물 본문 가져오기
#
post = read_html(posts[10])
post %>%
  html_nodes('.bodyCont') %>%
  html_text()

post

#
# 1~3페이지까지 반복해서 접속
#
for(page in 1:3){
  url = modify_url(bobaedream, query=list(page=1))
  board = read_html(url)기
  break # 멈춤
}


#
# 게시물 목록에 있는 모든 게시물 열어보기
#
post_texts = c()
for(post_url in posts){
  if( grepl('national', post_url) ){ # national이 포함된 url만
    post = read_html(post_url) %>%
      html_nodes('.bodyCont') %>%
      html_text()
    post_texts = c(post_texts, post)
    break  # 멈춤
  }
}


#
# 1~3페이지 모든 게시물의 본문
#
post_texts = c()
for(page in 1:3){
  url = modify_url(bobaedream, query=list(page=page))
  board = read_html(url,encoding="UTF-8")
  posts = board %>%
    html_nodes('a.bsubject') %>%
    html_attr('href') %>%
    xml2::url_absolute(bobaedream)

  for(post_url in posts){
    if( grepl('national', post_url) ){ # national이 포함된 url만
      post = read_html(post_url) %>%
        html_nodes('.bodyCont') %>%
        html_text()
      post_texts = c(post_texts, post)
    }
  }
}



##############################################################
#
# 한국어 형태소 분석
#
##############################################################

#
# 형태소 분석기 설치
#
install.packages('KoNLP')

#
# 불러오기
#

Sys.setenv(JAVA_HOME="")  # 충돌 방지
library(KoNLP)

#
# 간단한 형태소 분석
#
SimplePos09('하이브리드는 다 좋은데 갑자기 엔진이 돌 때 깜짝 놀랍니다')

#
# 명사, 용언 추출
#
library(stringr)
pos <- paste(SimplePos09('하이브리드는 다 좋은데 갑자기 엔진이 돌 때 깜짝 놀랍니다'))
extracted <- str_match(pos, '([가-힣]+)/[NP]')  #
keyword <- extracted[,2] # 표현만 선택
keyword <- keyword[!is.na(keyword)] # NA 제거
keyword


##############################################################
#
# Term-Document Matrix
#
##############################################################

#
# 명사, 용언 추출 함수
#
ko.words <- function(doc){
  d <- as.character(doc)
  pos <- paste(SimplePos09(d))
  extracted <- str_match(pos, '([가-힣]+)/[NP]')
  keyword <- extracted[,2]
  keyword[!is.na(keyword)]
}

#
# TDM 만들기
#
install.packages('tm')
library(tm)
options(mc.cores=1)  # 윈도에서 충돌 방지
cps <- Corpus(VectorSource(post_texts))
tdm <- TermDocumentMatrix(cps,
                          control=list(tokenize=ko.words, # 명사, 용언만 추출
                                       removePunctuation=T, # 문장 부호 제거
                                       removeNumbers=T, # 숫자 제거
                                       wordLengths=c(2, 5))) # 2~5자

attributes(tdm)

tdm$dimnames


##############################################################
#
# Term-Document Matrix
#
##############################################################

#
# 단어별 사용 횟수
#
library(slam)

word.occur = as.array(rollup(tdm, 2))

length(word.order)

#
# 빈도순 정렬
#
word.order = order(word.occur, decreasing = T)
row.names(tdm)[word.order]
word.occur

##############################################################
#
# 시각화
#
##############################################################

# 상위 20개 단어만 추출
most20 = word.order[1:20]
tdm.mat = as.matrix(tdm[most20,])

# 상관행렬
cormat = cor(t(tdm.mat))

# 시각화)
library(qgraph)
qgraph(cormat, labels=rownames(cormat), diag=F, layout='spring')


##############################################################
#
# Weighting
#
##############################################################

# weighting
library(lsa)
tdm.mat = as.matrix(tdm)

# local weight
lw_tf(tdm.mat)
lw_bintf(tdm.mat)
lw_logtf(tdm.mat)

# global wegiht
gw_normalisation(tdm.mat)
gw_idf(tdm.mat)
gw_gfidf(tdm.mat)
gw_entropy(tdm.mat)

##############################################################
#
# topic modeling
#
##############################################################

library(tm)
library(lda)
library(topicmodels)
dtm = as.DocumentTermMatrix(tdm)
ldaform = dtm2ldaformat(dtm, omit_empty = T)
result.lda = lda.collapsed.gibbs.sampler(documents = ldaform$documents,
                                         K = 10,
                                         vocab = ldaform$vocab,
                                         num.iterations = 5000,
                                         burnin = 1000,
                                         alpha = 0.01,
                                         eta = 0.01)

#속성값 확인
attributes(result.lda)

#토픽 분류 상태확인
result.lda$assignments
result.lda$topics
top.topic.words(result.lda$topics)[1:10,]
result.lda$topic_sums
result.lda$document_sums


#fit <- lda.collapsed.gibbs.sampler(documents = documents, K = K, vocab = vocab,
#                                   num.iterations = G, alpha = alpha,
#                                   eta = eta, initial = NULL, burnin = 0,
#                                   compute.log.likelihood = TRUE)
#############################################################################################################
#K <- 20
#G <- 5000
alpha <- 0.02
eta <- 0.02
D <- length(ldaform$documents)  # number of documents (2,000)
W <- length(ldaform$vocab)  # number of terms in the vocab (14,568)
doc.length <- sapply(ldaform$documents, function(x) sum(x[2, ]))  # number of tokens per document [312, 288, 170, 436, 291, ...]
N <- sum(doc.length)  # total number of tokens in the data (546,827)

term.table <- table(unlist(word.order))
term.table <- sort(term.table, decreasing = TRUE)
term.frequency <- as.integer(term.table)  # frequencies of terms in the corpus [8939, 5544, 2411, 2410, 2143, ...]

theta <- t(apply(result.lda$document_sums + alpha, 2, function(x) x/sum(x)))
phi <- t(apply(t(result.lda$topics) + eta, 2, function(x) x/sum(x)))
#
#############################################################################################################

CustComplaints <- list(phi = phi,
                     theta = theta,
                     doc.length = doc.length,
                     vocab = ldaform$vocab,
                     term.frequency = term.frequency)


library(LDAvis)
library(servr)

# create the JSON object to feed the visualization:
json <- createJSON(phi = CustComplaints$phi,
                   theta = CustComplaints$theta,
                   doc.length = CustComplaints$doc.length,
                   vocab = CustComplaints$vocab,
                   term.frequency = CustComplaints$term.frequency,
                   encoding="UTF-8",
                   family= "Nanumgothic")

localeToCharset()
Sys.getlocale()
#iconv(~, "CP949", "UTF-8") #— "CP949" 인코딩 변환

#시각화
serVis(json, out.dir = 'vis3', open.browser = FALSE, encoding = "UTF-8", family= "Nanumgothic")


