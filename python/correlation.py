from py2neo import neo4j, Graph, Node, Relationship, rel

graph = Graph('http://localhost:7474/db/data')
cypher = graph.cypher
cypher.execute("MATCH (t:Topics)-[:Contains]->(:Experiments)-[:`In Category`]->(c:Categories) CREATE UNIQUE (t)-[r:`Correlates With`]->(c)")
