library(dplyr)
library(readr)
library(readxl)
library(ggmap)
library(leaflet)

# Imports the list of NASA Centers and Facilities
NASACenters <- read_excel("~/OneDrive/Work/KnowledgeArchitecture/Deval/NASACenters.xlsx")

NASACenters %>% mutate_geocode(paste(Center, ", ", Address))

lonlat <- geocode(paste(NASACenters$Center, ", ", NASACenters$Address))
NASACenters <- cbind(NASACenters, lonlat)

NASACenters_map <- leaflet() %>% 
  addTiles() %>%
  addCircleMarkers(data = NASACenters, lng = ~ lon, lat = ~ lat, popup = NASACenters$Center) 
