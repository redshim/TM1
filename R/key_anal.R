# 초기화
rm(list = ls())


showConnections(all = FALSE)

library(KoNLP)
library(tm)
#referenced from http://www.rdatamining.com/
#setwd("/home/6546788/Crawler_N/export")

f <- file("/home/6546788/Crawler_N/export/K0000001_head_100.csv", blocking = F, encoding = "UTF-8")
txt <- readLines(f)

nDocs <- length(txt)
# 문서 갯수 Docs
nDocs

df <- do.call("rbind", lapply(txt, as.data.frame))

# Remove Process 가비지 데이터 정제
removeDoc <- function(x) {gsub("@[[:graph:]]*", "", x)}
removeURL <- function(x) { gsub("http://[[:graph:]]*", "", x)}
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
removenum <- function (x) sub("\\d+", "", x)

print("로딩완료")

df$ptext <- sapply(df$X, removeURL)
df$ptext <- sapply(df$ptext, removeDoc)
df$ptext <- sapply(df$ptext, trim)
df$ptext <- sapply(df$ptext, removenum)

useSejongDic()

## 명사 추출
df$ptext <- sapply(df$ptext, function(x) {paste(extractNoun(x), collapse=" ")}) 


#build corpus 코퍼스 생성
myCorpus_ <- Corpus(VectorSource(df$ptext))
myCorpus_ <- tm_map(myCorpus_, removePunctuation)
myCorpus_ <- tm_map(myCorpus_, removeNumbers)
#myCorpus_ <- tm_map(myCorpus_, stemDocument)
#myCorpus_ <- tm_map(myCorpus_, stripWhitespace)
#myStopwords <- c(stopwords('english'), "rt")

#remove potentially problematic symbols
#필요없는 문제 제거
toSpace <- content_transformer(function(x, pattern) { return (gsub(pattern, " ", x))})
myCorpus_ <- tm_map(myCorpus_, toSpace, "-")
myCorpus_ <- tm_map(myCorpus_, toSpace, "’")
myCorpus_ <- tm_map(myCorpus_, toSpace, "‘")
myCorpus_ <- tm_map(myCorpus_, toSpace, "•")
myCorpus_ <- tm_map(myCorpus_, toSpace, "\"")
myCorpus_ <- tm_map(myCorpus_, toSpace, "\n")
myCorpus_ <- tm_map(myCorpus_, toSpace, "�")
myCorpus_ <- tm_map(myCorpus_, toSpace, "▷")
myCorpus_ <- tm_map(myCorpus_, toSpace, "\"")
myCorpus_ <- tm_map(myCorpus_, toSpace, "☆")
myCorpus_ <- tm_map(myCorpus_, toSpace, "ㅠ")
myCorpus_ <- tm_map(myCorpus_, toSpace, "↓")
myCorpus_ <- tm_map(myCorpus_, toSpace, "━")
myCorpus_ <- tm_map(myCorpus_, toSpace, "☏")
myCorpus_ <- tm_map(myCorpus_, toSpace, "℡")
myCorpus_ <- tm_map(myCorpus_, toSpace, "ah인")
myCorpus_ <- tm_map(myCorpus_, toSpace, "ㅇ")
myCorpus_ <- tm_map(myCorpus_, toSpace, "─")
myCorpus_ <- tm_map(myCorpus_, toSpace, "㎢鳴")
myCorpus_ <- tm_map(myCorpus_, toSpace, "수원중고안산중고김포중고일산중고인천중고부천중고보배드림 sk엔카")
myCorpus_ <- tm_map(myCorpus_, toSpace, "ㅎ")

# 스톱워드 제거 (불용어)
myStopwords <- c("한","년", "http", "수 ","저희 ", "생각", "하기",
                 "차량","하게","진행","생각", "하시","상태",
                 "작업","때문","하게","하기","\n","만","들이","등 ","등등","드\n"
                 ,"디 a","문 ","차 ","하나","ㅠㅠ","ㅋㅋ", "안녕", "언제", "이번", "오늘"
                 ,"해서", "기존","이상", "소개", "판매")
