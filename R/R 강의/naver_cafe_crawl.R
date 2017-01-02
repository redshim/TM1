library(httr)
library(dplyr)
library(rvest)

url
############nave cafe
navercafe = 'http://section.cafe.naver.com/ArticleSearch.nhn?query=%EC%B0%A8%EC%84%A0%EC%9D%B4%ED%83%88+%EA%B2%BD%EB%B3%B4+%EB%AC%B8%EC%A0%9C#'
url = modify_url(navercafe, query=list(page=1))
board = read_html(url,encoding="UTF-8")
board

#contents
html_nodes(board, 'ul.basic1\  li dl dd') %>% html_text()
#page address
cafe_urls <-html_nodes(board, 'ul.basic1\  li dl dd a') %>% html_attr("href")

length(cafe_url)


rm(post_texts)

for(cafe_url in cafe_urls){
    post = read_html(cafe_url) %>%
      html_nodes('.bodyCont') %>%
      html_text()
    post_texts = c(post_texts, post)
}

cafe_url <- 'http://cafe.naver.com/thenewk7/26498'
read_html(cafe_url) %>%
  html_nodes('.bodyCont') %>%
  html_text()


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
