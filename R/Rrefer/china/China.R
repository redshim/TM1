Sys.getlocale()

Sys.setenv(LANG = "en")
options(encoding="utf-8")
Sys.setenv(LANG = "en_US.UTF-8")
Sys.setlocale("LC_ALL","UTF-8")
Sys.setlocale("LC_ALL", "C")
Sys.setlocale("LC_ALL","English")
sessionInfo()
LANGUAGE="en_US.utf8"
Sys.setenv(LANG = "en")
Sys.getlocale()



setwd("C://R//china")

#1.헤더를 TRUE로 줬을때, Invalid Multibyte 에러 발생
x2 <- read.csv("ff_UTF8.txt", header=T ,sep = ",", quote = '"', encoding="UTF-8")
#--> Error in type.convert(data[[i]], as.is = as.is[i], dec = dec, numerals = numerals,  :
#invalid multibyte string at '<e5><85><b6>餓뽩첅鵝<93>'
#In addition: Warning message:                   In scan(file, what, nmax, sep, dec, quote, skip, nlines, na.strings,  :
#EOF within quoted string


#2.헤더를 False로 줬을때, 컬럼 밀리는 현상
x1 <- read.csv("ff_UTF8.csv", header=F ,sep = ",", quote = '"', encoding="UTF-8")



x1[2,]


x2 <- read.csv("ff_UTF8.csv", header=T ,sep = ",", quote = '"', encoding="UNICODE")

x1 <- read.csv("china_ExcelImport_Gen.csv", header=T ,sep = ",", quote = '"', encoding="UTF-8")



################## R 코드 ##############################
#   2. 비정상 작동 스크립트
######################################################
setwd("C://R//china")

#1.헤더를 TRUE로 줬을때, Invalid Multibyte 에러 발생
x2 <- read.csv("CN_UTF8.txt", header=T ,sep = ",", quote = '"', encoding="UTF-8")
#--> Error in type.convert(data[[i]], as.is = as.is[i], dec = dec, numerals = numerals,  :
#invalid multibyte string at '<e5><85><b6>餓뽩첅鵝<93>'
#In addition: Warning message:                   In scan(file, what, nmax, sep, dec, quote, skip, nlines, na.strings,  :
#EOF within quoted string

#2.헤더를 False로 줬을때, 컬럼 밀리는 현상
x1 <- read.csv("CN_UTF8.txt", header=F ,sep = ",", quote = '"', encoding="UTF-8")




#x <- read.csv2("china_sns.csv", header=T , quote = '"', sep = "," ,fileEncoding="UTF-8",  fill = TRUE)
#x <- read.table("china_k3_hive_utf8.csv", header=TRUE, fill = TRUE, sep=",",fileEncoding="UNICODE")
#x <-read.table('china_sns.csv',sep=",")
#read.table("china_k3_utf8.txt", sep=",", header=TRUE,fileEncoding="UTF-8")
#read.table("china_k3_utf8.txt",  header=T , quote = '"', sep = "," ,fileEncoding="UTF-8")
#read.csv("china_k3_utf8.txt", header=T , quote = '"', sep = "," ,fileEncoding="UTF-8")
#read.table("china_sns.csv", fileEncoding="UTF-8", sep = ",", header = TRUE)


#hive -e 'select * from dura_master.china' > /home/yourfile.csv
