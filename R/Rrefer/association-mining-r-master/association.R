# Author: shakthydoss
# Webiste: http://shakthydoss.com/
# Email: shakthydoss@gmailcom
# R program to extract and visualize  association rules. 


rm(list = ls())

# load association mining libraries  
library("arules")
library("arulesViz")

# load transaction data. 
trans = read.transactions(file="C:\\R\\association-mining-r-master\\transaction-dataset.txt" , format="basket", sep=" ");
summary(trans)

summary(transaction_m2)

# extract association rule from transaction data. 
rules <- apriori(trans, parameter=list(support=0.01, confidence=0.5))


m2


length(rules2)
inspect(head(sort(rules , by="lift")))

#scatter plot 
plot(rules, measure=c("support" , "confidence") , shading="lift")
plot(rules, measure=c("support" , "lift") , shading="confidence")

#matrix plot
plot(rules, method="matrix" , measure="lift" )
plot(rules, method="matrix3D" ,measure=c("lift", "confidence"))

#graph plot
plot(rules, method="graph" );

# grouped matrix chart
plot(rules, method="grouped")

#Parallel coordinates
plot(rules, method="paracoord")


plot(rules, method="graph"); 
plot(rules, method="graph", control=list(type="items"))

summary(Groceries)


plot(rules, measure=c("support", "lift"), shading="confidence")
plot(rules, shading="order", control=list(main = "Two-key plot"))
sel <- plot(rules, measure=c("support", "lift"), shading="confidence", interactive=TRUE)
plot(rules, method="graph", control=list(type="itemsets"))
plot(rules, method="paracoord")
