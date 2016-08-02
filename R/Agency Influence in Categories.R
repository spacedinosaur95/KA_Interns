library(RNeo4j)

graph = startGraph("http://localhost:7474/db/data/")

#Load list of agencies and categories
query = "MATCH (a:Agencies) WITH a MATCH (b:Categories) RETURN a.title,b.title"
df <- cypher(graph, query)
names(df) <- c("Agencies","Categories")
#Create list of unique agencies and categories
Agencies = unique(df$Agencies)
Categories = unique(df$Categories)

#Run through every combination of categories and agencies and record the number of relations
vect <- c()
for (i in 1:49){
  
  query = paste0("MATCH p=(c:Categories)<-[:`In Category`]-(b:Experiments)<-[:Performed]-(a:Agencies) WHERE c.title = '",df$Categories[i],"' AND a.title = '",df$Agencies[i],"' RETURN count(p)")
  temp <- cypher(graph, query)
  vect <- c(vect,temp)
}
#convert vector to matrix
data <- matrix(vect,nrow=7,ncol=7,byrow=TRUE)
#convert matrix to graph
regions <- c("Roscosmos","JAXA","ESA","NASA","CSA","Unkown","ESA and Russia")
colors = c("red","yellow","white","blue","green","black","purple")#c("red","blue","green","white","yellow","purple","black")
barplot(data,main = "Agency Influence in Categories",names.arg = Categories,xlab = "Categories",ylab = "Experiments",las=0,col = colors)
legend("topleft", regions, cex = 1.3, fill = colors)