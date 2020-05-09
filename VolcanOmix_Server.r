# ====================================================================
# ====================================================================
# ====================================================================
# Title:      OmicsVolcano 
# Copyright:  (C) 2020
# License:    GNU General Public
# ====================================================================
# ====================================================================
# ====================================================================




# ====================================================================
# ====================================================================
# ====================================================================
# Script Developers 
# ====================================================================
# ====================================================================
# ====================================================================

# Author:    Irina Kuznetsova
# email:     irina.kuznetsova@perkins.org.au

# Co-developer: Artur Lugmayr
# email:        lartur@acm.org




# ====================================================================
# ====================================================================
# ====================================================================
# License
# ====================================================================
# ====================================================================
# ====================================================================

# OmicsVolcano is visualization software that enables to explore interactively
# volcano plot for presence of mitochondrial localized genes or proteins.
# 
#     Copyright (C) 2020  Irina Kuznetsova
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.




# ====================================================================
# ====================================================================
# ====================================================================
# INSTALL
# ====================================================================
# ====================================================================
# ====================================================================

# install.packages("dplyr")
# install.packages("tidyverse")
# install.packages('shiny')
# install.packages("plotly")
# install.packages('DT')
# install.packages("shinydashboard")
# install.packages("ggplot2") 
# install.packages("svglite")
# install.packages("stringr")
# install.packages("shinyWidgets")
# install.packages("devtools")


`%then%` = shiny:::`%OR%` # Note: %then% does not exist in current preview implementations of Shiny. 
                          # You can use the first line of code below to create a %then% operator.
                          # https://shiny.rstudio.com/articles/validation.html

##########################################################################################################
# II Reference Files MOUSE
##########################################################################################################
mm_ribos_file = read.table("./ReferenceFiles/Mouse/mm_Ribosomal_processes19March20.txt",
                           header = T,
                           sep    = "\t",
                           fill   = T,
                           quote  = "")   # dim = 82 x 3 | yourlist  Entry  Entry.name Protein.names Gene.names Organism

mm_processes_file = read.table("./ReferenceFiles/Mouse/mm_MitoCarta_MitoXplorer_AF_2April2020.txt",
                               header = T,
                               sep    = "\t",
                               fill   = T, 
                               quote  = "")   # dim = 1495  x 3 | GeneID Symbol Description Synonyms Maestro.score FDR Evidence Tissues

##########################################################################################################
# II Reference Files HUMAN
##########################################################################################################
hs_ribos_file = read.table("./ReferenceFiles/Human/hs_ribosomal_30March2020.txt",
                           header = T,
                           sep    = "\t",
                           fill   = T,
                           quote  = "")[, c(2,3,4)] # dim = 82  x 4

hs_processes_file = read.table("./ReferenceFiles/Human/hs_MitoCarta_MitoXplorer_AF_2April2020.txt",
                               header = T,
                               sep    = "\t",
                               fill   = T, 
                               quote  = "")[,c(1,2,3,4)]   # dim(1516    5)

# Error handling
displayErrorMessage = function (messagesubject, message, errortrace) {
  showModal(modalDialog(
    title     = messagesubject,
    fade      = TRUE,
    easyClose = TRUE,
    message,
    footer    = tagList(modalButton("Close"))  )) }


