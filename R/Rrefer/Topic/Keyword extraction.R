
# Kyword Extraction

#Keyword extraction
#Bag of words
#Term weighting
#Co-occurrence of words

require("tm")
require("skmeans")
require("slam")

library(tm)
vignette("tm")
data(crude)
class(crude)

show(crude)

inspect(crude)


crude$`reut-00001.xml`




mfrq_words_per_cluster <- function(clus, dtm, first = 6, unique = TRUE){
  if(!any(class(clus) == "skmeans")) return("clus must be an skmeans object")
  dtm <- as.simple_triplet_matrix(dtm)
    indM <- table(names(clus$cluster), clus$cluster) == 1 # generate bool matrix
    
    hfun <- function(ind, dtm){ # help function, summing up words
    if(is.null(dtm[ind, ]))  dtm[ind, ] else  col_sums(dtm[ind, ])
    }
    frqM <- apply(indM, 2, hfun, dtm = dtm)
    
    if(unique){
    # eliminate word which occur in several clusters
    frqM <- frqM[rowSums(frqM > 0) == 1, ] 
    }
    # export to list, order and take first x elements 
    res <- lapply(1:ncol(frqM), function(i, mat, first)
    head(sort(mat[, i], decreasing = TRUE), first),
    mat = frqM, first = first)
       
    names(res) <- paste0("CLUSTER_", 1:ncol(frqM))
    return(res)
}


d_crude <- data("crude")

crude[,]


dtm <- DocumentTermMatrix(crude, control =
                            list(removePunctuation = TRUE,
                                 removeNumbers = TRUE,
                                 stopwords = TRUE))

rownames(dtm) <- paste0("Doc_", 1:20)
clus <- skmeans(dtm, 3)


mfrq_words_per_cluster(clus, dtm)
mfrq_words_per_cluster(clus, dtm, unique = FALSE)


data("crude")
dtm <- DocumentTermMatrix(crude, control =
                            list(removePunctuation = TRUE,
                                 removeNumbers = TRUE,
                                 stopwords = TRUE))

rownames(dtm) <- paste0("Doc_", 1:20)
clus <- skmeans(dtm, 3)


mfrq_words_per_cluster(clus, dtm)
mfrq_words_per_cluster(clus, dtm, unique = FALSE)