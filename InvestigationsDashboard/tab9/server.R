options(shiny.maxRequestSize = 10*1024^2) # raise limit to 10 Mb

output$contents <- renderTable({

  inFile <- input$file1

  if (is.null(inFile)) {
    return(NULL)
  }
  ## counter starts at 0 and counts up each time button is pushed
  ## This acts like a `submitButton` function so that changes are not applied
  ## until the update `actionButton` is pressed.
  ## This is done so that other parts of the App can use input$update to update
  ## the data if the user changes it after starting an analysis
  if(input$update > updGlobal) {
    dat <- read.csv(inFile$datapath, header=input$header, sep=input$sep,
                    quote=input$quote, check.names=FALSE)
    rownames(dat) <- dat[,1]
    dat <- dat[,-1]
    if(input$transpose) {
      cnames <- colnames(dat)
      dat <- as.data.frame(t(dat))
      rownames(dat) <- cnames
    }
    if(input$log2) {
      dat <- log2(dat+1)
    }
    datGlobal <<- dat
    updGlobal <<- updGlobal + 1
    return(dat)
  }
})

## output$table <- renderDataTable({

##   ## input$file1 will be NULL initially. After the user selects
##   ## and uploads a file, it will be a data frame with 'name',
##   ## 'size', 'type', and 'datapath' columns. The 'datapath'
##   ## column will contain the local filenames where the data can
##   ## be found.

##   inFile <- input$file1

##   if (is.null(inFile)) {
##     return(NULL)
##   }

##   dat <- read.csv(inFile$datapath, header=input$header, sep=input$sep,
##                   quote=input$quote, check.names=FALSE)
##   rownames(dat) <- dat[,1]
##   dat <- dat[,-1]
##   if(input$transpose) {
##     cnames <- colnames(dat)
##     dat <- as.data.frame(t(dat))
##     rownames(dat) <- cnames
##   }
##   if(input$log2) {
##     dat <- log2(dat+1)
##   }
##   datGlobal <<- dat
##   return(dat)

## }, options = list(lengthMenu = c(5, 30, 50, 100), pageLength = 5))
