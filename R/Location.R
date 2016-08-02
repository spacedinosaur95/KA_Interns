library(RNeo4j)
library(ggmap)
graph = startGraph("http://jsc-na-vocab:7474/db/data/")
#Function to remove whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
#Dataframe of principal investigators 
investigators <- data.frame(data$'_id',data$'Experiment Details - Principal Investigator(s)',vector(length = 1032),vector(length = 1032))
names(investigators) <- c("id","investigators","long","lat")
#populates the lat and long column of the dataframe with the latitude and long of each principal investigator
for (i in 1:nrow(investigators)){
  #the formatting is horrible, but the most common pattern is that the string ends with ", state/province, country" The problem is this pattern is not followed for every investigator so some queries may fail
  splitString <- strsplit(investigators[i,2],",")
  addressList <- tail(splitString[[1]],n=2)
  address <- paste(trim(addressList[1]),trim(addressList[2]))
  print(address)
  #convert address to cords
  location <- geocode(address)
  investigators[i,3] <- location$lon
  investigators[i,4] <- location$lat
}
#Update database with information
for (i in 1:nrow(investigators)){
  if(!is.na(investigators[i,3]) || !is.na(investigators[i,4])){
    cypher(graph,paste0("MATCH (n:Experiments {_id:'",investigators[i,1],"'}) SET n.longitude = TOFLOAT(",investigators[i,3],"), n.latitude = TOFLOAT(",investigators[i,4],")"))
  }
}
