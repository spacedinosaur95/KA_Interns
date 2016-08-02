########################################################
#
#		RELATE TOPICS TO OTHER TOPICS
#
#	Global Variables
#		topicProbability = file path to a utf-8 csv file that contains a table. The rows are individual objects or experiments while the columns represent each topic
#		threshhold = the lowest number considered to represent a relationship
#
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
topicProbability = "C:/users/ajbuchan/desktop/project/testEnviroment/data2/LDAGibbs 52 TopicProbabilities.csv"
threshhold = .15
graph = Graph('http://localhost:7474/db/data')
relations = []

def createRelation(first,second):
    NodeA = graph.find_one("Topics",property_key = "_id", property_value = str(first))
    NodeB = graph.find_one("Topics",property_key = "_id", property_value = str(second))
    relation = rel(NodeA,"Relates to",NodeB)
	#SEARCH FOR RELATIONSHIP AND IF NOT FOUND INSERT IT
    temp = graph.match_one(start_node = NodeA,rel_type = "Relates to",end_node = NodeB)
    if temp == None: graph.create(relation)
    else: print("duplicate found")

print("Opening File")
#Open File
fileDesc = open(topicProbability,encoding="utf8")
file = csv.reader(fileDesc)

print("Parsing file")
#iterate through each entry or row
header = True
for row in file:
	if header:
		header = False
		continue
	temp = []
	#iterate through each value in the row
	for index in range(len(row)):
		value = float(row[index])
		if value >= threshhold and value < 1: temp.append(index)
	if len(temp) < 2: continue
	if temp not in relations: relations.append(temp)
print("Found relationships")

#Creates the relationships
print("Creating relationships")
cypher = graph.cypher
for match in relations:
    if len(match) < 2:continue
    for i in range(len(match) - 1):
        createRelation(match[i],match[i+1])
cypher.execute("MATCH (t:Topics)-[:Contains]->(:Experiments)-[:`In Category`]->(c:Categories) CREATE UNIQUE (t)-[r:`Correlates With`]->(c)")
cypher.execute("MATCH (n) REMOVE n:Document")
