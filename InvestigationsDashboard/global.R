## Clear workspace (important for debugging in interactive session)
rm(list=ls())

## Load packages
## Do Not Delete. Needed for dashboard ##
library(shiny)
library(shinydashboard)
library(shinyapps)
#####################################
## Add your specific pacakages
library(rmarkdown)
library(markdown)
library(gplots) ## for heatmap.2
library(RColorBrewer)

## Source - Place any functions yo want accessible globally in the functions folder
source('functions/heatmap2.R') # overwrite heatmap.2 from gplots with my customized version

## Global variables - used across pages and apps
datGlobal <- NULL
updGlobal <- 0                          # initialize counter to 0
