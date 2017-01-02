text <- c("clothing men one jacket portrait necktie adult people outerwear facial_expression menswear confidence outfit business fashion stylish neckwear trendy blazer indoors",
          "clothing men one jacket portrait adult necktie confidence facial_expression people outerwear menswear business outfit stylish fashion indoors trendy women music",          "clothing men one jacket portrait necktie adult people outerwear menswear confidence facial_expression outfit business fashion stylish indoors blazer shadow neckwear",         "clothing men one jacket portrait necktie adult people facial_expression outerwear menswear confidence outfit business blazer neckwear stylish fashion indoors actor ",
          "clothing men one jacket portrait adult people outerwear necktie facial_expression menswear confidence outfit business fashion blazer stylish music indoors actor")

library(tm)
view <- factor(rep(c("view 1"), each=5))
summary(view)
view
df <- data.frame(text, view, stringsAsFactors=FALSE)

df
summary(df)

df$text
df$view


corpus
corpus <- Corpus(VectorSource(df$text))
#corpus <- tm_map(corpus, content_transformer(tolower))
#corpus <- tm_map(corpus, removePunctuation)
#corpus <- tm_map(corpus, function(x) removeWords(x, stopwords("english")))
#corpus <- tm_map(corpus, stemDocument, language = "english")
corpus

tdm = DocumentTermMatrix(corpus)

tdm
inspect(tdm)
tdm <- as.matrix(tdm)

tdm

library(proxy)
cosine_dist_mat <- as.matrix(dist(t(tdm), method = "cosine"))
diag(cosine_dist_mat) <- NA
cosine_dist <- apply(cosine_dist_mat, 2, mean, na.rm=TRUE)
cosine_dist
#> cosine_dist
#     1      2      3      4      5 
#0.0750 0.1250 0.0875 0.0750 0.0875 

ave(cosine_dist)
#> ave(cosine_dist)
#   1    2    3    4    5 
#0.09 0.09 0.09 0.09 0.09 