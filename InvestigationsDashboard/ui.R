## Define structure of dashboard
## In most cases all yo want to do here is change the skin color
source("header.R")
source("sidebar.R")
source("body.R")

ui <- dashboardPage(
  skin = "blue",
  header, sidebar, body
)
