# If you get gsl error when installing topicmodes,
# run 'sudo apt-get install libgsl0-dev' in ubuntu.
library(topicmodels) 
library(tm)
library(randtoolbox)
library(foreach)

data(acq)
data(crude)


crude


DocumentTermMatrix(crude)
DocumentTermMatrix(acq)

crude_acq
crude_doc_ids
acq_doc_ids

meta(crude, type='local', tag='id')
summary(crude)

crude_acq <- c(DocumentTermMatrix(crude), DocumentTermMatrix(acq))
crude_doc_ids <- unlist(meta(crude, type='local', tag='id'))
acq_doc_ids <- unlist(meta(acq, type='local', tag='id'))


# Two topics, 1000 random starts with Gibbs sampling.
num_random_start <- 1000
m <- LDA(crude_acq, k=2, method="Gibbs",
         control=list(seed=get.primes(num_random_start),
                      nstart=num_random_start))
evaluate <- function(reference, prediction) {
  return(list(precision=NROW(intersect(reference, prediction)) / NROW(prediction),
              recall=NROW(intersect(reference, prediction)) / NROW(reference)))
}

# There is no way to figure out which topic corresponds to which data. Guess
# based on mean precision.
mean_precision <- foreach(i=1:2, .combine=c) %do% {
  maybe_crude <- names(which(topics(m) == i))
  maybe_acq <- names(which(topics(m) == 2 - i + 1))
  return(mean(
    evaluate(crude_doc_ids, maybe_crude)$precision,
    evaluate(acq_doc_ids, maybe_acq)$precision))
}

lda_crude_doc_ids <- names(which(topics(m) == which.max(mean_precision)))
lda_acq_doc_ids <- names(which(topics(m) == 2 - which.max(mean_precision) + 1))

evaluate(crude_doc_ids, lda_crude_doc_ids)
evaluate(acq_doc_ids, lda_acq_doc_ids)

lda_crude_doc_ids
crude_doc_ids
