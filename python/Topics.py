#############################################
#
#		Topics and stuff
#
#	Usage: 	this is only suppose to be run after the R topic modeling program has been run, and you have the topic probability csv file.
#			After you ran the topic modeling, you need to convert the CSV files to UTF-8 and change the global variables in TopicImporting.py and RelatesTo.py
#
#
#
#
#############################################

import os

os.system("python ./Topicing/TopicImporting.py")
os.system("python ./Topicing/RelatesTo.py")