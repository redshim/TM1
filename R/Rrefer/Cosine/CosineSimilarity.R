setwd("C:\\R\\cosine")

winedata <-read.csv("WineKMC.csv") 
winedata
winedata[is.na(winedata)] <- 0 
head(winedata)


matrix(apply(cmb,1,cos.sim),n,n) 


winedata.transposed <- t(winedata[, 8:107])
winedata.transposed 
X <- winedata.transposed 
cos.sim <- function(ix) {
  A = X[ix[1],]
  B = X[ix[2],]
  return( sum(A*B)/sqrt(sum(A^2)*sum(B^2)) )
}
n <- nrow(X)
cmb <-expand.grid(i=1:n, j=1:n)
C <- matrix(apply(cmb,1,cos.sim),n,n) 
C[100,100]
for (i in 1:n) {C[i,i] = 0} 
C 
C.vector <-as.vector(C) 
C.vector[C.vector >0]
length(C.vector[C.vector >0])
2950*0.2 
sort(C.vector[C.vector >0], decreasing=TRUE)[590]
C.cutoff <- C 
C.cutoff[C.cutoff >=0.5] <-1
C.cutoff[C.cutoff <0.5] <-0 
C.cutoff 
colnames(winedata)[8:107] 
buyerNames <- c(colnames(winedata)[8:107])
buyerNames 
colnames(C.cutoff) <- c(buyerNames) 
rownames(C.cutoff) <- c(buyerNames) 
head(C.cutoff) 
write.csv(C.cutoff, "winedataneighborhood.csv")
