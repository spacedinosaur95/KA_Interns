library(RNeo4j)

graph = startGraph("http://localhost:7474/db/data/")
query <- "MATCH (e:Experiments)
          MATCH (e:Experiments)-[:`In Category`]->(c:Categories)
          MATCH (e:Experiments)-[:`In SubCategory`]->(s:SubCategories)
          MATCH (e)<-[:Contains]-(t:Topics)
          RETURN e.`Experiment Details - Previous ISS Missions` AS `Experiment Details - Previous ISS Missions`,
          e.`Experiment Details - ISS Expedition Duration` AS `Experiment Details - ISS Expedition Duration`, 
          e.`Experiment Description - Research Overview` AS `Experiment Description - Research Overview`, 
          e.`Experiment Details - Research Benefits` AS `Experiment Details - Research Benefits`, 
          e.`Related Websites` AS `Related Websites`, 
          e.`Experiment Details - Developer(s)` AS `Experiment Details - Developer(s)`, 
          e.`Operations - Operational Protocols` AS `Operations - Operational Protocols`, 
          e.`date` AS `date`, 
          e.`ISS Science for Everyone - Science Results for Everyone` AS `ISS Science for Everyone - Science Results for Everyone`, 
          e.`Experiment Details - Co-Investigator(s)/Collaborator(s)` AS `Experiment Details - Co-Investigator(s)/Collaborator(s)`, 
          e.`Applications - Earth Applications` AS `Applications - Earth Applications`, 
          e.`Experiment Details - Sponsoring Space Agency` AS `Experiment Details - Sponsoring Space Agency`, 
          e.`Experiment Details - Sponsoring Organization` AS `Experiment Details - Sponsoring Organization`, 
          e.`Experiment Details - Principal Investigator(s)` AS `Experiment Details - Principal Investigator(s)`, 
          e.`Operations - Operational Requirements` AS `Operations - Operational Requirements`, 
          e.`Experiment Details - Expeditions Assigned` AS `Experiment Details - Expeditions Assigned`, 
          e.`Experiment Description - Description` AS `Experiment Description - Description`, 
          e.`title` AS `title`, 
          e.`ISS Science for Everyone - Science Objectives for Everyone` AS `ISS Science for Everyone - Science Objectives for Everyone`, 
          e.`_id` AS `_id`, 
          e.`Applications - Space Applications` AS `Applications - Space Applications`, 
          e.`Results/More Information` AS `Results/More Information`, 
          e.`Experiment Details - Previous Missions` AS `Experiment Details - Previous Missions`, 
          e.`Related Publications` AS `Related Publications`, 
          e.`Operations - Operational Requirements and Protocols` AS `Operations - Operational Requirements and Protocols`, 
          e.`Decadal Survey Recommendations` AS `Decadal Survey Recommendations`, 
          e.`Results Publications` AS `Results Publications`, 
          e.`Ground Based Results Publications` AS `Ground Based Results Publications`, 
          e.`ISS Patents` AS `ISS Patents`,
          t.title AS Topic,
          s.title AS SubCategory,
          c.title AS Category"
data <- cypher(graph,query)
save(data,file="data.RData")