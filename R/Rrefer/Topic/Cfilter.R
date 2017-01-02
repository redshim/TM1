
cfilter
# Create a helper function to calculate the cosine between two vectors
getCosine <- function(x,y) 
{
  this.cosine <- sum(x*y) / (sqrt(sum(x*x)) * sqrt(sum(y*y)))
  return(this.cosine)
}

length(m3)
colnames(m3)
ncol(m3)

# Create a placeholder dataframe listing item vs. item
m3.similarity  <- matrix(NA, nrow=ncol(m3),ncol=ncol(m3),dimnames=list(colnames(m3),colnames(m3)))

m3.similarity


# Lets fill in those empty spaces with cosine similarities
# Loop through the columns
for(i in 1:ncol(m3)) {
  # Loop through the columns for each column
  for(j in 1:ncol(m3)) {
    # Fill in placeholder with cosine similarities
    m3.similarity[i,j] <- getCosine(as.matrix(m3[i]),as.matrix(m3[j]))
  }
}

m3.similarity

# Back to dataframe
df.m3.similarity <- as.data.frame(m3.similarity)
df.m3.similarity

df.m3.neighbours <- matrix(NA, nrow=ncol(df.m3.similarity),ncol=50,dimnames=list(colnames(df.m3.similarity)))
df.m3.neighbours

for(i in 1:ncol(m3)) 
{
  df.m3.neighbours[i,] <- (t(head(n=50,rownames(df.m3.similarity[order(df.m3.similarity[,i],decreasing=TRUE),][i]))))
}

df.m3.neighbours


# Lets make a helper function to calculate the scores
getScore <- function(history, similarities)
{
  x <- sum(history*similarities)/sum(similarities)
  x
}

show(m3)

m3$Docs

# A placeholder matrix
holder <- matrix(NA, nrow=nrow(m3),ncol=ncol(m3)-1,dimnames=list((m3$` `),colnames(m3[-1])))

holder