library("arules")

data.frame(Epub)
year <- strftime(as.POSIXlt(transactionInfo(Epub)[["TimeStamp"]]), "%Y")
table(year)
Epub2003 <- Epub[year == "2003"]
transactionInfo(Epub2003[size(Epub2003) > 20])
inspect(Epub2003[1:5])
as(Epub2003[1:5], "list")
EpubTidLists <- as(Epub, "tidLists")
EpubTidLists
as(EpubTidLists[1:3], "list")



library("arulesViz")
data("Groceries")

typeof(Groceries)
Groceries
print(Groceries)
show(Groceries)


rules <- apriori(Groceries, parameter=list(support=0.001, confidence=0.5))
rules
inspect(head(sort(rules, by ="lift"),3))

plot(x, method = NULL, measure = "support", shading = "lift", 
     + interactive = FALSE, data = NULL, control = NULL, ...)

plot(rules)
