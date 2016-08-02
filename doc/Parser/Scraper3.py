#############################################################
#       Python Web Scraper
#   written in python2 but converted to python 3
#
#   This script will search through NASA's website and parse experiment results and put them into a database
#
#   http://www.nasa.gov/mission_pages/station/research/experiments/experiments_hardware.html
#
#   Needs lxml and requests to work
#
#	***IMPORTANT***
#		skip to end of file and change file directories to match environment
#
#############################################################

from lxml import html
from lxml import etree #When done delete the unused import line
from lxml.etree import fromstring   #i think i can delete this line
from py2neo import neo4j, Graph, Node, Relationship, rel
import requests         #no need for this anymore
import sys
import os
import json
import time

#reload(sys)  
#sys.setdefaultencoding('utf8')

#GLOBAL VARIABLES
#url with list of experiments
parentURL = 'http://www.nasa.gov/mission_pages/station/research/experiments/experiments_hardware.html'
pagesFailed = []

#ignore, variables used later to store nodes and relationships
experimentsDict = {}
categories = []
subCategory = []
agencies = []
relationships = []
expeditions = []

def parseTable(table):
    global subCategory
    global categories
    global experimentsDict
	#these arent really experiements and dont follow the format so they break the program
    ExperimentsToIgnore = ['696',
							'211',
							'490',
							'484',
							'440',
							'432',
							'476',
							'14',
							'448',
							'189',
							'657',
							'441',
							'17',
							'97',
							'419',
							'195',
							'551',
							'27',
							'131',
							'770',
							'292',
							'172',
							'412',
							'934',
							#'1062',#REMOVE THIS
							#'1973',#REMOVE THIS
							'192']
    #This part of the function is for determining the section value
    tr = table[0]
    td = tr[0]
    temp =  [x for x in td.itertext()]	#this gets the text node
    section = temp[0]
    print ('*************************** Parsing New Section ******************************')
    print ('*Parsing section:\t' + section)
	
    categories.append({"title":section,"subs":[]})
	
	
	#Done determining the section
    #iterate throught all the sub sections
    #we skip the first element in the list because its an empty <td> used for formatting
    for subSection in table.getchildren()[1:]:
        #Finds subsection title
        #subSection = <tr>
        #temp = tr > td > span > text[]
        temp = [x for x in subSection[1][0].itertext()]
        subSectionTitle = temp[0]
        #some sections have N/A and are blank. Could mean that information will be added later but for right now lets just skip them
        if subSectionTitle == 'N/A': continue
        print ('*Parsing sub section:\t' + subSectionTitle)
		
		
        subCategory.append({"title":subSectionTitle,"Experiments":[]})
        categories[-1]["subs"].append(len(subCategory)-1)
        queueRelationship({"collection":"SubCategories","_id":len(subCategory)-1},{"collection":"Categories","_id":len(categories)-1},"In Category")
		
        #link = all the <a> elements in that subsection
        #we skip the first element because it is a span and contains the title
        for link in subSection[1].getchildren()[1:]:
            #Every other tag is a <br/> so lets skip those
            if link.tag != 'a': continue
            ExpID = getIndex(link.values()[1])
            if ExpID in ExperimentsToIgnore: continue
            subCategory[-1]["Experiments"].append(ExpID)
            experimentsDict[ExpID] = parseExperiment(link.values()[1])
			#Adds experiment to list of experiments and stores relationships between categories and subcategories
            queueRelationship({"collection":"Experiments","_id":ExpID},{"collection":"Categories","_id":len(categories)-1},"In Category")
            queueRelationship({"collection":"Experiments","_id":ExpID},{"collection":"SubCategories","_id":len(subCategory)-1},"In SubCategory")
            
#Returns experiment id from url ex. experiments/431.html returns 431
def getIndex(link):
    ExpID = link[-9:-5]
    if ExpID[0] == '/': ExpID = ExpID[1:]
    if ExpID[:2] == 's/': ExpID = ExpID[2:]
    if ExpID[:3] == 'ts/': ExpID = ExpID[3:]
    return ExpID
