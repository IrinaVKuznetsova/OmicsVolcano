server <- function(input, output) {
  
  LoadTable <- reactive ( {
    print(c("Load File...", input$UI_INPUT_FILE_NAME))
    req(input$UI_INPUT_FILE_NAME)
    #    shiny::validate(need(input$UI_INPUT_FILE_NAME, "Select an input file with Browse button..."))
    
    tryCatch(
      {
        df <- read.csv(input$UI_INPUT_FILE_NAME$datapath,
                       header = input$UI_INPUT_FILE_HASHEADER,
                       sep = input$UI_INPUT_FILE_SEPARATOR,
                       quote = "")
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
        print("testeerrrrs")
        # ARTUR ERROR HANDLER
      }
    )
    output$UI_INPUT_FILE_RESULTS <- renderTable(df)

    return(df)
    
    #    read.csv(input$UI_INPUT_FILE$datapath, header = T, sep = "\t", quote = "")
    
  }
  )
  
  output$UI_INPUT_FILE_RESULTS <- renderTable(LoadTable())
  

  
  output$messageMenu <- renderMenu({
    # Code to generate each of the messageItems here, in a list. This assumes
    # that messageData is a data frame with two columns, 'from' and 'message'.
    # msgs <- apply(messageData, 1, function(row) {
    #  messageItem(from = row[["from"]], message = row[["message"]])
    #})
    
    # This is equivalent to calling:
    #   dropdownMenu(type="messages", msgs[[1]], msgs[[2]], ...)
    dropdownMenu(type = "notifications",
                 notificationItem(
                   text = "5 new users today",
                   icon("users")
                 ))
  })
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
}