myCorpus_ <-tm_map(myCorpus_, removeWords, myStopwords)
#writeLines(as.character(myCorpus_[[31]]))

## @knitr eda
myTdm <- TermDocumentMatrix(myCorpus_, control=list(wordLengths=c(2,Inf)))
#myTdm <- TermDocumentMatrix(myCorpus_, control=list(weighting = function(x) weightTfIdf(x, TRUE),
#                                                    wordLengths=c(1,Inf)))
freq <- colSums(as.matrix(myTdm))
length(freq)
ord <- order(freq,decreasing=TRUE)
freq[ord]

write.csv(freq[ord],"/home/6546788/Crawler_N/export/word_freq.csv")

inspect(myTdm)

#inspect frequent term
findFreqTerms(myTdm, lowfreq=5)
#findAssocs(myTdm,'충돌',0.7)




## @knitr barplot
library(ggplot2)
termFrequency <- rowSums(as.matrix(myTdm))
termFrequency <- subset(termFrequency,termFrequency>=3)
termFrequency

#ggplot(data.frame(term = names(termFrequency), freq=termFrequency, y= termFrequency), aes(term, freq))
#ggplot(data.frame(term = names(termFrequency), freq=termFrequency), aes(term, freq) + geom_bar() + coord_flip())
#ggplot(data.frame(term = names(termFrequency), freq=termFrequency), aes(term, freq) + geom_bar() + coord_flip())

##########################################################################################
## @knitr wordcloud
#Word Cloud 
##########################################################################################
library(wordcloud)
m <- as.matrix(myTdm)
wordFreq <- sort(rowSums(m),decreasing=TRUE)

wordFreq_F <- subset(wordFreq, wordFreq <=100)
wordFreq_F <- subset(wordFreq_F, wordFreq >=5)

head(wordFreq_F, 10)
length(wordFreq_F)
wordFreq_F

#set.seed(700)
#pal <- brewer.pal(6,"Dark2")
#windowsFonts(malgun=windowsFont("맑은 고딕"))
#wordcloud(words=names(wordFreq_F),freq=wordFreq_F,min.freq=5,random.order=F, rot.per=.1,colors=pal,family="malgun")

#pal <- brewer.pal(6, "Dark2")
#windowsFonts(malgun=windowsFont("맑은 고딕"))
#wordcloud(words = names(wordFreq_F), freq = wordFreq_F, min.freq = 10,rot.per=.1,colors=pal, random.order=F, family="malgun")
write.csv(wordFreq_F,"wordFreq_key.csv")


## @knitr hclust
myTdm2<-removeSparseTerms(myTdm,sparse=0.95)
m2<-as.matrix(myTdm2)
distMatrix<-dist(scale(m2))

fit<-hclust(distMatrix,method="ward")

#plot(fit,family="malgun")
#rect.hclust(fit,k=10)
#(groups<-cutree(fit,k=10))

## @knitr kmeans
m3 <- t(m2)

m3
k <- 5
kmres <- kmeans(m3, k)

round(kmres$centers, digits=3)

key_kmeans_result <- 
for(i in 1:k){
  cat(paste("cluster ", i, " : ", sep=""))
  s <- sort(kmres$centers[i, ], decreasing=T)
  cat(names(s)[1:20], "\n")
  #print(head(rdmTweets[which(kmres$cluster ==i)],n=3))
}

################################################################################
# APRIORI Algorithm
################################################################################
library("arules")
myTdm2<-removeSparseTerms(myTdm,sparse=0.9)
myTdm2
m2 <- as.matrix(myTdm2)
t_m2 <- t(m2) 
print(t_m2)
# 연관단어 탐색 #
rules2 <- apriori(t_m2, parameter = list(support = .3))
head(rules2)
#as(m3,"transactions")
#transaction_m2 <- as(m2,"transactions")
#class(transaction_m2)
inspect(head(sort(rules2, by = "lift"), 3000))
aresult <- as(rules2, "data.frame")
write.table(aresult,'apriori_key.csv', fileEncoding ="UTF-8")
