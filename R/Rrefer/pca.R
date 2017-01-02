require(ade4) # multivariate analysis
require(ggplot2) # fancy plotting
require(grid) # has the viewport function
require(phyloseq) # GlobalPatterns data

u=seq(2,30,by=2)
v=seq(3,12,by=3)

X1=u%*%t(v)

X1=outer(u,v)

X1
Matex <- matrix(rnorm(60,1),nrow=15,ncol=4)
X <- X1+Matex
X
ggplot(data=data.frame(X), aes(x=X1, y=X2, col=X3, size=X4)) + geom_point()

set.seed(0)
n <- 100
p <- 4
Y2 <- outer(rnorm(n), rnorm(p)) + outer(rnorm(n), rnorm(p))
head(Y2)

ggplot(data=data.frame(Y2), aes(x=X1, y=X2, col=X3, size=X4)) + geom_point()
svd(Y2)$d
Y <- Y2 + matrix(rnorm(n*p, sd=0.01),n,p) # add some noise to Y2
svd(Y)$d # four non-zero eigenvalues (but only 2 big ones)



Pricipao component Analysis

Xmeans <- apply(X,2,mean)
Xc <- sweep(X,2,Xmeans)
Sc <- crossprod(Xc)
Sce <- eigen(Sc)
# here is Xr
Xr <- Xc * sqrt(15)
Xr.pca <- dudi.pca(Xr, scale=F, scannf=F, nf=4)
Xr.pca$eig


Sce$values
Xr.pca$c1
