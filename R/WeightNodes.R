library(RNeo4j)
subs <- unique(data$SubCategories)
graph = startGraph("http://localhost:7474/db/data/")
for (i in subs){
  query <- paste0("MATCH (a:SubCategories {title:'",i,"'})-[r:`In SubCategory`]-() WITH a, count(r) AS weight SET a.weight = weight")
  cypher(graph,query)
}
Agencies <- cypher(graph,"MATCH (a:Agencies) RETURN a.title")
for (i in Agencies){
  query <- paste0("MATCH (a:Agencies {title:'",i,"'})-[r:Performed]-() WITH a, count(r) AS weight SET a.weight = weight")
}
for(i in query){
  cypher(graph,i)
}