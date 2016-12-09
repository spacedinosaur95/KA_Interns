
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#


## load all of the packages 
library(shiny)
library(shinydashboard)
library(gdata)
library(plotly)
library(RNeo4j)

## getting the data for this prototype ... 
prototypeData <- read.csv("prototypeData")

## SKIN 
skin <- Sys.getenv("DASHBOARD_SKIN")
skin <- tolower(skin)
if (skin == "")
  skin <- "blue"

## HEADER 
header <- dashboardHeader(title = "ISS Data Vis")

## SIDEBAR 
sidebar <- dashboardSidebar(sidebarMenu(
  
  ## menuItem for Welcome
  menuItem(
    "Welcome", 
    tabName = "welcome"
    ## icon = icon("font awesome icon name") **icons will not work in Internet Explorer 
  ), 
  
  ## menuItem for Find Experiment 
  menuItem(
    "Find Experiment", 
    tabName = "findExperiment"
  ), 
  
  ## menuItem for Compare, Contrast, and Relate Data
  menuItem(
    "Compare, Contrast, and Relate", 
    tabName = "ccr"
  ), 
  
  ## menuItem for Research Impact 
  menuItem(
    "Research Impact",
    tabName = "researchImpact"
  ),
  
  ## menuItem for Agency Locations 
  menuItem(
    "Agency Locations", 
    tabName = "agencyLocations"
  ), 
  
  ## menuItem for Journey to Mars 
  menuItem( 
    "Journey to Mars", 
    tabName = "journeyToMars"
    )
))

## BODY 
body <- dashboardBody(tabItems(
  
  ## tabItem for Welcome 
  tabItem(
  tabName = "welcome", 
  box(
    title = "Welcome", 
    status = "primary", 
    solidHeader = TRUE,
    collapsible = FALSE
  )), 
  
  ## tabItem for Find Experiment 
  tabItem(
    tabName = "findExperiment", 
    box(
      title = "Find an Experiment", 
      status = "primary", 
      solidHeader = TRUE,
      collapsible = FALSE
    ),
    box(
      title = "Help Documentation", 
      status = "warning", 
      solidHeader = TRUE,
      collapsible = FALSE
    )
  ),
  
  ## tabItem for Compare, Contrast, and Relate data 
  tabItem(
    tabName = "ccr", 
    box(
      title = "Compare, Contrast, and Relate Data", 
      status = "primary", 
      solidHeader = TRUE,
      collapsible = FALSE
    ), 
    box(
      title = "Help Documentation", 
      status = "warning", 
      solidHeader = TRUE,
      collapsible = FALSE
    )
  ), 
  
  ## tabItem for Research Impact 
  tabItem( 
    tabName = "researchImpact", 
    box(
      title = "Research Impact", 
      status = "primary", 
      solidHeader = TRUE,
      collapsible = FALSE
    ), 
    box(
      title = "Help Documentation", 
      status = "warning", 
      solidHeader = TRUE,
      collapsible = FALSE
    )
    ),
  
  ## tabItem for Agency Locations  
  tabItem( 
    tabName = "agencyLocations", 
    box(
      title = "Agency Locations", 
      status = "primary", 
      solidHeader = TRUE,
      collapsible = FALSE
    ), 
    box(
      title = "Help Documentation", 
      status = "warning", 
      solidHeader = TRUE,
      collapsible = FALSE
    )
  ),
  
  ## tabItem for Journey to Mars
  tabItem( 
    tabName = "journeyToMars", 
    box(
      title = "Journey to Mars", 
      status = "primary", 
      solidHeader = TRUE,
      collapsible = FALSE
    ), 
    box(
      title = "Help Documentation", 
      status = "warning", 
      solidHeader = TRUE,
      collapsible = FALSE
    )
  )
  
))