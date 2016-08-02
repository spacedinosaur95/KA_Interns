library(rmongodb)

mongo <- mongo.create()
mongo.is.connected(mongodb)


cursor <- mongo.find(mongo,"ISSExperiments.Expeditions",query='{}', fields = '{"title":1}')
df <- mongo.cursor.to.data.frame(cursor)
names(df) <- c("id","title")

save(df,file="data.RData")