#takes link of experiment, loads it, parses it and creates relationships
def parseExperiment(link):
    ###########IMPORTANT VARIABLES
    global pagesFailed
    global agencies
    global categories
    global expeditions
    location = 'http://www.nasa.gov' + link
	#manually copied and pasted the categories and sub categories
    mainCategories = ['ISS Science for Everyone',
                    'Experiment Details',
                    'Experiment Description',
                    'Applications',
                    'Operations',
                    'Decadal Survey Recommendations',
                    'Results/More Information',   #Exceptions from here down
                    'Results Publications',
                    'Ground Based Results Publications',
                    'ISS Patents',
                    'Related Publications',
                    'Related Websites',
                    'Imagery']
    subCategories = ['Principal Investigator(s)',
                    'Co-Investigator(s)/Collaborator(s)',
                    'Developer(s)',
                    'Sponsoring Space Agency',
                    'Sponsoring Organization',
                    'Research Benefits',
                    'ISS Expedition Duration',
                    'Expeditions Assigned',
                    'Previous ISS Missions',
                    'Science Objectives for Everyone',
                    'Science Results for Everyone',
                    'Previous Missions',
                    'Research Overview',
                    'Description',
                    'Space Applications',
                    'Earth Applications',
                    'Operational Requirements and Protocols',
                    'Operational Requirements',
                    'Operational Protocols']
    ###########LOAD WEBPAGE
    print ('>Loading link:\t' + location)
    document = html.parse(location)
    if document: print ('>Webpage Loaded')
    else:
        #Assumes page failed to load
        print ('>Webpage Failed to locad: ' + location)
        pagesFailed.append(location)
        return
    document = document.getroot()
    
    
    ###########WEBPAGE LOADED
    #TEMP VARIABLES
    #root = div.pane-content > div
    root = document.find_class('pane-content')[2][2]
    experiment = {} #using a dictionary to store all the information
    text = [x for x in root.itertext()] #all text nodes
    counter = 0
    category = ''
    subCatHeader = ''
    temp = {}
    
	#IDENTIFY TITLE and DATE
    header = document.find_class('panel-pane pane-custom pane-2')[0][0]
    headerText = [x for x in header.itertext()]
	#Sets title and date appropriatly then checks if date even exists
    title = headerText[0].replace('"',"").replace('\"',"")
    date = headerText[0][-8:]
	
    if len(date.split('.')) == 3:
	    title = headerText[0][:-11].replace('"',"").replace('\"',"")
    else:
	    date = 'unknown'
	#####################
    experiment['title'] = title
    experiment['date'] = date
    experiment["_id"] = getIndex(link)
    ###########LOOP THROUGH ALL THE TEXT NODES
    # the first ~16 nodes are just useless links and formatting nodes
    for x in text[16:]:
        #Filter out the useless nodes that are from the poor web design
        node = x
        node = node.replace("\n","")
        node = node.replace("\r","")
        node = node.replace("\t","")
        node = node.replace('"',"")		#these two lines resolve the problem when creating JSON files
        node = node.replace("\"","")
        node = node.strip()
        test = node.replace(" ","")
        if test == "": continue
        #useless nodes
        if node == '' or node == '^ back to top' or "The following content was provided by" in node or 'OpNom:' in node:
            continue
        ###############################################################
        
        #defines categories
        if node in mainCategories:
            category = node
            if node == 'Imagery': break
            experiment[category] = ''
            temp = {}
            subCatHeader = ''
            
        elif node in subCategories:
            #For some unknown reason this if statement is skipped the first time its is true
            subCatHeader = node
            temp[subCatHeader] = ''
        else:
            if subCatHeader == '' and category == mainCategories[0]:
				#This statement is used to fix the problem above about the if statement being skipped
                subCatHeader = node
                temp[subCatHeader] = ''
                continue
            if subCatHeader == '':
				#Defines the sub category
                if experiment[category] == '': experiment[category] = node
                else: experiment[category] = experiment[category] + '\n' + node
            else:
				#Defines the info associated with the sub category or category
                if temp[subCatHeader] == '': temp[subCatHeader] = node
                else: temp[subCatHeader] = temp[subCatHeader] + '\n' + node
                experiment[category] = temp
				#Creates a list of agencies and defines relationships
                if subCatHeader == 'Sponsoring Space Agency' and category == 'Experiment Details':
                    if node not in agencies:
                        agencies.append(node)
                    agencyIndex = agencies.index(node)
                    queueRelationship({"collection":"Agencies","_id":agencyIndex},{"collection":"Experiments","_id":experiment["_id"]},"Performed")
                    #queueRelationship({"collection":"Agencies","_id":agencyIndex},{"collection":"Categories","_id":len(categories)-1},"Studies") Agencies -> studies -> categories
                    queueRelationship({"collection":"Agencies","_id":agencyIndex},{"collection":"SubCategories","_id":len(subCategory)-1},"Studies")#UNCOMMENT TO CREATE RELATIONSHIP BETWEEN SUBCATEGORIES AND AGENCIES
                if subCatHeader == 'Expeditions Assigned' and category == 'Experiment Details':
                    #print(node)
                    exped = node.split(',')
                    for e in exped:
                        if e not in expeditions: expeditions.append(e)
                        expeditionIndex = expeditions.index(e)
                        queueRelationship({"collection":"Expeditions","_id":expeditionIndex},{"collection":"Experiments","_id":experiment["_id"]},"Assigned")
        continue
	
    return experiment
#This function is for testing purposes
def prettyPrintExperiment(experiment):
    for cat, info in experiment.items():
        print ('Category:\t' + cat)
        if isinstance(info,str):
            print ('\t\t\t' + info)
        else:
            for sub, text in info.items():
                print ('Sub Cat:\t\t' + sub)
                print (text)
        
