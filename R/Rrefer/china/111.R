
# cor = TRUE indicates that PCA is performed on 
# standardized data (mean = 0, variance = 1)
pcaCars <- princomp(mtcars, cor = TRUE)

# view objects stored in pcaCars
names(pcaCars)

# proportion of variance explained
summary(pcaCars)

# scree plot
plot(pcaCars, type = "l")

# cluster cars
carsHC <- hclust(dist(pcaCars$scores), method = "ward.D2")

# dendrogram
plot(carsHC)

# cut the dendrogram into 3 clusters
carsClusters <- cutree(carsHC, k = 3)

# add cluster to data frame of scores
carsDf <- data.frame(pcaCars$scores, "cluster" = factor(carsClusters))
carsDf <- transform(carsDf, cluster_name = paste("Cluster",carsClusters))


library(ggplot2)
p1 <- ggplot(carsDf,aes(x=Comp.1, y=Comp.2)) +
  theme_classic() +
  geom_hline(yintercept = 0, color = "gray70") +
  geom_vline(xintercept = 0, color = "gray70") +
  geom_point(aes(color = cluster), alpha = 0.55, size = 3) +
  xlab("PC1") +
  ylab("PC2") + 
  xlim(-5, 6) + 
  ggtitle("PCA Clusters from Hierarchical Clustering of Cars Data") 

p1 + geom_text(aes(y = Comp.2 + 0.25, label = rownames(carsDf)))