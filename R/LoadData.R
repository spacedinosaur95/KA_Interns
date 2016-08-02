library(rmongodb)

#Connect to mongoDB
mongo <- mongo.create()
mongo.is.connected(mongodb)

#Execute query 
cursor <- mongo.find(mongo,"ISSExperiments.Experiments",query='{}', fields = '{"Experiment Description - Research Overview":1,"Experiment Description - Description":1}')
#convert query to dataframe
df <- mongo.cursor.to.data.frame(cursor)
#rename columns
names(df) <- c("id","desc","overview")
#save so next script can load the data
save(df,file="data.RData")