########################################################
#
#		TOPIC IMPORTING
#
#	Input:
#		loads csv file with format:
#			
#			Topic 1 | Topic 2 | Topci 3 | Topic 4 | ...
#			--------+---------+---------+---------+------
#			space   | area    | crew    | space   | ...
#			--------+---------+---------+---------+------
#			flight  | ant     | member  | ISS     | ...
#			--------+---------+---------+---------+------
#			......  | ...     | ......  | ...     | ...
#
#
#	Usage:
#		Specify the number of terms to take from each topic. then run it
#
#		Must have mongoimport set up
#
#		*NOTICE: this program only takes csv files in utf-8
#		
#
#	JSON format:
#		JSON = 	{"_id":pos in array,"name":"Topic X","value":"space flight long"}
#				{"_id":pos in array,"name":"Topic X","value":"area ant densiti"}
#
#
########################################################
from py2neo import neo4j, Graph, Node, Relationship, rel
import sys
import os
import json
import csv
import time

#Global Variables
TopicPath = "C:/users/ajbuchan/desktop/Project/testEnviroment/data2/LDAGibbs 52 TopicsToTerms utf8.csv"
DocToTopicPath = "C:/users/ajbuchan/desktop/Project/testEnviroment/data2/LDAGibbs 52 DocsToTopics.csv"
numberOfTerms = 3
relationships = []



def queueRelationship(start,end,name):
    global relationships
    temp = {"start":start,"end":end,"name":name}
    relationships.append(temp)
    #relationships.append(temp)
def createRelationships():
    global relationships
    graph = Graph('http://localhost:7474/db/data')
    for r in range(1,len(relationships)):
        print(r)
        print(relationships[r])
        NodeA = graph.find_one(relationships[r]["start"]["collection"],property_key = "_id", property_value = str(relationships[r]["start"]["_id"]))
        NodeB = graph.find_one(relationships[r]["end"]["collection"],property_key = "_id", property_value = str(relationships[r]["end"]["_id"]))
        graph.create(rel(NodeA,relationships[r]["name"],NodeB))


fileDesc = open(TopicPath,encoding="utf8")
file = csv.reader(fileDesc)


#convert reader iterable to navagateable list
dataStruct = []
tempNum = numberOfTerms
for row in file:
	if tempNum == -1: break
	temp = []
	for col in row:
		temp.append(col)
	dataStruct.append(temp)
	tempNum = tempNum - 1

d = {}
jsonString = ''
cols = len(dataStruct[0])
rows = len(dataStruct)
#Iterate through multidemensional array and convert it to a JSON string
for col in range(1,cols):
	#the commented out one creates json object like this: {"_id":1, "Title":"Topic 1", "Value": "liquid flow fluid"}
	#jsonString = jsonString + '{"_id":' + str(col) + ', "title":"' + dataStruct[0][col] + '", "Value": "'
	#Below follows the format of: {"_id":1, "title": "liquid flow fluid"}
	jsonString = jsonString + '{"_id":' + str(col) + ', "title": "'
	for row in range(1,numberOfTerms + 1):
		jsonString = jsonString + dataStruct[row][col] + " "
	jsonString = jsonString[:-1] + '"}'
print(jsonString)

f = open('C:\\Users\\ajbuchan\\Desktop\\Project\\Topics.json','w+')
f.write(jsonString)
f.close()
os.system("\"C:\\program files\\mongodb\\server\\3.2\\bin\\mongoimport.exe\" --db ISSExperiments --collection Topics --file C:\\users\\ajbuchan\\desktop\\Project\\Topics.json")

time.sleep(20)

fileDesc = open(DocToTopicPath,encoding="utf8")
file = csv.reader(fileDesc)

relationships = []
for row in file: queueRelationship({"collection":"Topics","_id":row[1]},{"collection":"Experiments","_id":row[0]},"Contains")
createRelationships()

#print(relationships[38])

#graph = Graph('http://localhost:7474/db/data')
#NodeA = graph.find_one(relationships[1]["start"]["collection"],property_key = "_id", property_value = str(relationships[1]["start"]["_id"]))
#print(NodeA)
#print(relationships[1]["start"]["collection"])
#print(str(relationships[1]["start"]["_id"]))