##################
# IV Server body #
##################
server = function(input, output, session) {
  
  ###########################################################################################################
  # 0. UI Frontend Handling
  ###########################################################################################################
  
  # Initialize UI default values
  DEFAULT_STATUS_MESSAGE     = "Ok."
  UI_STATUS_LIST             = c("General", "Plot")
  UI_STATUS                  = "General"
  UI_RIGHTDASBOARD_HELP_TEXT = "No info available."
  UI_NOTIFICATIONS           = c( c("Application Started!", "thumbs-up") )
  
  # Initialize the status bar
  output$UI_INFO_PROCESS = renderInfoBox({
    infoBox ("Process",
             paste0 ("Mouse"),
             paste0 ("Show All Mitochondrial Genes"),
             icon  = icon("fas fa-filter"),
             color = "yellow")   })
  
  output$UI_INFO_GENERAL = renderInfoBox ({
    infoBox ("Threshold/Signficance",
             paste0 (input$VerticalThreshold),
             paste0 (input$Signif),
             icon  = icon ("tachometer-alt"),
             color = "yellow")  })
  
  output$UI_INFO_FILENAME = renderInfoBox ({
    infoBox ("Filename",
             paste0 (input$UI_INPUT_FILE_NAME),
             icon  = icon ("database"),
             color = "yellow")  })
  
  output$UI_INFO_EXPLORE = renderInfoBox ({
    infoBox ("Explore",
             "Manual List",
             icon = (icon("list-ol")),
             color = "yellow")  })
  
  
  output$ui_status_box_message = renderText( 
    { paste0(DEFAULT_STATUS_MESSAGE) } )
  
  
  displayUIStatusMessage = function(message, error) {
    output$ui_status_box_message = renderText({paste0(message)})}
  
  
  displayUIRightDashboardMenue = function (info_text) {
    output$UI_RIGHT_DASBOARD_HELP_TEXT = renderText({paste0(info_text)})
    output$UI_RIGHT_DASBOARD_CONTENT   = renderUI({
      input$ui_threshold_configuration
      #        sliderInput("n", "N", 1, 1000, 500)
    }    )}
  
  
  output$UI_NOTIFICATIONS = renderMenu ( {
    dropdownMenu (
      type = "notifications",
      notificationItem(
        text = "Applications successfuly started.",
        icon("thumbs-up")  ))  })
  
  # Observe hich left side menue bar has been selected and adjust the contextual menue of the right sidebar
  #  observe({
  #    if (input$ui_dashboard_sidebar == "menue_tab_exp_plot") {
  #      shinyjs::addClass(selector = "aside.control-sidebar", class = "control-sidebar-open")
  #      displayUIRightDashboardMenue ("Please load the data to create the plot.")
  #    } else {
  #      shinyjs::removeClass(selector = "aside.control-sidebar", class = "control-sidebar-open")
  #    }
  #  })
  

  # CONTEXTUALIZED RIGHT MENUE DEPENENDENT WHAT IS SELECTED ON THE LEFT MENUE
  UI_INFO_TEXTS = list(
    menue_tab_file_open  = ("Open data file."),
    menue_tab_file_close = ("close data file."),
    
    menue_tab_exp_plot     = ("Plot and explore data."),
    menue_tab_exp_genelist = ("Explore gene list."),
    menue_tab_exp_mitproc  = ("Mitochondrial process explorer."),
    
    menue_tab_download_plot  = ("Download data plot."),
    menue_tab_download_table = ("Download data tables."),
    
    menue_tab_help  = ("Help page."),
    menue_tab_about = ("About page.")  )
  
  
  # Updates the right context menue, dependent which left menue in the dashboard has been selected
  observeEvent(input$ui_dashboard_sidebar, {
    print(input$ui_dashboard_sidebar)
    x = UI_INFO_TEXTS["input$ui_dashboard_sidebar"]
    
    if (is.null(x)) { x=""}
    
    output$UI_RIGHT_DASHBOARD_HELP_TEXT = renderText({paste0( x )})
    x="none"
    
    if ( (input$ui_dashboard_sidebar == "menue_tab_exp_plot") | (input$ui_dashboard_sidebar == "menue_tab_exp_genelist") | (input$ui_dashboard_sidebar == "menue_tab_exp_mitproc") )
    { x = input$ui_dashboard_sidebar}
    updateTabsetPanel(session, "params", selected = x) }) 
  
  
  # Status box upldates: Mitochondria process   
  observeEvent(input$OrganismSource, {
    output$UI_INFO_PROCESS = renderInfoBox ({
      infoBox ( "Process",
                paste (input$OrganismSource),
                paste (input$MtProcess),
                icon  = icon("fas fa-filter"),
                color = "yellow")
        #      paste (input$OrganismSource),
        #      paste (input$MtProcess))
      # paste0 (input$mtProcess)
    })   })
  
  
  observeEvent(input$MtProcess, {
    output$UI_INFO_PROCESS = renderInfoBox ({
      infoBox ("Process",
               paste (input$OrganismSource),
               paste (input$MtProcess),
               icon  = icon("fas fa-filter"),
               color = "yellow")
        #      paste (input$OrganismSource),
        #      paste (input$MtProcess))
      # paste0 (input$mtProcess)
    })  })
  
  
  observeEvent(input$VerticalThreshold, {
    output$UI_INFO_GENERAL = renderInfoBox ({
      infoBox ("Threshold / Significance",
               paste0 (input$VerticalThreshold),
               paste0 (input$Signif),
               icon  = icon("tachometer-alt"),
               color = "yellow")
        #      paste (input$OrganismSource),
        #      paste (input$MtProcess))       
      # paste0 (input$mtProcess)
    })  })
  
  
  observeEvent(input$UI_INPUT_FILENAME, {
    output$UI_INFO_FILENAME = renderInfoBox ( {
      infoBox ("Filename",
               paste0 (input$UI_INPUT_FILENAME),
               icon  = icon("database"),
               color = "yellow")
        #      paste (input$OrganismSource),
        #      paste (input$MtProcess)  )       
      # paste0 (input$mtProcess)
    })  })
  
  
  observeEvent(input$CustomInputOptions, {
    print(input$CustomInputOptions)
    print(input$CustomInputOptions.condition)
    
    if (input$CustomInputOptions == "Insert a list of genes") {
      output$UI_INFO_EXPLORE = renderInfoBox ({
        infoBox ( "Explore",
                  "Manual List",
                  paste0 (input$CustomList),
                  icon  = (icon("list-ol")),
                  color = "yellow")   })    } 
    else 
      {output$UI_INFO_EXPLORE = renderInfoBox ({
        infoBox ("Explore",
                 "File",
                 # paste0 (input$UserGeneNamesFile),
                 icon = (icon("list-ol")),
                 color = "yellow")      })  }  })
  
  # exit button pressed
  observeEvent(input$ExitApplication, {
    quit(0)  })
  
  # Error dialouges
  # popupModal = function(failed = FALSE) {
  #   modalDialog(
  #     
  #     # textInput("txt", "Write something"),
  #     # if (failed)
  #     #   div(tags$b("You did not input anything", style = "color: red;")),
  #     # 
  #     # footer = tagList(
  #     #   modalButton("Cancel"),
  #     #   actionButton("ok", "OK")
  #     )
  #   )
  # }
  
  
  ###########################################################################################################
  # 0. Widgets customisation
  ###########################################################################################################
  # 0.1 Validate   
  # VerticalThresholdNumbers = reactive({
  #   validate(
  #     need(   is.numeric(input$VerticalThreshold), "Please input a positive number")  %then%
  #       need( !is.null(input$VerticalThreshold),   "Please input a positive number")  %then%
  #       need( !input$VerticalThreshold < 0,        "Please input a positive number")  %then%
  #       need( !input$VerticalThreshold > 1000,     "Your input beyond the max limit") %then%
  #       need( !is.na(input$VerticalThreshold),     "Please input a positive number")) })
  # 
  # output$value = renderPrint({ VerticalThresholdNumbers() })  
  
  # 0.2 Slider custom color | NOT SIGNIF. in red
  # SliderCustomColor = reactive({
  #   if(input$Signif <= 0.05){
  #     tags$style(HTML(".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {background: #48D1CC}"))
  #   }else {
  #     tags$style(HTML(".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {background: red}"))}
  # })
  # 
  # output$color0 = renderUI({ 
  #   SliderCustomColor()
  # })
  
  
  ###########################################################################################################
  # 0. INPUT - CONVERT
  ###########################################################################################################
  # 0.0 PARSE INPUT FILE provided by the user
  #  DatafileConvert = reactive({
  #    shiny::validate(
  #      need(input$FileToConvert, " "))
  #    read.csv(input$FileToConvert$datapath, header = T, sep = "\t", quote = "")})
  
  # 0.1 CONVERTER | fileInput(inputId  = "FileToConvert",  downloadButton(outputId = "DownloadDataConverted"   DTOutput( outputId = "ConvertedOriginalData"
  # ConvertedInput     = reactive({
  #   # Remove duplicates from gene symbol column
  #   infile = DatafileConvert() %>%
  #     # Add numeric extention to duplicated gene name
  #     mutate( GeneSymbol  = make.names( sapply(strsplit( as.character(DatafileConvert()$GeneSymbol),";"), `[`, 1) , unique = T) ) %>% 
  #     # Represent Gene Symbols that are not available as NA 
  #     mutate( GeneSymbol = gsub(".*NA.*", "NA" , GeneSymbol))
  #   return(infile)
  # })
  
  # 0.2 WRITE results into a file
  # output$DownloadDataConverted = downloadHandler(
  #   filename = function() {
  #     paste("ConvertedOriginalData", "_", format(Sys.Date(), "%d%b%Y"),  paste(".", "txt", sep="") , sep = "")},
  #   content = function(file) {
  #     write.table(ConvertedInput(), file, sep = "\t", row.names = FALSE, quote =F) })
  # 
  # 0.3 OUTPUT TABLE to webpage main space
  # output$ConvertedOriginalDataTable = renderDT({ 
  #   data.frame(ConvertedInput()) })
  
  
  ###########################################################################################################
  # 1. SUBSET DATA to SIGNIFICANT, PROCESSES
  ###########################################################################################################
  # 1.0 PARSE INPUT FILE provided by the user
  DataInputFile = reactive ({
    # USER INPUT FILE 
    tryCatch({
      print(input$UI_INPUT_FILE_SEPARATOR)
      if (!is.null(input$UI_INPUT_FILE_NAME)){
      req(input$UI_INPUT_FILE_NAME)   #require x to be available
        shiny::validate(need(input$UI_INPUT_FILE_SEPARATOR=="\t", "Please choose correct separator ..."))
        df = read.csv(input$UI_INPUT_FILE_NAME$datapath,
                      sep    = input$UI_INPUT_FILE_SEPARATOR,
                      header = T,
                      quote  = "") }
      else {return(NULL)}

      # IF CHECK FOR DUPLICATES BOX IS TICKED
      if (input$UI_INPUT_FILE_REMOVE_DUPLICATES==TRUE) {
        df = df %>%
          # Add numeric extention to duplicated gene name
          mutate( GeneSymbol  = make.names( sapply(strsplit( as.character(df$GeneSymbol),";"), `[`, 1) , unique = T) ) %>% 
          # Represent Gene Symbols that are not available as NA 
          mutate( GeneSymbol  = gsub(".*NA.*", "NA" , GeneSymbol)) }
      
      displayUIStatusMessage("File Loading Successful!", FALSE)
      output$UI_INPUT_FILE_RESULTS = renderDT(df)
      return(df)      },
      
      error = function(e) {
        # return a safeError if a parsing error occurs
        print(e)
        print(head(df))
        displayErrorMessage("File Loading Error in Data Input File!", "Please choose the correct file separator or review the documentation for the file input format", "")
        #displayErrorMessage("File Loading Error in Data Input File!", "Please review the documentation of this software to understand the file structure that is required", "")
        #displayUIErrorMessage("File Loading Error!", TRUE)
        return (NULL) }      )    })
  
  
  # 1.1 SUBSET input data to SIGNIF. threshold
  FilteredToSignif = reactive({
    signif = DataInputFile() %>%
      filter( AdjPValue < input$Signif,
              !is.na(AdjPValue)) 
    return(signif[,c(1,2,4,5,3)])  })
  
  
  # 1.1.0 OUTPUT SIGNIF. to TABs: "Explore Plot Values" AND to "Explore Mitochondrial Processes"
  output$SignifData = output$SignifData2 = renderDT({ FilteredToSignif() })
  
  # 1.2 COMBINE MT PROCESSES, such as MitoCarta+MitoXplorer AND Ribosomal
  MitoProcesses = reactive ({  
    
    if (input$OrganismSource == "Mouse" & is.null(DataInputFile()) ){
      return(NULL)}
    
    else if (input$OrganismSource == "Mouse" & !is.null(DataInputFile()) ){
      # prepare input data
      upperCase      = mutate( DataInputFile(), upcase = toupper(GeneSymbol) )
      mtfunct_in     = upperCase %>% filter(upcase %in% toupper(mm_processes_file$GeneName))
      processdata_in = merge.data.frame(mtfunct_in, mm_processes_file[,c(1,3)], by.x = "upcase", by.y = "GeneName")             #processdata_in[ , c(3,2,7,5,6,4)] 
      
      # add Ribosom and OXPHOs info | TOTAL-82
      mm_ribos_file_upper= mutate( mm_ribos_file, GeneName = toupper(GeneName) ) 
      mtfunct_rib        = upperCase %>% filter(upcase %in% toupper(mm_ribos_file_upper$GeneName))   # dim(mtfunct_rib)  # 58 6
      processdata_rib    = merge.data.frame(mtfunct_rib, mm_ribos_file_upper[,c(1,3)], by.x = "upcase", by.y = "GeneName")       #processdata_rib[1:5 , c(3,2,7,5,6,4)]  #   58  7
      
      # Add OXPHO and Ribsomal Processes 
      final_processes    = rbind(processdata_in, processdata_rib)
      return(final_processes[,c(2,3,5,6,4,7)]) }  # dim(final_processes) # 644   7
      #browser()
    
    else if (input$OrganismSource == "Human" & !is.null(DataInputFile()) ){
      #"Human data"
      upperCase2        = mutate( DataInputFile(), upcase = toupper(GeneSymbol) )
      
      # HS processes
      mtfunct_in_hs     = upperCase2 %>% filter(upcase %in% toupper(hs_processes_file$GeneName))
      processdata_in_hs = merge.data.frame(mtfunct_in_hs, hs_processes_file[,c(1,3)], by.x = "upcase", by.y = "GeneName")     #processdata_in_hs[ , c(3,2,7,5,6,4)] 
      
      # HS add Ribosomal | TOTAL-82
      hs_ribos_file_upper= mutate( hs_ribos_file, GeneName = toupper(GeneName) ) 
      hs_mtfunct_rib     = upperCase2 %>% filter(upcase %in% toupper(hs_ribos_file_upper$GeneName))
      hs_processdata_rib = merge.data.frame(hs_mtfunct_rib, hs_ribos_file_upper[,c(1,3)], by.x = "upcase", by.y = "GeneName") #hs_processdata_rib[1:5 , c(3,2,7,5,6,4)]  #   42  7
      
      # Add Ribsomal Processes to MitoCarta and mitoXplorer dataframe 
      hs_final_processes = rbind(processdata_in_hs, hs_processdata_rib)
      return(hs_final_processes[,c(2,3,5,6,4,7)])}
    
    else if (input$OrganismSource == "Human" & is.null(DataInputFile()) ){
      return(NULL)}
  })
  # 1.2.0 OUTPUT PROCESSES
  output$ProcessesData = renderDT({
    MitoProcesses() })
  
  
  ###########################################################################################################
  # 2. VISUALISE (Explore Plot Values Tab) | crosstalk btw table and plot
  ###########################################################################################################
  # 2.0 Create dataframe with color identifier for visualisation 
  DataFrameWithColors = reactive({
    tryCatch ({
      if (is.null(DataInputFile())){
        return(NULL) }

      else      {
        # 2.0.0 Initialise input varibales  
        inputdata  = DataInputFile()   #INfile
        refprocess = mm_processes_file
        
        # 2.0.1 Convert gene symbols in INPUT file to Upper case
        upperCaseDF   = mutate( inputdata, upcase = toupper(GeneSymbol) )   # 1388    6
        
        # 2.0.2 Convert gene symbols in REF file to Upper case 
        processInclud = upperCaseDF %>% filter(upcase %in% toupper(refprocess$GeneName))   #489   6
        
        # 2.0.3 Merge INPUT and REF file by gene symbol
        mergedataIncl = merge.data.frame(processInclud, refprocess[,c(1,3)], by.x = "upcase", by.y = "GeneName")   # 489   7 #  !!!!MAYBE gene IDS
        mergedataIncl = mergedataIncl[, c(2:7,1)]
        
        processExclud = upperCaseDF %>% filter(!upcase %in% toupper(refprocess$GeneName))   #899   6
        Process       = rep( 'NA', dim(processExclud)[1])
        excludAddedNA = cbind(processExclud, Process)[, c(1,2,3,4,5,7,6)]  # 899   7 
        
        combined         = rbind(mergedataIncl, excludAddedNA)      # 1388    7
        finaldfpopulated = combined[ , c(1,2,4,5,6,3)][order(combined$Process), ]    # complete input data
        
        # 2.0.4 Add column that contains information about signif-negative, signif-positiv, not signif + signif 
        logFC_threshold_pos =  as.numeric(input$VerticalThreshold)  # logFC_threshold_pos =  1
        logFC_threshold_neg = -logFC_threshold_pos                  # logFC_threshold_neg = -(logFC_threshold_pos) 
        signif_threshold    = input$Signif                          # signif_threshold    = 0.05
        
        # 2.0.5 1-SIGNIF. positive | prot_in$log2FC > neg_val & prot_in$AdjPValue < input$Signif))] = sign_pos_color
        positiv_signif = finaldfpopulated %>%
          filter( log2FC > logFC_threshold_pos & AdjPValue < signif_threshold) %>%
          mutate(CharValue = "red")
        
        # 2.0.6 2-SIGNIF. negative | prot_in$log2FC < -neg_val & prot_in$AdjPValue < input$Signif))] = sign_neg_color
        neg_signif = finaldfpopulated %>%
          filter( log2FC < logFC_threshold_neg & AdjPValue < signif_threshold) %>%
          mutate(CharValue = "blue")
        
        # 2.0.7 3-NOT SIGNIF between [-1;+1]
        notsignif1 = finaldfpopulated %>%
          filter( AdjPValue < signif_threshold & log2FC >= logFC_threshold_neg,
                  AdjPValue < signif_threshold & log2FC <= logFC_threshold_pos) %>%
          mutate(CharValue = "grey")
        
        # 2.0.8 4-NOT SIGNIF NA are excluded
        notsignif2 = finaldfpopulated %>% 
          filter( AdjPValue > signif_threshold) %>%
          mutate(CharValue = "grey")
        
        # 2.0.9 5-SUBSET to NA 
        na_data = finaldfpopulated %>% 
          filter(is.na(AdjPValue) | is.na(log2FC)) %>%
          mutate(CharValue = "grey2")
        
        # 2.1.0 6-COMBINE ALL filtered data
        df_color        = rbind(positiv_signif, neg_signif, notsignif1, notsignif2, na_data) 
        #browser()
        return(df_color[, c(1,2,3,4,6,7)])  # ID -	GeneSymbol -	log2FC -	AdjPValue -	Description -	CharValue
      }
    }, error = function(e) {
      displayErrorMessage("File Structure Error in DataFrameWithColors!", "Please refer to the manual.", "") })
    })

  
  
  # 2.1 CROSSTALK :)  # https://rstudio.github.io/crosstalk/shiny.html
  DataSharedWithColors = SharedData$new(DataFrameWithColors)
  
  
  
  # 2.2 REACTIVE VALUE, so plot can be saved 
  StorePlotForExplore = reactiveValues()   #@!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!7/05/
  
  
  # 2.3 VISUALISATION ("Explore Plot Values")
  ExplorePlotVolPplot = reactive ({ # observe({
    print("ExplorePlotVolPplot")
    
    if (is.null(DataInputFile())){
      return(NULL) }
    else {
      # 2.3.0 Initialised parameters
      sigval                = input$Signif
      logFC_threshold_pos   = as.numeric(input$VerticalThreshold)
      logFC_threshold_neg   = -logFC_threshold_pos
      numrows               = nrow(DataInputFile())
      yaxis = list(tickmode = "array", automargin = TRUE )
      tex   = list(family   = "sans serif", size  = 14, color = toRGB("#262626"))
      
      # 2.3.1 GGPLOT
      VolcanoPlotExplore           = ggplot(  data  = DataSharedWithColors , mapping = aes(x = log2FC, y = -log10(AdjPValue), text = GeneSymbol )) +
        geom_point( aes( color     = CharValue), show.legend = FALSE ) +
        scale_color_manual( values = c("#9fd8fb", "#cccccc", "white", "#ffcccc")) +   # #9fd8fb- blue #cccccc-grey #ffcccc- red  "" none
        geom_hline( yintercept     = -log10(sigval),      color = "#777777", size=0.15 ) +
        geom_vline( xintercept     = logFC_threshold_pos, color = "#777777", size=0.15 ) +
        geom_vline( xintercept     = logFC_threshold_neg, color = "#777777", size=0.15 ) +
        theme_classic() +
        scale_x_continuous(breaks = seq( round( min( DataInputFile()$log2FC, na.rm = T)), round( max( DataInputFile()$log2FC, na.rm = T)), 1) )+
        labs( title="Volcano Plot",
              caption= str_interp("Total = ${numrows} variables; Significant Threshold = ${sigval}; Vertical = +/-${as.integer(logFC_threshold_pos)} "))
      
      StorePlotForExplore$image0 = VolcanoPlotExplore
      
      # 2.3.2 PLOTLY
      VolcanoPlotExplore_plotly = ggplotly( VolcanoPlotExplore, tooltip = "text") %>%
        highlight(on = "plotly_click", off   = "plotly_doubleclick", dynamic = F, persistent = TRUE, color = "#777777",
                  opacityDim = 1, selected   = attrs_selected(mode = "text", textfont = tex, textposition = "top right",
                                                              marker = list(symbol = ".crossTalkKey"))) %>%
        layout(showlegend = FALSE, autosize = T, yaxis = yaxis) %>%
        config(toImageButtonOptions   = list(format = "svg", width = 800, height = 600, dpi= 1200),
               modeBarButtonsToRemove = c("lasso2d", "resetScale2d", "toggleSpikelines", "select2d", "pan2d"))
      #browser()
      return(VolcanoPlotExplore_plotly)} })
  
  # 2.3.3 OUT VISUAL  
  output$volcanoPlotNuclear = renderPlotly({ ExplorePlotVolPplot() })
  
  # https://shiny.rstudio.com/articles/plot-caching.html
  # output$volcanoPlotNuclear   = renderCachedPlot({
  #   ExplorePlotVolPplot()
  # },cacheKeyExpr = {list(input$Signif, input$VerticalThreshold, DataInputFile()) } )
  
  # 2.3.4 OUT Display Table
  output$InputOriginalData = renderDT({
    datatable(DataSharedWithColors)}, server = FALSE)
  
  
  ###########################################################################################################
  # 3. VISUALISE ("Explore Mitochondrial Processes") | crosstalk btw table and plot 
  ###########################################################################################################
  # 3.0 Input data 
  DataFrameForMitoProcess = reactive({
    tryCatch ({
      if (input$OrganismSource == "Mouse" & is.null(DataInputFile())) {
        return(NULL)}
      
      else if (input$OrganismSource == "Mouse" & !is.null(DataInputFile())) {
        # 3.1.0 Initialise input varibales  
        inputdata  = DataInputFile()       # testdata 1388 5 | ID GeneSymbol Description log2FC AdjPValue
        refprocess = mm_processes_file     # mm 1495 3       | GeneName Description Process
        ribosomal  = mm_ribos_file         # mm 82   3       | GeneName Description Process
        
        # 3.1.1 Convert gene symbols in INPUT file to Upper case
        upperCaseDF   = mutate( inputdata, upcase = toupper(GeneSymbol) )   # 1388    6
        
        # 3.1.2 Convert gene symbols in REF file to Upper case 
        processInclud = upperCaseDF %>% filter(upcase %in% toupper(refprocess$GeneName))   # 489   6
        
        # 3.1.3 Merge INPUT and REF file by gene symbol
        mergedataIncl = merge.data.frame(processInclud, refprocess[,c(1,3)], by.x = "upcase", by.y = "GeneName")   # 489   7 #  !!!!MAYBE gene IDS
        mergedataIncl = mergedataIncl[, c(2:7,1)]
        
        processExclud = upperCaseDF %>% filter(!upcase %in% toupper(refprocess$GeneName))   # 899   6
        Process       = rep( 'NA', dim(processExclud)[1])
        excludAddedNA = cbind(processExclud, Process)[, c(1,2,3,4,5,7,6)]  # 899   7 
        
        combined         = rbind(mergedataIncl, excludAddedNA)      # 1388    7
        finaldfpopulated = combined[ , c(1,2,4,5,6,3)][order(combined$Process), ]    # complete input data
        
        # 3.1.4 Add column that contains information about signif-negative, signif-positiv, not signif + signif 
        logFC_threshold_pos =  as.numeric(input$VerticalThreshold)  # logFC_threshold_pos =  1
        logFC_threshold_neg = -logFC_threshold_pos                  # logFC_threshold_neg = -(logFC_threshold_pos) 
        signif_threshold    = input$Signif                          # signif_threshold    = 0.05
        
        # 3.1.5 1-SIGNIF. positive | prot_in$log2FC > neg_val & prot_in$AdjPValue < input$Signif))] = sign_pos_color
        positiv_signif = finaldfpopulated %>%
          filter( log2FC > logFC_threshold_pos & AdjPValue < signif_threshold) %>%
          mutate(CharValue = "red")
        
        # 3.1.6 2-SIGNIF. negative | prot_in$log2FC < -neg_val & prot_in$AdjPValue < input$Signif))] = sign_neg_color
        neg_signif = finaldfpopulated %>%
          filter( log2FC < logFC_threshold_neg & AdjPValue < signif_threshold) %>%
          mutate(CharValue = "blue")
        
        # 3.1.7 3-NOT SIGNIF between [-1;+1]
        notsignif1 = finaldfpopulated %>%
          filter( AdjPValue < signif_threshold & log2FC >= logFC_threshold_neg,
                  AdjPValue < signif_threshold & log2FC <= logFC_threshold_pos) %>%
          mutate(CharValue = "grey")
        
        # 3.1.8 4-NOT SIGNIF NA are excluded
        notsignif2 = finaldfpopulated %>% 
          filter( AdjPValue > signif_threshold) %>%
          mutate(CharValue = "grey")
        
        # 3.1.9 5-SUBSET to NA 
        na_data = finaldfpopulated %>% 
          filter(is.na(AdjPValue) | is.na(log2FC)) %>%
          mutate(CharValue = "grey2")
        
        # 3.2.0 Add Ribosomal
        upperCase_ribos   = mutate( ribosomal, GeneName = toupper(GeneName))  
        subsetData_ribos  = upperCaseDF %>% filter(upcase %in% upperCase_ribos$GeneName)  # dim(58  x 6)
        merge_ribos       = merge.data.frame(subsetData_ribos, upperCase_ribos[,c(1,3)], by.x = "upcase", by.y = "GeneName") # 58  x 7
        combine_oxpho_rib = merge_ribos   # 158   7 | rbind(merge_oxpho, merge_ribos) 
        
        # 3.2.1 Sign_pos_color
        positiv_signif_oxpho_rib = combine_oxpho_rib %>%
          filter( log2FC > logFC_threshold_pos & AdjPValue < signif_threshold) %>%
          mutate(CharValue = "red")   # dim = 17  8
        
        # 3.2.2 Sign_neg_color
        neg_signif_oxpho_rib = combine_oxpho_rib %>%
          filter( log2FC < logFC_threshold_neg & AdjPValue < signif_threshold) %>%
          mutate(CharValue = "blue")  # dim 40  8
        
        # 3.2.3 NOT SIGNIF between [-1;+1]
        notsignif1_oxpho_rib = combine_oxpho_rib %>%
          filter( AdjPValue < signif_threshold & log2FC >= logFC_threshold_neg,
                  AdjPValue < signif_threshold & log2FC <= logFC_threshold_pos) %>%
          mutate(CharValue = "grey") # dim = 35  8
        
        # 3.2.4 NOT SIGNIF NA are excluded
        notsignif2_oxpho_rib = combine_oxpho_rib %>% 
          filter( AdjPValue > signif_threshold) %>%
          mutate(CharValue   = "grey")  # dim = 61  8
        
        # 3.2.5 NAs 
        na_data_oxpho_rib  = combine_oxpho_rib %>% 
          filter(is.na(AdjPValue) | is.na(log2FC)) %>%
          mutate(CharValue = "grey2")  # dim = 5  8
        
        df_color_oxpho_rib = rbind(positiv_signif_oxpho_rib, neg_signif_oxpho_rib, notsignif1_oxpho_rib, notsignif2_oxpho_rib, na_data_oxpho_rib) # dim = 158  8
        df_color_oxpho_rib = df_color_oxpho_rib[, c(2,3,5,6,4,7,8)]
        
        # 3.2.6 COMBINE ALL filtered data
        df_color = rbind(positiv_signif, neg_signif, notsignif1, notsignif2, na_data) 
        df_color = df_color[, c(1,2,3,4,6,5,7)]  # Note: need process column for crosstalking with plot | 1388    7
        
        all_processes_mm = rbind(df_color_oxpho_rib, df_color)
        return(all_processes_mm) }
        # browser()         }
   
      else if (input$OrganismSource == "Human" & is.null(DataInputFile())){
        return(NULL)}
      
      else {
        # 3.3.0 Initialise input varibales  
        inputdata     = DataInputFile()   # testdata 1388 5 | ID GeneSymbol Description log2FC AdjPValue
        refprocess_hs = hs_processes_file    # mm 1495 3       | GeneName Description Process
        ribosomal_hs  = hs_ribos_file        # mm 82   3       | GeneName Description Process ribosomal
        
        # 3.3.1 Convert gene symbols in INPUT file to Upper case
        upperCaseDF2   = mutate( inputdata, upcase = toupper(GeneSymbol) )   # 1388    6
        
        # 3.3.2 Convert gene symbols in REF file to Upper case 
        processInclud_hs = upperCaseDF2 %>% filter(upcase %in% toupper(refprocess_hs$GeneName))   # 489   6
        
        # 3.3.4 Merge INPUT and REF file by gene symbol
        mergedataIncl_hs = merge.data.frame(processInclud_hs, refprocess_hs[,c(1,3)], by.x = "upcase", by.y = "GeneName")   # 489   7 #  !!!!MAYBE gene IDS
        mergedataIncl_hs = mergedataIncl_hs[, c(2:7,1)]
        
        processExcludl_hs = upperCaseDF2 %>% filter(!upcase %in% toupper(refprocess_hs$GeneName))   # 899   6
        Process           = rep( 'NA', dim(processExcludl_hs)[1])
        excludAddedNA     = cbind(processExcludl_hs, Process)[, c(1,2,3,4,5,7,6)]  # 899   7 
        
        combined_hs         = rbind(mergedataIncl_hs, excludAddedNA)      # 1388    7
        finaldfpopulated_hs = combined_hs[ , c(1,2,4,5,6,3)][order(combined_hs$Process), ]    # complete input data
        
        # 3.3.5 Add column that contains information about signif-negative, signif-positiv, not signif + signif 
        logFC_threshold_pos_hs =  as.numeric(input$VerticalThreshold)     # logFC_threshold_pos_hs =  1
        logFC_threshold_neg_hs = -logFC_threshold_pos_hs                  # logFC_threshold_neg_hs = -(logFC_threshold_pos_hs) 
        signif_threshold       = input$Signif                                # signif_threshold    = 0.05
        
        # 3.3.6 SIGNIF. positive | prot_in$log2FC > neg_val & prot_in$AdjPValue < input$Signif))] = sign_pos_color
        positiv_signif_hs = finaldfpopulated_hs %>%
          filter( log2FC > logFC_threshold_pos_hs & AdjPValue < signif_threshold) %>%
          mutate(CharValue = "red")
        
        # 3.3.7 SIGNIF. negative | prot_in$log2FC < -neg_val & prot_in$AdjPValue < input$Signif))] = sign_neg_color
        neg_signif_hs = finaldfpopulated_hs %>%
          filter( log2FC < logFC_threshold_neg_hs & AdjPValue < signif_threshold) %>%
          mutate(CharValue = "blue")
        
        # 3.3.8 NOT SIGNIF between [-1;+1]
        notsignif1_hs = finaldfpopulated_hs %>%
          filter( AdjPValue < signif_threshold & log2FC >= logFC_threshold_neg_hs,
                  AdjPValue < signif_threshold & log2FC <= logFC_threshold_pos_hs) %>%
          mutate(CharValue = "grey")
        
        # 3.3.9 NOT SIGNIF NA are excluded
        notsignif2_hs = finaldfpopulated_hs %>% 
          filter( AdjPValue > signif_threshold) %>%
          mutate(CharValue = "grey")
        
        # 3.4.0 -SUBSET to NA 
        na_data_hs = finaldfpopulated_hs %>% 
          filter(is.na(AdjPValue) | is.na(log2FC)) %>%
          mutate(CharValue = "grey2")
        
        # 3.4.1 Add OXPHOS df and Ribosomal
        upperCase_ribos_hs   = mutate( ribosomal_hs, GeneName = toupper(GeneName))  
        subsetData_ribos_hs  = upperCaseDF2 %>% filter(upcase %in% upperCase_ribos_hs$GeneName)  # dim(58  x 6)
        merge_ribos_hs       = merge.data.frame(subsetData_ribos_hs, upperCase_ribos_hs[,c(1,3)], by.x = "upcase", by.y = "GeneName") # 58  x 7
        combine_oxpho_rib_hs = merge_ribos_hs   # 158   7  combine_oxpho_rib_hs = rbind(merge_oxpho_hs, merge_ribos_hs)
        
        # 3.4.2 sign_pos_color
        positiv_signif_oxpho_rib_hs = combine_oxpho_rib_hs %>%
          filter( log2FC > logFC_threshold_pos_hs & AdjPValue < signif_threshold) %>%
          mutate(CharValue = "red")   # dim = 17  8
        
        # 3.4.3 sign_neg_color
        neg_signif_oxpho_rib_hs = combine_oxpho_rib_hs %>%
          filter( log2FC < logFC_threshold_neg_hs & AdjPValue < signif_threshold) %>%
          mutate(CharValue = "blue")  # dim 40  8
        
        # 3.4.4 NOT SIGNIF between [-1;+1]
        notsignif1_oxpho_rib_hs = combine_oxpho_rib_hs %>%
          filter( AdjPValue < signif_threshold & log2FC >= logFC_threshold_neg_hs,
                  AdjPValue < signif_threshold & log2FC <= logFC_threshold_pos_hs) %>%
          mutate(CharValue = "grey") # dim = 35  8
        
        # 3.4.5 NOT SIGNIF NA are excluded
        notsignif2_oxpho_rib_hs = combine_oxpho_rib_hs %>% 
          filter( AdjPValue > signif_threshold) %>%
          mutate(CharValue = "grey")  # dim = 61  8
        
        # 3.4.6 NAs 
        na_data_oxpho_rib_hs = combine_oxpho_rib_hs %>% 
          filter(is.na(AdjPValue) | is.na(log2FC)) %>%
          mutate(CharValue = "grey2")  # dim = 5  8
        
        df_color_oxpho_rib_hs = rbind(positiv_signif_oxpho_rib_hs, neg_signif_oxpho_rib_hs, notsignif1_oxpho_rib_hs, notsignif2_oxpho_rib_hs, na_data_oxpho_rib_hs) # dim = 158  8
        df_color_oxpho_rib_hs = df_color_oxpho_rib_hs[, c(2,3,5,6,4,7,8)]
        
        # 3.4.7 COMBINE ALL filtered data
        df_color_hs = rbind(positiv_signif_hs, neg_signif_hs, notsignif1_hs, notsignif2_hs, na_data_hs) 
        df_color_hs = df_color_hs[, c(1,2,3,4,6,5,7)]  # Note: need process column for crosstalking with plot | 1388    7
        
        all_processes_hs = rbind(df_color_oxpho_rib_hs, df_color_hs)
        
        return(all_processes_hs)}
      }, error = function (e) {
          print(e)
          print(head(df))
          displayErrorMessage("Source File Error!", "Please read the documentation", "")})
    })
  
  
  # 3.5 Get all mito genes present in data 
  AllMitoProcesses = reactive({     # mito_processes = observe({
    if (input$OrganismSource == "Mouse"){
      # 3.5.0 Info to highlight all mt genes
      refprocess = mm_processes_file    # mm 1495 3       | GeneName Description Process
      ribosomal  = mm_ribos_file        # mm 82   3       | GeneName Description Process
      mm_process = DataFrameForMitoProcess()[ toupper(as.character(DataFrameForMitoProcess()$GeneSymbol)) %in% toupper(as.character(refprocess$GeneName)),  ] # 639   7
      mm_ribos   = DataFrameForMitoProcess()[ toupper(as.character(DataFrameForMitoProcess()$GeneSymbol)) %in%  toupper(ribosomal$GeneName),  ]               # 119   7
      mm_mt      = rbind(mm_process, mm_ribos) # 951   4   | #rbind(mm_process, mm_oxpho, mm_ribos)
      mm_unique_mt_genes  = mm_mt[ !duplicated(mm_mt$GeneSymbol), ]             # 485   7
      return(mm_unique_mt_genes)
      #browser()
    }
    else if (input$OrganismSource == "Human"){
      # 3.5.1 Info to highlight all mt genes in the plot uses reactivevalues function
      refprocess_hs = hs_processes_file  # mm 1495 3       | GeneName Description Process
      ribosomal_hs  = hs_ribos_file      # mm 82   3       | GeneName Description Process ribosomal
      hs_process    = DataFrameForMitoProcess()[ toupper(as.character(DataFrameForMitoProcess()$GeneSymbol)) %in% toupper(as.character(refprocess_hs$GeneName)),  ] # 639   7
      hs_ribos      = DataFrameForMitoProcess()[ toupper(as.character(DataFrameForMitoProcess()$GeneSymbol)) %in% toupper(ribosomal_hs$GeneName),  ]                # 119   7
      hs_mt         = rbind(hs_process, hs_ribos)              # 951   4   hs_mt      = rbind(hs_process, hs_oxpho, hs_ribos)
      hs_unique_mt_genes  = hs_mt[ !duplicated(hs_mt$GeneSymbol), ]   # 485   7
      return(hs_unique_mt_genes)  
    } 
  })
  
  
  # 3.6 CROSSTALK 
  DataSharedForMitoProcess = SharedData$new(DataFrameForMitoProcess)
  AllSharedMitoProcesses   = SharedData$new(AllMitoProcesses)
  
  # 3.6.0 OUT Display Table
  output$InputOriginalData2 = renderDT({
    datatable( DataSharedForMitoProcess )}, server = FALSE) 
  
  # 3.6.1 OUT VISUAL
  ExploreMitoVolcanoStore = reactiveValues()
  
  
  # 3.7 Highlight all MT genes/proteins OR only specific MT function | persistent 
  # Subset dataset to selected process, Create condition to highlight selected process
  # if padjas < 0.05 and logFC > 1 darker red  | plotCol ffcccc  | ff2f2f
  # if padjas < 0.05 and logFC =1 darker blue | plotCol 87CEFA  | 087fc8
  # else darker grey                           | plotCol cccccc  | 6a6a6a
  
  HighlightProcess = reactive({       #HighlightProcess = observe({ 
    
    if (is.null(DataInputFile())){
      return(NULL) }
    
    else {
      # 3.7.0 Initialise thresholds
      sigval                = input$Signif
      logFC_threshold_pos   = as.numeric(input$VerticalThreshold)
      logFC_threshold_neg   = -logFC_threshold_pos
      numrows               = nrow(DataInputFile())
      yaxis = list(tickmode = "array", automargin = TRUE )
      tex   = list(family   = "sans serif", 
                   size     = 14, 
                   color    = toRGB("#262626"))
      
      
      # 3.7.1 "Mouse" and "Show All Mitochondrial Genes"
      if (input$MtProcess == "Show All Mitochondrial Genes" & input$OrganismSource == "Mouse"){
        # a- data frame with colors for MT mm
        mm_colors_to_highlight_mt_all = AllSharedMitoProcesses$data() %>%  
          mutate(CharValue  = case_when(AdjPValue < input$Signif & log2FC > as.numeric(input$VerticalThreshold)      ~ "#ff2f2f",    # red
                                        AdjPValue < input$Signif & log2FC < (-1)*as.numeric(input$VerticalThreshold) ~ "#087fc8",    # blue
                                        AdjPValue > input$Signif & log2FC > (-1)*as.numeric(input$VerticalThreshold) | log2FC < as.numeric(input$VerticalThreshold) ~ "#6a6a6a",
                                        AdjPValue > input$Signif  ~ "#6a6a6a" ))   # 485  7
        # b- Crosstalking / share
        mm_all_data_shared = SharedData$new(mm_colors_to_highlight_mt_all)
        
        # c- GGPLOT 
        VolcanoPlot_mm_allmito = ggplot(  data  = DataSharedForMitoProcess, mapping = aes(x = log2FC, y = -log10(AdjPValue), text = GeneSymbol)) +
          geom_point( aes( color = as.factor(CharValue) ), show.legend = FALSE ) +
          scale_color_manual( values = c("#9fd8fb", "#cccccc", "white", "#ffcccc")) +
          geom_hline( yintercept     = -log10(sigval),      color = "#777777", size=0.15 ) +
          geom_vline( xintercept     = logFC_threshold_pos, color = "#777777", size=0.15 ) +
          geom_vline( xintercept     = logFC_threshold_neg, color = "#777777", size=0.15 ) +
          geom_point(data  = mm_all_data_shared, aes(x = log2FC, y = -log10(AdjPValue)),
                     color = mm_all_data_shared$origData()[,7], size = 1.5) +
          theme_classic() +
          scale_x_continuous(breaks = seq( round( min( DataInputFile()$log2FC, na.rm = T)), round( max( DataInputFile()$log2FC, na.rm = T)), 1) )+
          labs( title ="Volcano Plot",
                caption = str_interp("Total = ${numrows} variables; Significant Threshold = ${sigval}; Vertical = +/-${as.integer(logFC_threshold_pos)} "))
        
        # d- PLOTLY 
        VolcanoPlot_mm_allmito_plotly = ggplotly( VolcanoPlot_mm_allmito, tooltip = "text") %>%
          highlight(on = "plotly_click", off = "plotly_doubleclick", persistent = F,
                    opacityDim = 1, selected   = attrs_selected(mode   = "text", textfont = tex, textposition = "top right",
                                                                marker = list(symbol = ".crossTalkKey"))) %>%
          layout(showlegend = FALSE,
                 autosize   = T,
                 yaxis      = yaxis ) %>%  
          config(toImageButtonOptions   = list(format = "svg", width = 800, height = 600, dpi= 1200),
                 modeBarButtonsToRemove = c("lasso2d", "resetScale2d", "toggleSpikelines", "select2d", "pan2d"))
        return(VolcanoPlot_mm_allmito_plotly) }
      
      # 3.7.2 "Human" and "Show All Mitochondrial Genes"
      else if (input$MtProcess == "Show All Mitochondrial Genes" & input$OrganismSource == "Human"){
        # a- data frame with colors for MT human
        hs_colors_to_highlight_mt_all = AllSharedMitoProcesses$data() %>%  
          mutate(CharValue  = case_when(AdjPValue < input$Signif & log2FC > as.numeric(input$VerticalThreshold)      ~ "#ff2f2f",    # red
                                        AdjPValue < input$Signif & log2FC < (-1)*as.numeric(input$VerticalThreshold) ~ "#087fc8",    # blue
                                        AdjPValue > input$Signif & log2FC > (-1)*as.numeric(input$VerticalThreshold) | log2FC < as.numeric(input$VerticalThreshold) ~ "#6a6a6a",
                                        AdjPValue > input$Signif  ~ "#6a6a6a" ))   # 467   7
        # b- Crosstalking / share
        hs_all_data_shared = SharedData$new(hs_colors_to_highlight_mt_all)
        
        # c- GGPLOT 
        VolcanoPlot_hs_allmito   = ggplot(  data  = DataSharedForMitoProcess, mapping = aes(x = log2FC, y = -log10(AdjPValue), text = GeneSymbol)) +
          geom_point( aes( color = as.factor(CharValue) ), show.legend = FALSE ) +
          scale_color_manual( values = c("#9fd8fb", "#cccccc", "white", "#ffcccc")) +
          geom_hline( yintercept     = -log10(sigval),      color = "#777777", size=0.15 ) +
          geom_vline( xintercept     = logFC_threshold_pos, color = "#777777", size=0.15 ) +
          geom_vline( xintercept     = logFC_threshold_neg, color = "#777777", size=0.15 ) +
          geom_point(data  = hs_all_data_shared, aes(x = log2FC, y = -log10(AdjPValue)),
                     color = hs_all_data_shared$origData()[,7], size = 1.5) +
          theme_classic() +
          scale_x_continuous(breaks = seq( round( min( DataInputFile()$log2FC, na.rm = T)), round( max( DataInputFile()$log2FC, na.rm = T)), 1) )+
          labs( title ="Volcano Plot",
                caption = str_interp("Total = ${numrows} variables; Significant Threshold = ${sigval}; Vertical = +/-${as.integer(logFC_threshold_pos)} "))
        
        # d- PLOTLY | Plotly webpage apperance
        VolcanoPlot_hs_allmito_plotly = ggplotly( VolcanoPlot_hs_allmito, tooltip = "text") %>%
          highlight(on = "plotly_click", off = "plotly_doubleclick", persistent = F,
                    opacityDim = 1, selected   = attrs_selected(mode   = "text", textfont = tex, textposition = "top right",
                                                                marker = list(symbol = ".crossTalkKey"))) %>%
          layout(showlegend = FALSE,
                 autosize   = F,
                 yaxis      = yaxis ) %>%  
          config(toImageButtonOptions   = list(format = "svg", width = 800, height = 600, dpi= 1200),
                 modeBarButtonsToRemove = c("lasso2d", "resetScale2d", "toggleSpikelines", "select2d", "pan2d"))
        return(VolcanoPlot_hs_allmito_plotly) 
        # browser()
      }
    
    
      # 3.7.3 "Mouse" and  seleceted process of interest 
      else if (!input$MtProcess == "Show All Mitochondrial Genes" & input$OrganismSource == "Mouse"){
        # a- data frame with colors for MT processes mouse
        colors_to_highlight_process = DataSharedForMitoProcess$data() %>%
          filter( Process   == input$MtProcess)     %>%
          mutate(CharValue  = case_when(AdjPValue < input$Signif & log2FC > as.numeric(input$VerticalThreshold)      ~ "#ff2f2f",    # red
                                        AdjPValue < input$Signif & log2FC < (-1)*as.numeric(input$VerticalThreshold) ~ "#087fc8",    # blue
                                        AdjPValue > input$Signif & log2FC > (-1)*as.numeric(input$VerticalThreshold) | log2FC < as.numeric(input$VerticalThreshold) ~ "#6a6a6a",
                                        AdjPValue > input$Signif  ~ "#6a6a6a" ))
        # b- crosstalking sharing dataframe with colors
        data_shared_mm_process = SharedData$new(colors_to_highlight_process)  #works but only for highlighted dots
        
        # c- GGPLOT | Volcano plot
        VolcanoPlot_mm_process = ggplot(  data  = DataSharedForMitoProcess, mapping = aes(x = log2FC, y = -log10(AdjPValue), text = GeneSymbol)) +
          geom_point( aes( color = as.factor(CharValue) ), show.legend = FALSE ) +
          scale_color_manual( values = c("#9fd8fb", "#cccccc", "white", "#ffcccc")) +
          geom_hline( yintercept     = -log10(sigval),      color = "#777777", size=0.15 ) +
          geom_vline( xintercept     = logFC_threshold_pos, color = "#777777", size=0.15 ) +
          geom_vline( xintercept     = logFC_threshold_neg, color = "#777777", size=0.15 ) +
          geom_point(data  = data_shared_mm_process, aes(x = log2FC, y = -log10(AdjPValue)),
                     color = data_shared_mm_process$origData()[,7], size = 1.5) +
          theme_classic() +
          scale_x_continuous(breaks = seq( round( min( DataInputFile()$log2FC, na.rm = T)), round( max( DataInputFile()$log2FC, na.rm = T)), 1) )+
          labs( title ="Volcano Plot",
                caption = str_interp("Total = ${numrows} variables; Significant Threshold = ${sigval}; Vertical = +/-${as.integer(logFC_threshold_pos)} "))
        
        ExploreMitoVolcanoStore$image1 = VolcanoPlot_mm_process
        
        # d- PLOTLY | Plotly webpage apperance
        VolcanoPlot_mm_process_plotly = ggplotly( VolcanoPlot_mm_process, tooltip = "text") %>%
          highlight(on = "plotly_click", off = "plotly_doubleclick", persistent = F,
                    opacityDim = 1, selected   = attrs_selected(mode   = "text", textfont = tex, textposition = "top right",
                                                                marker = list(symbol = ".crossTalkKey"))) %>%
          layout(showlegend = FALSE,
                 autosize   = T,
                 yaxis      = yaxis ) %>%  
          config(toImageButtonOptions   = list(format = "svg", width = 800, height = 600, dpi= 1200),
                 modeBarButtonsToRemove = c("lasso2d", "resetScale2d", "toggleSpikelines", "select2d", "pan2d"))
        

        return(VolcanoPlot_mm_process_plotly)    
        # browser()
      }
    
    
      # 3.7.4 "Human" and  seleceted process of interest 
      else if (!input$MtProcess == "Show All Mitochondrial Genes" & input$OrganismSource == "Human"){
        # a- data frame with colors for MT processes mouse
        colors_to_highlight_hs_process = DataSharedForMitoProcess$data() %>%
          filter( Process   == input$MtProcess)     %>%
          mutate(CharValue  = case_when(AdjPValue < input$Signif & log2FC > as.numeric(input$VerticalThreshold)      ~ "#ff2f2f",    # red
                                        AdjPValue < input$Signif & log2FC < (-1)*as.numeric(input$VerticalThreshold) ~ "#087fc8",    # blue
                                        AdjPValue > input$Signif & log2FC > (-1)*as.numeric(input$VerticalThreshold) | log2FC < as.numeric(input$VerticalThreshold) ~ "#6a6a6a",
                                        AdjPValue > input$Signif  ~ "#6a6a6a" ))
        # b- crosstalking sharing dataframe with colors
        data_shared_hs_process = SharedData$new(colors_to_highlight_hs_process)  #works but only for highlighted dots
        
        # c- GGPLOT | Volcano plot
        VolcanoPlot_hs_process = ggplot(  data  = DataSharedForMitoProcess, mapping = aes(x = log2FC, y = -log10(AdjPValue), text = GeneSymbol)) +
          geom_point( aes( color = as.factor(CharValue) ), show.legend = FALSE ) +
          scale_color_manual( values = c("#9fd8fb", "#cccccc", "white", "#ffcccc")) +
          geom_hline( yintercept     = -log10(sigval),      color = "#777777", size=0.15 ) +
          geom_vline( xintercept     = logFC_threshold_pos, color = "#777777", size=0.15 ) +
          geom_vline( xintercept     = logFC_threshold_neg, color = "#777777", size=0.15 ) +
          geom_point(data  = data_shared_hs_process, aes(x = log2FC, y = -log10(AdjPValue)),
                     color = data_shared_hs_process$origData()[,7], size = 1.5) +
          theme_classic() +
          scale_x_continuous(breaks = seq( round( min( DataInputFile()$log2FC, na.rm = T)), round( max( DataInputFile()$log2FC, na.rm = T)), 1) )+
          labs( title ="Volcano Plot",
                caption = str_interp("Total = ${numrows} variables; Significant Threshold = ${sigval}; Vertical = +/-${as.integer(logFC_threshold_pos)} "))
        
        ExploreMitoVolcanoStore$image1 = VolcanoPlot_hs_process
        
        # d- PLOTLY | Plotly webpage apperance
        VolcanoPlot_hs_process_plotly = ggplotly( VolcanoPlot_hs_process, tooltip = "text") %>%
          highlight(on = "plotly_click", off = "plotly_doubleclick", persistent = TRUE,
                    opacityDim = 1, selected   = attrs_selected(mode   = "text", textfont = tex, textposition = "top right",
                                                                marker = list(symbol = ".crossTalkKey"))) %>%
          layout(showlegend = FALSE,
                 autosize   = F,
                 yaxis      = yaxis ) %>%  # hoverlabel=list(bgcolor="white")
          config(toImageButtonOptions   = list(format = "svg", width = 800, height = 600, dpi= 1200),
                 modeBarButtonsToRemove = c("lasso2d", "resetScale2d", "toggleSpikelines", "select2d", "pan2d"))
        return(VolcanoPlot_hs_process_plotly)     
      }
    }
    })
  
  # 3.7.5 OUTPUT visualisation
  output$VolcanoPlotOutExploreMito = renderPlotly({
    HighlightProcess()  })
  
  
  ###########################################################################################################
  # 4. VISUALISE (Custom Tab) | visualise labels of genes of interest 
  ###########################################################################################################
  # 4.0 Reactive values for plot
  CustomVolcanoPlotStore = reactiveValues()
  
  # 4.0.0 User input file with custom list
  CustomDataFile = reactive({
    inFile       = input$UserGeneNamesFile
    
    if (is.null(inFile)){
      return(NULL) }
    
    else{
      read.table(input$UserGeneNamesFile$datapath, header = T, sep = "\t", quote = "") }  })
  
  
  # 4.1 PLOT
  CustomListOfInterest = reactive({    # CustomListOfInterest = observe({
    
    if (is.null(DataInputFile())){
      return(NULL) }
    
    else{
      # 4.1.0 Thresholds
      sigval_cust                = input$Signif
      logFC_threshold_pos_cust   = as.numeric(input$VerticalThreshold)
      logFC_threshold_neg_cust   = -logFC_threshold_pos_cust
      numrows_cust               = nrow(DataInputFile())
      tex   = list(family   = "sans serif", size  = 14, color = toRGB("#262626"))
      yaxis = list(tickmode = "array", automargin = TRUE )
      
      
      # 4.1.1 - UPLOAD own file with list of genes, one gene per row
      if (!is.null(CustomDataFile())){
        # a- Custom data with uploaded custom file
        inputfile_customdata           = toupper(CustomDataFile()[,1])
        
        # b- Highlight color for custom file input
        col_to_highlight_infile_custom = DataFrameWithColors()  %>%
          mutate( GeneSymbol     = toupper(GeneSymbol)) %>%
          filter( GeneSymbol %in% inputfile_customdata) %>%
          mutate( CharValue  = case_when(AdjPValue < input$Signif & log2FC > as.numeric(input$VerticalThreshold)      ~ "#ff2f2f",    # red
                                         AdjPValue < input$Signif & log2FC < (-1)*as.numeric(input$VerticalThreshold) ~ "#087fc8",    # blue
                                         AdjPValue > input$Signif & log2FC > (-1)*as.numeric(input$VerticalThreshold) | log2FC < as.numeric(input$VerticalThreshold) ~ "#6a6a6a",
                                         AdjPValue > input$Signif  ~ "#6a6a6a" ))
        # c- GGPLOT
        volcanoplotInputFileCustom = ggplot(data= DataFrameWithColors(), mapping = aes(x = log2FC, y = -log10(AdjPValue), text = GeneSymbol)) +
          geom_point( aes( color     = as.factor(CharValue) ), show.legend = FALSE ) +
          scale_color_manual( values = c("#9fd8fb", "#cccccc", "white", "#ffcccc"))  +
          geom_hline( yintercept     = -log10(sigval_cust),      color = "#777777", size = 0.15 ) +
          geom_vline( xintercept     = logFC_threshold_pos_cust, color = "#777777", size = 0.15 ) +
          geom_vline( xintercept     = logFC_threshold_neg_cust, color = "#777777", size = 0.15 ) +
          geom_point(data = col_to_highlight_infile_custom, aes(x = log2FC, y = -log10(AdjPValue)),
                     color= col_to_highlight_infile_custom$CharValue, size = 1.7) +
          geom_text(data    = col_to_highlight_infile_custom,
                    aes(x   = log2FC, y  = -log10(AdjPValue), label = stringr::str_to_title(GeneSymbol)),
                    nudge_x = 0, nudge_y = 0.18,
                    size    = 3.5, family  = "sans serif") +
          theme_classic() +
          scale_x_continuous(breaks = seq( round( min( DataInputFile()$log2FC, na.rm = T)), round( max( DataInputFile()$log2FC, na.rm = T)), 1) )+
          labs( title ="Volcano Plot",
                caption = str_interp("Total = ${numrows_cust} variables; Significant Threshold = ${sigval_cust}; Vertical = +/-${as.integer(logFC_threshold_pos_cust)} "))
        
        CustomVolcanoPlotStore$image2 = volcanoplotInputFileCustom
        
        # d- PLOTLY
        volcanoplotInputFileCustom_plotly = ggplotly( volcanoplotInputFileCustom, tooltip = "text") %>%
          layout(showlegend = FALSE,
                 autosize   = F,
                 yaxis      = yaxis ) %>%
          config(toImageButtonOptions   = list(format = "svg", width = 800, height = 600, dpi= 1200),
                 modeBarButtonsToRemove = c("lasso2d", "resetScale2d", "toggleSpikelines", "select2d", "pan2d"))
        return(volcanoplotInputFileCustom_plotly)    }
      
      # 4.1.2 INSERT own list of genes 
      else if (!is.null(input$CustomList)){
        # a- List of custom gene names
        # input_text            = input$CustomList
        
        # b- Subset orginal data to custom list
        convert_to_vector_customlist = toupper(unlist(strsplit(input$CustomList, " ")))
        col_to_highlight  = DataFrameWithColors() %>%
          mutate( GeneSymbol = toupper(GeneSymbol)) %>%
          filter( GeneSymbol %in% convert_to_vector_customlist) %>%
          mutate( CharValue  = case_when(AdjPValue < input$Signif & log2FC > as.numeric(input$VerticalThreshold)      ~ "#ff2f2f",    # red
                                         AdjPValue < input$Signif & log2FC < (-1)*as.numeric(input$VerticalThreshold) ~ "#087fc8",    # blue
                                         AdjPValue > input$Signif & log2FC > (-1)*as.numeric(input$VerticalThreshold) | log2FC < as.numeric(input$VerticalThreshold) ~ "#6a6a6a",
                                         AdjPValue > input$Signif  ~ "#6a6a6a" ))
        # c- Visualise custom genes
        volcanoplotcustom = ggplot(data= DataFrameWithColors(), mapping = aes(x = log2FC, y = -log10(AdjPValue), text = GeneSymbol)) +
          geom_point( aes( color     = as.factor(CharValue) ), show.legend = FALSE ) +
          scale_color_manual( values = c("#9fd8fb", "#cccccc", "white", "#ffcccc"))  +
          geom_hline( yintercept     = -log10(sigval_cust),      color = "#777777", size = 0.15 ) +
          geom_vline( xintercept     = logFC_threshold_pos_cust, color = "#777777", size = 0.15 ) +
          geom_vline( xintercept     = logFC_threshold_neg_cust, color = "#777777", size = 0.15 ) +
          geom_point(data = col_to_highlight, aes(x = log2FC, y = -log10(AdjPValue)),
                     color= col_to_highlight$CharValue, size = 1.7) +
          geom_text(data    = col_to_highlight,
                    aes(x   = log2FC, y  = -log10(AdjPValue), label = stringr::str_to_title(GeneSymbol)),
                    nudge_x = 0, nudge_y = 0.18,
                    size    = 3.5, family  = "sans serif") +
          theme_classic() +
          scale_x_continuous(breaks = seq( round( min( DataInputFile()$log2FC, na.rm = T)), round( max( DataInputFile()$log2FC, na.rm = T)), 1) )+
          labs( title ="Volcano Plot",
                caption = str_interp("Total = ${numrows_cust} variables; Significant Threshold = ${sigval_cust}; Vertical = +/-${as.integer(logFC_threshold_pos_cust)} "))
        
        CustomVolcanoPlotStore$image2 = volcanoplotcustom
        
        # d- PLOTLY     # m = list(l = 50, r = 50, b = 100, t = 100,  pad = 4)
        volcanoplotcustom_plotly = ggplotly( volcanoplotcustom, tooltip = "text") %>%
          layout(showlegend = FALSE,
                 autosize   = F,
                 yaxis      = yaxis ) %>%
          config(toImageButtonOptions   = list(format = "svg", width = 800, height = 600, dpi= 1200),
                 modeBarButtonsToRemove = c("lasso2d", "resetScale2d", "toggleSpikelines", "select2d", "pan2d"))
        return(volcanoplotcustom_plotly)}
      
      # 4.1.3 No File
      else if (is.null(CustomDataFile())){
        return(NULL) }
    }
  })
  
  # 4.1.4 OUTPUT visualisation
  output$CustomisedPlot = renderPlotly({
    CustomListOfInterest()   } )
  
  # 4.1.5 OUTPUT table
  output$CustomisedTable = renderDT({
    if (!is.null(CustomDataFile())){
      convert_file_data_uppercase   = toupper(CustomDataFile()[,1])
      subset_filedata_to_list       = DataFrameWithColors() %>%  
        mutate( GeneSymbol = toupper(GeneSymbol)) %>%
        filter( GeneSymbol %in% convert_file_data_uppercase) %>%
        mutate( GeneSymbol = stringr::str_to_title(GeneSymbol))
    }
    else if (!is.null(input$CustomList)){ 
      convert_own_gene_list   = toupper(unlist(strsplit(input$CustomList, " ")))
      subset_to_list       = DataFrameWithColors() %>%  
        mutate( GeneSymbol = toupper(GeneSymbol)) %>%
        filter( GeneSymbol %in% convert_own_gene_list) %>%
        mutate( GeneSymbol = stringr::str_to_title(GeneSymbol))
    }
    else if (is.null(CustomDataFile())){
      return(NULL)
    }
  })
  
  
  ###########################################################################################################
  # 5. DOWNLOAD results
  ###########################################################################################################
  # 5.0 Download table results
  output$DownloadTbl = downloadHandler(
    filename = function(){
      if (input$TableDownload == "Significant" & input$Tablefiletype == "csv"){
        paste("Signif_Table", "_", format(Sys.Date(), "%d%b%Y"),  paste(".", input$Tablefiletype, sep="") , sep = "")}
      else if (input$TableDownload == "Significant" & input$Tablefiletype == "txt"){
        paste("Signif_Table", "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Tablefiletype, sep=""), sep = "")}
      
      else if (input$TableDownload == "Processes" & input$Tablefiletype == "csv"){
        paste("Processes_Table", "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Tablefiletype, sep="") ,sep="")}
      else if (input$TableDownload == "Processes" & input$Tablefiletype == "txt"){
        paste("Processes_Table", "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Tablefiletype, sep=""), sep="")}
    },
    content = function(file) {
      if(input$TableDownload == "Significant" & input$Tablefiletype == "csv"){
        write.csv( FilteredToSignif(), file = file, row.names = FALSE)}
      else if(input$TableDownload == "Significant" & input$Tablefiletype == "txt"){
        write.table( FilteredToSignif(), file = file, row.names = FALSE, sep = "\t")}
      
      else if(input$TableDownload == "Processes" & input$Tablefiletype == "csv"){
        write.csv( MitoProcesses(), file = file, row.names = FALSE)}
      else if(input$TableDownload == "Processes" & input$Tablefiletype == "txt"){
        write.table( MitoProcesses() , file = file, row.names = FALSE, sep = "\t")}
    })
  
  
  # observe(
  #   print(input$PlotDownload == "Explore Plot Values")
  #   
  # )




  
  output$DownloadPlot = downloadHandler(
    filename = function(){
      if (     input$PlotDownload == "Explore Plot Values" & input$Plotfiletype == "png"){
        print(input$PlotDownload)
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      else if (input$PlotDownload == "Explore Plot Values" & input$Plotfiletype == "pdf"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      else if (input$PlotDownload == "Explore Plot Values" & input$Plotfiletype == "svg"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      else if (input$PlotDownload == "Explore Plot Values" & input$Plotfiletype == "jpeg"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      else if (input$PlotDownload == "Explore Plot Values" & input$Plotfiletype == "tiff"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      
      else if (input$PlotDownload == "Explore Mitochondrial Processes" & input$Plotfiletype == "png"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      else if (input$PlotDownload == "Explore Mitochondrial Processes" & input$Plotfiletype == "pdf"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      else if (input$PlotDownload == "Explore Mitochondrial Processes" & input$Plotfiletype == "svg"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      else if (input$PlotDownload == "Explore Mitochondrial Processes" & input$Plotfiletype == "jpeg"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      else if (input$PlotDownload == "Explore Mitochondrial Processes" & input$Plotfiletype == "tiff"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      
      else if (input$PlotDownload == "Explore Custom Gene List" & input$Plotfiletype == "png"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      else if (input$PlotDownload == "Explore Custom Gene List" & input$Plotfiletype == "pdf"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      else if (input$PlotDownload == "Explore Custom Gene List" & input$Plotfiletype == "svg"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      else if (input$PlotDownload == "Explore Custom Gene List" & input$Plotfiletype == "jpeg"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      else if (input$PlotDownload == "Explore Custom Gene List" & input$Plotfiletype == "tiff"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
    },
    content = function(file){
      print(file)
      if (     input$PlotDownload == "Explore Plot Values" & input$Plotfiletype == "png"){
        ggsave( filename=file, plot = ExplorePlotVolPplot$image0, device="png",  width = 400, height = 300, dpi= 1200, units = "mm")}
      else if (input$PlotDownload == "Explore Plot Values" & input$Plotfiletype == "pdf"){
        ggsave( filename=file, plot = ExplorePlotVolPplot$image0, device="pdf",  width = 400, height = 300, dpi= 1200, units = "mm")}
      else if (input$PlotDownload == "Explore Plot Values" & input$Plotfiletype == "svg"){
        ggsave( filename=file, plot = ExplorePlotVolPplot$image0, device="svg", width = 400, height = 300, dpi= 1200, units = "mm")}
      else if (input$PlotDownload == "Explore Plot Values" & input$Plotfiletype == "jpeg"){
        ggsave( filename=file, plot = ExplorePlotVolPplot$image0, device="jpeg", width = 400, height = 300, dpi= 1200, units = "mm")}
      else if (input$PlotDownload == "Explore Plot Values" & input$Plotfiletype == "tiff"){
        ggsave( filename=file, plot = ExplorePlotVolPplot$image0, device="tiff",width = 400, height = 300, dpi= 1200, units = "mm")}
      
      else if (input$PlotDownload == "Explore Mitochondrial Processes" & input$Plotfiletype == "png"){
        ggsave(  filename=file, plot = ExploreMitoVolcanoStore$image1, device = "png",  width = 400, height = 300, dpi= 1200, units = "mm")}
      else if (input$PlotDownload == "Explore Mitochondrial Processes" & input$Plotfiletype == "pdf"){
        ggsave(  filename=file, plot = ExploreMitoVolcanoStore$image1, device = "pdf",  width = 400, height = 300, dpi= 1200, units = "mm")}
      else if (input$PlotDownload == "Explore Mitochondrial Processes" & input$Plotfiletype == "svg"){
        ggsave(  filename=file, plot = ExploreMitoVolcanoStore$image1, device = "svg",  width = 400, height = 300, dpi= 1200, units = "mm")}
      else if (input$PlotDownload == "Explore Mitochondrial Processes" & input$Plotfiletype == "jpeg"){
        ggsave(  filename=file, plot = ExploreMitoVolcanoStore$image1, device = "jpeg",  width = 400, height = 300, dpi= 1200, units = "mm")}
      else if (input$PlotDownload == "Explore Mitochondrial Processes" & input$Plotfiletype == "tiff"){
        ggsave(  filename=file, plot = ExploreMitoVolcanoStore$image1, device = "tiff",  width = 400, height = 300, dpi= 1200, units = "mm")}
      
      else if (input$PlotDownload == "Explore Custom Gene List" & input$Plotfiletype == "png"){
        ggsave(  filename=file, plot = CustomVolcanoPlotStore$image2, device = "png",  width = 400, height = 300, dpi= 1200, units = "mm")}
      else if (input$PlotDownload == "Explore Custom Gene List" & input$Plotfiletype == "pdf"){
        ggsave(  filename=file, plot = CustomVolcanoPlotStore$image2, device = "pdf",  width = 400, height = 300, dpi= 1200, units = "mm")}
      else if (input$PlotDownload == "Explore Custom Gene List" & input$Plotfiletype == "svg"){
        ggsave(  filename=file, plot = CustomVolcanoPlotStore$image2, device = "svg",  width = 400, height = 300, dpi= 1200, units = "mm")}
      else if (input$PlotDownload == "Explore Custom Gene List" & input$Plotfiletype == "jpeg"){
        ggsave(  filename=file, plot = CustomVolcanoPlotStore$image2, device = "jpeg",  width = 400, height = 300, dpi= 1200, units = "mm")}
      else if (input$PlotDownload == "Explore Custom Gene List" & input$Plotfiletype == "tiff"){
        ggsave(  filename=file, plot = CustomVolcanoPlotStore$image2, device = "tiff",  width = 400, height = 300, dpi= 1200, units = "mm")}
    })
  
}



# ====================================================================
# ====================================================================
# ====================================================================
# V. Versions
# ====================================================================
# ====================================================================
# ====================================================================

# > sessionInfo()
# R version 3.6.1 (2019-07-05)
# Platform: x86_64-w64-mingw32/x64 (64-bit)
# Running under: Windows >= 8 x64 (build 9200)
# 
# Matrix products: default
# 
# locale:
#   [1] LC_COLLATE=English_Australia.1252  LC_CTYPE=English_Australia.1252    LC_MONETARY=English_Australia.1252
# [4] LC_NUMERIC=C                       LC_TIME=English_Australia.1252    
# 
# attached base packages:
#   [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
#   [1] shinyjs_1.1              shinythemes_1.1.2        shinydashboardPlus_0.7.0 config_0.3               crosstalk_1.0.0         
# [6] stringr_1.4.0            svglite_1.2.2            DT_0.11                  plotly_4.9.1             ggplot2_3.2.1           
# [11] shinyWidgets_0.5.1       shinydashboard_0.7.1     dplyr_0.8.3              shiny_1.4.0             
# 
# loaded via a namespace (and not attached):
#   [1] tidyselect_0.2.5  purrr_0.3.3       colorspace_1.4-1  vctrs_0.2.1       htmltools_0.4.0   viridisLite_0.3.0 yaml_2.2.0       
# [8] rlang_0.4.2       later_1.0.0       pillar_1.4.3      glue_1.3.1        withr_2.1.2       gdtools_0.2.1     lifecycle_0.1.0  
# [15] munsell_0.5.0     gtable_0.3.0      htmlwidgets_1.5.1 fastmap_1.0.1     httpuv_1.5.2      Rcpp_1.0.2        xtable_1.8-4     
# [22] promises_1.1.0    scales_1.0.0      backports_1.1.5   jsonlite_1.6      mime_0.7          systemfonts_0.1.1 digest_0.6.21    
# [29] stringi_1.4.3     grid_3.6.1        tools_3.6.1       magrittr_1.5      lazyeval_0.2.2    tibble_2.1.3      crayon_1.3.4     
# [36] tidyr_1.0.0       pkgconfig_2.0.3   zeallot_0.1.0     data.table_1.12.8 assertthat_0.2.1  httr_1.4.1        rstudioapi_0.10  
# [43] R6_2.4.0          compiler_3.6.1   