def convertToJSON(data):
    #converts experiments list to json format
    temp = '{'
    for cat, info in data.items():
        if isinstance(info,str):
            info.replace('"',"").replace('\"',"")
            if '<!--' in info: continue
            if info != '': temp = temp + '"' + cat + '":"' + info + '",'
        else:
            for sub, text in info.items():
                text.replace('"',"").replace('\"',"")
                if '<!--' in text: continue
                if text != '': temp = temp + '"' + cat + ' - ' + sub + '":"' + text + '",'
			
    temp = temp[:-1] + '}'
    temp = temp.replace("\o","").replace("\ ","").replace("”","")
	
    return temp
#Formats to JSON format
def formatCat(data):
	temp = ''
	for key,value in enumerate(data):
		temp = temp + '{"_id":"' + str(key) + '","title":"' + value['title'] + '"}' 
	return temp
#Formats to JSON format
def formatAgency(data):
    temp = ''
    for key,value in enumerate(data):
	    temp = temp + '{"_id":"' + str(key) + '","title":"' + value + '"}'
    return temp
#Formats to JSON format
def formatExpeditions():
    global expeditions
    temp = ''
    for key,val in enumerate(expeditions):
        temp = temp + '{"_id":"' + str(key) + '","title":"' + val.replace('\u25cf','') + '"}'
    return temp.replace('\u25cf','')
#Adds relationships to a list
def queueRelationship(start,end,name):
    global relationships
    temp = {"start":start,"end":end,"name":name}
    if name == 'Studies' and temp in relationships: return
    if temp not in relationships: relationships.append(temp)
    #relationships.append(temp)
#takes list of relationships and adds them to the database.
def createRelationships():
    global relationships
    graph = Graph('http://localhost:7474/db/data')
    for r in relationships:
        NodeA = graph.find_one(r["start"]["collection"],property_key = "_id", property_value = str(r["start"]["_id"]))
        NodeB = graph.find_one(r["end"]["collection"],property_key = "_id", property_value = str(r["end"]["_id"]))
        graph.create(rel(NodeA,r["name"],NodeB))
	
##############################################
#
#		This is where the functions stop and where the program begins to execute
#
##############################################


#Gets webpage and checks if loaded properly
document = html.parse(parentURL)
if document: print ('Webpage Loaded')
else:
    #Assuming HTTP status != 200
    print ('Failed to load page')
    sys.exit
    
#document represents <html> element
document = document.getroot()
#<div class="pane-content"> --> <div>
#root represents the <div> that holds all the table which hold experiment links aka the parent node
root = document.find_class('pane-content')[2][3]

counter = 0
for child in root.getchildren():
    if child.tag == 'table':
        #if counter == 2:
        parseTable(child)
        #counter = counter + 1
#prettyPrintExperiment(exp)

print("****************************************")
print("* Formatting and Importing Documents to MongoDB and Neo4j")
f = open('C:\\Users\\ajbuchan\\Desktop\\Project\\experiment.json','wb')
jobj = ''

#######################################
#
#	***IMPORTANT***
#
#	change file directories to correctly match environment
#
#
#######################################

for x in experimentsDict.items():
    jobj = jobj + convertToJSON(x[1])
f.write(jobj.replace("\r","").replace("\n","").replace("\t","").encode())
f.close()
os.system("\"C:\\program files\\mongodb\\server\\3.2\\bin\\mongoimport.exe\" --db ISSExperiments --collection Experiments --file C:\\users\\ajbuchan\\desktop\\Project\\experiment.json")


subs = formatCat(subCategory)
f = open('C:\\Users\\ajbuchan\\Desktop\\Project\\subCats.json','w+')
f.write(subs)
f.close()
os.system("\"C:\\program files\\mongodb\\server\\3.2\\bin\\mongoimport.exe\" --db ISSExperiments --collection SubCategories --file C:\\users\\ajbuchan\\desktop\\Project\\subCats.json")


cats = formatCat(categories)
f = open('C:\\Users\\ajbuchan\\Desktop\\Project\\cats.json','w+')
f.write(cats)
f.close()
os.system("\"C:\\program files\\mongodb\\server\\3.2\\bin\\mongoimport.exe\" --db ISSExperiments --collection Categories --file C:\\users\\ajbuchan\\desktop\\Project\\cats.json")

age = formatAgency(agencies)
f = open('C:\\Users\\ajbuchan\\Desktop\\Project\\agencies.json','w+')
f.write(age)
f.close()
os.system("\"C:\\program files\\mongodb\\server\\3.2\\bin\\mongoimport.exe\" --db ISSExperiments --collection Agencies --file C:\\users\\ajbuchan\\desktop\\Project\\agencies.json")

e = formatExpeditions()
f = open('C:\\Users\\ajbuchan\\Desktop\\Project\\expeditions.json','w+')
f.write(e)
f.close()
os.system("\"C:\\program files\\mongodb\\server\\3.2\\bin\\mongoimport.exe\" --db ISSExperiments --collection Expeditions --file C:\\users\\ajbuchan\\desktop\\Project\\expeditions.json")

print("Done updating, waiting for mongo-connector")
time.sleep(400)
print("mongo-connector is either done or encountered a problem")
print("Generating Relationships")
createRelationships()
print("All Done")




