tab9.box <- fluidPage(
  titlePanel("Tab 9"),
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose CSV File',
                accept=c('text/csv',
                  'text/comma-separated-values,text/plain',
                  '.csv')),
      tags$hr(),
      actionButton("update", "Update Data", icon=icon("refresh")),
      tags$small("Update to see preview"),
      tags$hr(),
      checkboxInput('header', 'Header', TRUE),
      ## Tranpose if samples are in rows
      radioButtons('transpose', 'Observations in:',
                   c(Columns=FALSE,
                     Rows=TRUE),
                   TRUE),
      radioButtons('sep', 'Separator',
                   c(Comma=',',
                     Semicolon=';',
                     Tab='\t'),
                   ','),
      radioButtons('quote', 'Quote',
                   c(None='',
                     'Double Quote'='"',
                     'Single Quote'="'"),
                   ''),
      tags$hr(),
      checkboxInput('log2', 'Log 2 Transform', TRUE),
      tags$hr(),
      p('If you want a sample .csv or .tsv file to upload,',
        'you can first download the sample',
        a(href = 'https://internal.shinyapps.io/gallery/066-upload-file/mtcars.csv', 'mtcars.csv'), 'or',
        a(href = 'https://internal.shinyapps.io/gallery/066-upload-file/pressure.tsv', 'pressure.tsv'),
        'files, and then try uploading them.'
        )
    ),
    mainPanel(
      ## dataTableOutput("table")
      tableOutput('contents')
    )
  ),
  includeMarkdown('footer.md')
)
