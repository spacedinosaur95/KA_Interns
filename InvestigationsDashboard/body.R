## GET STARTED ----------------------------------------------------------------------
source('introduction/intro.R', local=TRUE)

start <- tabItem(
  tabName = "start",
  start.box
)

## Tab 1 ----------------------------------------------------------------------
source('tab1/ui.R', local=TRUE)

tab1 <- tabItem(
  tabName = "tab1",
  tab1.box
)

## Tab 2 ----------------------------------------------------------------------
source('tab2/ui.R', local=TRUE)

tab2 <- tabItem(
     tabName = "tab2",
     tab2.box
)

## Tab 3 ----------------------------------------------------------------------
source('tab3/ui.R', local=TRUE)

tab3 <- tabItem(
     tabName = "tab3",
     tab3.box
)

## Tab 4 ----------------------------------------------------------------------
source('tab4/ui.R', local=TRUE)

tab4 <- tabItem(
     tabName = "tab4",
     tab4.box
)

## Tab 5 ----------------------------------------------------------------------
source('tab5/ui.R', local=TRUE)

tab5 <- tabItem(
     tabName = "tab5",
     tab5.box
)

## Tab 6 ----------------------------------------------------------------------
source('tab6/ui.R', local=TRUE)

tab6 <- tabItem(
     tabName = "tab6",
     tab6.box
)

## Tab 7 ----------------------------------------------------------------------
source('tab7/ui.R', local=TRUE)

tab7 <- tabItem(
     tabName = "tab7",
     tab7.box
)

## Tab 8 ----------------------------------------------------------------------
source('tab8/ui.R', local=TRUE)

tab8 <- tabItem(
     tabName = "tab8",
     tab8.box
)

## Tab 9 ----------------------------------------------------------------------
source('tab9/ui.R', local=TRUE)

tab9 <- tabItem(
     tabName = "tab9",
     tab9.box
)

## Tab 10 ----------------------------------------------------------------------
source('tab10/ui.R', local=TRUE)

tab10 <- tabItem(
     tabName = "tab10",
     tab10.box
)


## ACKNOWLEDGEMENTS ------------------------------------------------------------
source('acknowledgements/acknowledgements.R', local=TRUE)

acknowledgements <- tabItem(
  tabName = "acknowledgements",
  ack.box
)

## BODY ------------------------------------------------------------------------
body <- dashboardBody(
  includeCSS("www/custom.css"),
  tabItems(
    start,
    tab1,
    tab2,
    tab3,
    tab4,
    tab5,
    tab6,
    tab7,
    tab8,
    tab9,
    tab10,
    acknowledgements
  )
)
