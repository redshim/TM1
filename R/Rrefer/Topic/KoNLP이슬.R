========================================================
  1. Install packages
========================================================
  
  # Text mining과 Word Cloud를 그리는데 필요한 패키지 설치
  
  libs <- c("KoNLP", "tm", "wordcloud", "SnowballC", "Sejong", 'plyr') lapply(libs, require, character.only = TRUE)
  
  ========================================================
    2. Data Import
  ========================================================
    
    # Import function
    wc_text <- function(){
      assign("text.folder.path", "C:/Users/yshan/Desktop/park_real/" , envir = .GlobalEnv)
      text.files <- list.files(path=text.folder.path, pattern = "*.txt")
      assign("text.files", text.files, envir = .GlobalEnv)
      assign("no.text" , length(text.files), envir = .GlobalEnv)
      
      text <- vector('list', no.text)
      
      for(i in 1:no.text){
        
        text.files.path <- paste(text.folder.path, text.files[i], sep="")
        text[[i]] <-  readLines(text.files.path, encoding="UTF-8")
        
      }
      assign('text', text, envir = .GlobalEnv) }
    
    wc_text()
    
    ========================================================
      3. Data transformation
    ========================================================
      
      # 빈 벡터 생성
      wc <- vector("character",length(text))
    
    #
    for(i in 1:length(text)){
      wc[i]<- as.character(text[1])
    }
    wc <- ldply(wc)
    names(wc) <- c('noun')
    
    
    =============================================================
      # 4.Apply a Dictionary
      =============================================================
      
      useSejongDic()
    
    newdic <- read.table("C:/Users/yshan/Desktop/newDic.txt", sep="\t", header=F, stringsAsFactors=F)
    mergeUserDic(newdic)
    
    =============================================================
      # 5.Word Extraction (Extraction Function 생성예정)
      =============================================================
      
      for(i in 1:length(text)){
        print(i)
        wc$noun[i]=paste(extractNoun(wc$noun[i]), collapse=" ")
      }
    
    
    =============================================================
      # 6.Transformation
      =============================================================
      
      myCorpus <- Corpus(VectorSource(wc$noun))
    myCorpus <- tm_map(myCorpus, removePunctuation)
    myCorpus <- tm_map(myCorpus, removeNumbers)
    myCorpus <- tm_map(myCorpus, stemDocument)
    addStopwords <- c('여러분', '실패', '조성', '우리', '하게', '들이','해서','매출액', '지난해','동아리',
                      '비롯', '선배','시간','올해','유명','융복','존경','개개인','가운데','MA를', '후배',
                      '그동안','방안발표를','벤처창업박람회를','셋톱박스로','얼마','순위는','실제','여러분들이',
                      '서로','엔젤','월의벤처창업','여러분들','이스라엘에서는','창업가들이','존경하는','하기','해도',
                      'cUFEFF존경하는')
    myStopwords <- c(stopwords('en'), addStopwords)
    myCorpus <- tm_map(myCorpus, removeWords, myStopwords)
    
    =============================================================
      # 7.Create a TermDocumentMatrix & Freq.Matrix
      =============================================================
      
      BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 2))
    myTdm <- TermDocumentMatrix(myCorpus, control=list(wordLengths=c(2,Inf),tolower=F))
    
    # Create a Frequency matrix
    m <- as.matrix(myTdm)
    freq_m <- rowSums(m)
    freq_m <- subset(freq_m, freq_m >= 10)
    
    wordFreq <- sort(freq_m, decreasing = TRUE)
    
    =============================================================
      # 8. Draw Wordcloud
      =============================================================
      
      pal <- brewer.pal(6, "Dark2")
    
    windowsFonts(malgun=windowsFont("맑은 고딕"))
    
    wordcloud(words = names(wordFreq), freq = wordFreq, min.freq = 10, colors = pal, random.order=F, family="malgun")
    
    나의 iPhone에서 보냄
    