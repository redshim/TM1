library("arules");

library("arulesViz");

patterns = random.patterns(nItems = 1000);

summary(patterns);

trans = random.transactions(nItems = 1000, nTrans = 1000, method = "agrawal",  patterns = patterns);

image(trans);

patterns 
trans

data("AdultUCI");

Adult = as(AdultUCI[6:7], "transactions");

rules = apriori(Adult, parameter=list(support=0.01, confidence=0.5));

rules;


inspect(head(sort(rules, by="lift"),3));

plot(rules);

head(quality(rules));

plot(rules, measure=c("support","lift"), shading="confidence");

plot(rules, shading="order", control=list(main ="Two-key plot"));


head(sort(rules, by="lift"),3));

plot(rules);

head(quality(rules));

plot(rules, measure=c("support","lift"), shading="confidence");

plot(rules, shading="order", control=list(main ="Two-key plot"));
