#### 명사 추출 


require(KoNLP)
# 한국어 텍스트마이닝을 위한 패키지 설치
#install.packages("KoNLP")
library(KoNLP)


extractNoun("롯데마트가 판매하고 있는 흑마늘 양념 치킨이 논란이 되고 있다.")

#sa <- sapply(c("R은 free 소프트웨어이고, [완전하게 무보증]입니다.", "일정한 조건에 따르면, 자유롭게 이것을 재배포할수가 있습니다."), extractNoun)



#한글 세종사전 이용
useSejongDic()

# 텍스트 파일 읽음
# working directory 내에 파일이 있다면 파일 이름만 적어주고
# 그렇지 않다면 파일이 저장되어 있는 경로까지 적어줘야함
# f <- file("파일 경로/test.txt", blocking = F)
f <- file("test33.txt", blocking = F, encoding = "UTF-8")

readLines(f)
# 텍스트 파일에 있는 문장을 한줄씩 읽어들임
txt <- readLines(f)

txt

# sapply() 리스트 형태가 아닌 행렬 또는 벡터 형태로 결과 값을 반환하는 함수
# 읽어드린 텍스트 파일에서 명사만 추출
nouns <- sapply(txt, extractNoun, USE.NAMES = T)
length(nouns)

nouns

# 추출된 명사 상위 30개, 하위 30개 확인
# unlist() 결과를 백터 형식으로 반환하는 함수
head(unlist(nouns), 30)
tail(unlist(nouns), 30)

# 두글자 이상인 명사만 추출
# nouns2 에 임시로 저장하고 다시 nouns에 저장
nouns2 <- unlist(nouns)
nouns <- Filter(function(x) {nchar(x) >= 2}, nouns2)
nouns

# 불필요한 단어 제거 및 변경
# 데이터명 <- gsub("변경할 단어", "변경 후 단어", 데이터명)
# 예) "지금"이라는 단어를 제거
nouns <- gsub("지금", "", nouns)
nouns <- gsub("\"U+200B\"", "", nouns)


nouns
# 추출된 명사를 파일로 저장
# write(unlist(nouns), "저장될 폴더/test2.txt")
write(unlist(nouns), "test2.txt" )
