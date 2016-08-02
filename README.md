# KA_Interns

## Objective: To create an application to explore and visualize experiments conducted on the International Space Station.  

Review the website and attached documentation

[ISS Experiments](http://www.nasa.gov/mission_pages/station/research/experiments/experiments_hardware.html#Biology-and-Biotechnology)

Located in doc folder:

- MongoDB and Neo4j for the unprivileged.docx
- Setting_UpMongoDB_and_Neo4j.html
- Instructions.docx

## NoSQL databases

Review and familiarize yourself with NOSQL databases, in particular functionality, reliability, performance and examples. We will focus our development on two such databases, Neo4j and MongoDB. 

## What is NoSQL?
NoSQL encompasses a wide variety of different database technologies that were developed in response to the demands presented in building modern applications:

- Developers are working with applications that create massive volumes of new, rapidly changing data types — structured, semi-structured, unstructured and polymorphic data.
- Long gone is the twelve-to-eighteen month waterfall development cycle. Now small teams work in agile sprints, iterating quickly and pushing code every week or two, some even multiple times every day.
- Applications that once served a finite audience are now delivered as services that must be always-on, accessible from many different devices and scaled globally to millions of users.
- Organizations are now turning to scale-out architectures using open source software, commodity servers and cloud computing instead of large monolithic servers and storage infrastructure.

Relational databases were not designed to cope with the scale and agility challenges that face modern applications, nor were they built to take advantage of the commodity storage and processing power available today.
MongoDB
Document databases pair each key with a complex data structure known as a document. Documents can contain many different key-value pairs, or key-array pairs, or even nested documents.

[mongodb](https://www.mongodb.org/)

[mongo chef](http://3t.io/mongochef/)

## Neo4j

Neo4j uses graphs to represent data and the relationships between them. A graph is defined as any graphical representation that consists of vertices (shown by circles) and edges (shown with intersection lines). Within these graphical representations, we have several types of graphs:

- Undirected graphs: nodes and relationships are interchangeable, their relationship can be interpreted in any way. Friendly relationships in the Facebook social network, for example, are this type.
- Directed graphs nodes and relationships are not bidirectional by default. Twitter relationships are this type. A user can follow certain profiles in this social network without them following him.
- Graphs with weight: in this type of graphic relationships between nodes have some kind of numerical assessment. This allows operations to be subsequently performed.
- Graphs with labels: these graphs have labels incorporated that can define the vertices and relationships between them. On Facebook we might have nodes defined by terms like 'friend' or 'co-worker' and relationships like 'friend' or 'partner of'.
- Property graphs: this is a weighted graph with labels where we can assign properties to both nodes and relationships (for example, matters such as name, age, country of residence or birth). This is the most complex.
Neo4j uses property graphs to extract added value of data of any company with great performance and in an agile, flexible and scalable way.

[neo4j](http://neo4j.com/)

[neo4j developer](http://neo4j.com/developer/graph-database/)

### Cypher query language:

Cypher is a declarative graph query language that allows for expressive and efficient querying and updating of the graph store. Cypher is a relatively simple but still very powerful language. Very complicated database queries can easily be expressed through Cypher. This allows you to focus on your domain instead of getting lost in database access.

[cypher](http://neo4j.com/developer/cypher/)


## Neo4j and MongoDB example

Here are a couple of articles describing how to use both databases in conjunction. We will start working on a plan and design when I return on Thursday. 

[neo4j and mongodb](http://neo4j.com/developer/mongodb/)


[mongdb use case](http://neo4j.com/blog/polyglot-persistence-mongodb-wanderu-case-study/)
