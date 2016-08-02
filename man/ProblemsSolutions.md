Problems and Soultions
================

GitHub Documents
----------------

This is an R Markdown format used for publishing markdown documents to GitHub. When you click the **Knit** button all R code chunks are run and a markdown file (.md) suitable for publishing to GitHub is generated.

Problems and Soulutiuons for Project
------------------------------------

**Problem:** There are a bunch of different HTML and XML parsers for python. Some are poorly documented. Others break when you give it HTML from NASA’s website. The webpages I have been looking at are not the best written and will break some of the xml parsers. **Solution:** [There are more links to other resources in the resources folder. This one seemed to be the most useful:](http://lxml.de/api/lxml.etree._Element-class.html)

**Problem:** etree throws errors when parsing NASA’s website **Solution:** switch to LXML

**Problem:** Keep coming across encoding problems. **Solution:** What ever character it does not recognize, use .replace(“?”,””) to get rid of the character

**Problem:** No admin rights, so its difficult to set up databases **Solution:** I wrote a document on how to set up stuff with out admin rights

**Problem:** Could not install pip **Solution:** [go to](https://bootstrap.pypa.io/get-pip.py) and download it. If it does not download view the sources code, save it, rename it and save it in a different encoding for it to work.

**Problem:** Getting unauthorized access when using mongo-connector with neo4j. **Solution:** Open up Neo4j config file and disable authentication. You can try setting environment variables, but those didn’t work for me.

For more problems and solutions check out the document I made about setting up Neo4j and MongoDB
