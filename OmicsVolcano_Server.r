# ====================================================================
# ====================================================================
# ====================================================================
# Title:      OmicsVolcano
# Copyright:  (C) 2020
# License:    GNU General Public
#
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NON-ACADEMICS: 
# CONTACT authors/software developers for any COMMERCIAL USE 
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
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
# Edith Cowan University, WA, AUSTRALIA
# Umea University, Umea, Sweden
# UXMachines Pty Ltd. WA, AUSTRALIA





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
# install.packages("colourpicker")


`%then%` = shiny:::`%OR%` # Note: %then% does not exist in current preview implementations of Shiny. 
# You can use the first line of code below to create a %then% operator.


# Debugging mode only - set TRUE if debugging information should be displayed
DEBUGGING_MODE = TRUE


# ====================================================================
# ====================================================================
# ====================================================================
# I VARIABLES
# ====================================================================
# ====================================================================
# ====================================================================

 ui_mmp_names = list( "Amino Acid Metabolism", "Apoptosis","Bile Acid Synthesis", "Calcium Signaling & Transport",
       "Cardiolipin Biosynthesis", "Fatty Acid Biosynthesis & Elongation", "Fatty Acid Degradation & Beta-oxidation",
       "Fatty Acid Metabolism", "Fe-S Cluster Biosynthesis", "Folate & Pterin Metabolism", "Fructose Metabolism",
       "Glycolysis", "Heme Biosynthesis","Import & Sorting", "Lipoic Acid Metabolism", "Metabolism of Lipids & Lipoproteins",
       "Metabolism of Vitamins & Co-Factors", "Mitochondrial Carrier", "Mitochondrial Dynamics", "Mitochondrial Gene Expression",
       "Mitochondrial Signaling", "Mitophagy", "Nitrogen Metabolism", "Nucleotide Metabolism", "Oxidative Phosphorylation",
       "Pentose Phosphate Pathway","Protein Stability & Degradation", "Pyruvate Metabolism", "Replication & Transcription",
       "Ribosomal", "ROS Defense", "Transcription (nuclear)", "Translation", "Transmembrane Transport", "Tricarboxylic Acid Cycle",
       "Ubiquinone Biosynthesis", "Unknown MT process", "UPRmt", "Translation (MT)", "Oxidative Phosphorylation (MT)")


 
 
 
# ====================================================================
# ====================================================================
# ====================================================================
# II Reference Files MOUSE
# ====================================================================
# ====================================================================
# ====================================================================
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





# ====================================================================
# ====================================================================
# ====================================================================
# II Reference Files HUMAN
# ====================================================================
# ====================================================================
# ====================================================================
hs_ribos_file = read.table("./ReferenceFiles/Human/hs_ribosomal_30March2020.txt",
                           header = T,
                           sep    = "\t",
                           fill   = T,
                           quote  = "")[, c(2,3,4)] # dim = 82  x 4

hs_processes_file = read.table("./ReferenceFiles/Human/hs_MitoCarta_MitoXplorer_AF_2April2020.txt",
                               header = T,
                               sep    = "\t",
                               fill   = T, 
                               quote  = "")[,c(1,2,3)]   # dim(1516    5)


# # Cellular compartmen localization (NOTE: HUMAN ONLY)
# 1) ACTIN
hs_actin_file = read.table("./ReferenceFiles/Human/actin_hs.txt",
                           header = T,
                           sep    = "\t",
                           fill   = T,
                           quote  = "")[,c(1,2,3,4)]   # 237   5  head(hs_actin_file);dim(hs_actin_file)

# 2) centrosome
hs_centrosome_file = read.table("./ReferenceFiles/Human/centrosome_hs.txt",
                                header = T,
                                sep    = "\t",
                                fill   = T,
                                quote  = "")[,c(1,2,3,4)]   # 359   4  head(hs_centrosome_file);dim(hs_centrosome_file)

# 3) cytosol_hs.txt
hs_cytosol_file = read.table("./ReferenceFiles/Human/cytosol_hs.txt",
                             header = T,
                             sep    = "\t",
                             fill   = T,
                             quote  = "")[,c(1,2,3,4)]   # 4395    5  head(hs_cytosol_file); dim(hs_cytosol_file)

# 4) ER_hs.txt
hs_ER_file = read.table("./ReferenceFiles/Human/ER_hs.txt",
                        header = T,
                        sep    = "\t",
                        fill   = T,
                        quote  = "")[,c(1,2,3,4)]   # 466   5  head(hs_ER_file);dim(hs_ER_file)

# 5) golgi_hs.txt
hs_golgi_file = read.table("./ReferenceFiles/Human/golgi_hs.txt",
                           header = T,
                           sep    = "\t",
                           fill   = T,
                           quote  = "")[,c(1,2,3,4)]   # 1030    5   head(hs_golgi_file);dim(hs_golgi_file)

# 6) intermediate_hs.txt"
hs_intermediate_file = read.table("./ReferenceFiles/Human/intermediate_hs.txt",
                                  header = T,
                                  sep    = "\t",
                                  fill   = T,
                                  quote  = "")[,c(1,2,3,4)]   # 191   5   head(hs_intermediate_file);dim(hs_intermediate_file)

# 7) microtubules_hs.txt
hs_microtubules_file = read.table("./ReferenceFiles/Human/microtubules_hs.txt",
                                  header = T,
                                  sep    = "\t",
                                  fill   = T,
                                  quote  = "")[,c(1,2,3,4)]   # 253   5  head(hs_microtubules_file);dim(hs_microtubules_file)

# 8) mito_hs.txt
hs_mito_file = read.table("./ReferenceFiles/Human/mito_hs.txt",
                          header = T,
                          sep    = "\t",
                          fill   = T,
                          quote  = "")[,c(1,2,3,4)]   # 1098    5  head(hs_mito_file);dim(hs_mito_file)

# 9) nucleoli_hs.txt
hs_nucleoli_file = read.table("./ReferenceFiles/Human/nucleoli_hs.txt",
                              header = T,
                              sep    = "\t",
                              fill   = T,
                              quote  = "")[,c(1,2,3,4)]   # 1027    5  head(hs_nucleoli_file);dim(hs_nucleoli_file)

# 10) nucmembrane_hs.txt
hs_nucmembrane_file = read.table("./ReferenceFiles/Human/nucmembrane_hs.txt",
                                 header = T,
                                 sep    = "\t",
                                 fill   = T,
                                 quote  = "")[,c(1,2,3,4)]  # 270   5  head(hs_nucmembrane_file); dim(hs_nucmembrane_file)

# 11) plasma_hs.txt
hs_plasma_file = read.table("./ReferenceFiles/Human/plasma_hs.txt",
                            header = T,
                            sep    = "\t",
                            fill   = T,
                            quote  = "")[,c(1,2,3,4)]  #1707    5  head(hs_plasma_file); dim(hs_plasma_file)

# 12) hs_vesicles_file
hs_vesicles_file = read.table("./ReferenceFiles/Human/vesicles_hs.txt",
                              header = T,
                              sep    = "\t",
                              fill   = T,
                              quote  = "")[,c(1,2,3,4)]   # 1930    5   head(hs_vesicles_file);dim(hs_vesicles_file)


# Create a list that contains
# Cell.name and related genes
list_of_cellular_values =list("Actin"        = hs_actin_file$Gene,
                              "Centrosome"   = hs_centrosome_file$Gene,
                              "Cytosol"      = hs_cytosol_file$Gene,
                              "ER"           = hs_ER_file$Gene,
                              "Golgi"        = hs_golgi_file$Gene,
                              "Intermediate" = hs_intermediate_file$Gene,
                              "Microtubules" = hs_microtubules_file$Gene,
                              "Mito"         = hs_mito_file$Gene,
                              "Nucleoli"     = hs_nucleoli_file$Gene,
                              "Nucmembrane"  = hs_nucmembrane_file$Gene,
                              "Plasma"       = hs_plasma_file$Gene,
                              "Vesicles"     = hs_vesicles_file$Gene)

name_list_of_cellular_values = list("Actin Filaments", "Centrosome", "Cytosol", "Endoplasmic Reticulum", "Golgi Apparatus", "Intermediate Filaments",
                                "Microtubules", "Mitochondria", "Nucleoli", "Nuclear Membrane", "Plasma Membrane", "Vesicles")






# ====================================================================
# ====================================================================
# ====================================================================
# Error handling
# ====================================================================
# ====================================================================
# ====================================================================
displayErrorMessage = function (messagesubject, message, errortrace) {
  showModal(modalDialog(
    title     = messagesubject,
    fade      = TRUE,
    easyClose = TRUE,
    message,
    footer    = tagList(modalButton("Close"))  )) }





# ====================================================================
# ====================================================================
# ====================================================================
# SERVER BODY
# ====================================================================
# ====================================================================
# ====================================================================
server = function(input, output, session) {
  if(DEBUGGING_MODE) {
    Sys.time()
    print("server")
    
  }
  
  # ===================================================================================================================================
  # ===================================================================================================================================
  # 0. UI Front-End Handling
  # ===================================================================================================================================
  # ===================================================================================================================================
  
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
      input$ui_threshold_configuration        #        sliderInput("n", "N", 1, 1000, 500)
    }    )}
  
  output$UI_NOTIFICATIONS = renderMenu ( {
    dropdownMenu (
      type = "notifications",
      notificationItem(
        text = "Applications successfuly started",
        icon("thumbs-up")  ))  })

    
  # CONTEXTUALIZED RIGHT MENUE DEPENENDENT WHAT IS SELECTED ON THE LEFT MENUE
  UI_INFO_TEXTS = list(
    menue_tab_file_open  = ("Open data file"),
    menue_tab_file_close = ("close data file"),
    
    menue_tab_exp_plot     = ("Plot and explore data"),
    menue_tab_exp_genelist = ("Explore gene list"),
    menue_tab_exp_mitproc  = ("Mitochondrial process explorer"),
    menue_tab_exp_multiple_mitoprocesses  = ("Mitochondrial multi processes explorer"), 
    menue_tab_exp_cellular_compartment  = ("Cellular compartment localization explorer"),
    
    menue_tab_download_plot  = ("Download data plot"),
    menue_tab_download_table = ("Download data tables"),
    
    menue_tab_help  = ("Help page"),
    menue_tab_about = ("About page")  )

    
  # UPDATE THE RIGHT CONTEXT MENUE dependent on which left menue in the dashboard has been selected
  observeEvent(input$ui_dashboard_sidebar, {
    print(input$ui_dashboard_sidebar)
    
    x = UI_INFO_TEXTS["input$ui_dashboard_sidebar"]
    if (is.null(x)) { x=""}
    output$UI_RIGHT_DASHBOARD_HELP_TEXT = renderText({paste0( x )})
    
    x="UI_RIGHT_SIDEBAR_NONE"
    
    if ( (input$ui_dashboard_sidebar == "menue_tab_exp_plot") | (input$ui_dashboard_sidebar == "menue_tab_exp_genelist") | (input$ui_dashboard_sidebar == "menue_tab_exp_mitproc") | (input$ui_dashboard_sidebar == "menue_tab_exp_multiple_mitoprocesses") | (input$ui_dashboard_sidebar == "menue_tab_exp_cellular_compartment") )
    { x = input$ui_dashboard_sidebar}
    
    updateTabsetPanel(session, "UI_RIGHT_SIDEBAR_SELECTMODE", selected = x) }) 
  
  
  # Status box upldates: Mitochondria process   
  observeEvent(input$OrganismSource, {
    output$UI_INFO_PROCESS = renderInfoBox ({
      infoBox ( "Process",
                paste (input$OrganismSource),
                paste (input$MtProcess),
                icon  = icon("fas fa-filter"),
                color = "yellow")
    })   })
  
  observeEvent(input$MtProcess, {
    output$UI_INFO_PROCESS = renderInfoBox ({
      infoBox ("Process",
               paste (input$OrganismSource),
               paste (input$MtProcess),
               icon  = icon("fas fa-filter"),
               color = "yellow")
    })  })
  
  observeEvent(input$VerticalThreshold, {
    output$UI_INFO_GENERAL = renderInfoBox ({
      infoBox ( title    = "Log2FC and Significance",
                value    = paste0 ("+/-", input$VerticalThreshold, ""),
                subtitle = paste0 (input$Signif),
                icon     = icon("tachometer-alt"),
                color    = "yellow")
    })  })
  
  observeEvent(input$UI_INPUT_FILENAME, {
    output$UI_INFO_FILENAME = renderInfoBox ( {
      infoBox ("Filename",
               paste0 (input$UI_INPUT_FILENAME),
               icon  = icon("database"),
               color = "yellow")
    })  })
  
  

  
  observeEvent(input$CustomInputOptions, {
    if (input$CustomInputOptions == "Insert a list of genes") {
      output$UI_INFO_EXPLORE = renderInfoBox ({
        infoBox ( "Explore",
                  "Manual List",
                  paste0 (input$CustomList),
                  icon  = (icon("list-ol")),
                  color = "yellow")   }) 
    } 
    else 
    {output$UI_INFO_EXPLORE = renderInfoBox ({
      infoBox ("Explore",
               "File",
               icon = (icon("list-ol")),
               color = "yellow")      }) 
    }  })
  
  
  # exit button pressed
  observeEvent(input$ExitApplication, {
    quit(0)  })
  
  observeEvent( input$CustomList, ({
    print( paste("Custom List Selected", input$CustomList))  
  })  )
  
  
  observeEvent( input$UserGeneNamesFile, ({
    print( paste("Custom List Selected", input$UserGeneNamesFile))  })  )
  
  

  # Raise error if file is not uploaded 
  observeEvent(input$ui_dashboard_sidebar, {
    if ( is.null(input$UI_INPUT_FILE_NAME$datapath) & input$ui_dashboard_sidebar=="menue_tab_exp_plot"){
      displayErrorMessage("Input file is not uploded!", "Please use File tab to upload your file.", "")
      return(NULL)}
    else if (is.null(input$UI_INPUT_FILE_NAME$datapath) & input$ui_dashboard_sidebar=="menue_tab_exp_genelist"){
      displayErrorMessage("Input file is not uploded!", "Please use File tab to upload your file.", "")
      return(NULL)}
    else if (is.null(input$UI_INPUT_FILE_NAME$datapath) & input$ui_dashboard_sidebar=="menue_tab_exp_mitproc"){
      displayErrorMessage("Input file is not uploded!", "Please use File tab to upload your file.", "")
      return(NULL)}
    else if (is.null(input$UI_INPUT_FILE_NAME$datapath) & input$ui_dashboard_sidebar=="menue_tab_exp_multiple_mitoprocesses"){
      displayErrorMessage("Input file is not uploded!", "Please use File tab to upload your file.", "")
      return(NULL)}
    else if (is.null(input$UI_INPUT_FILE_NAME$datapath) & input$ui_dashboard_sidebar=="menue_tab_exp_cellular_compartment"){
      displayErrorMessage("Input file is not uploded!", "Please use File tab to upload your file.", "")
      return(NULL)}
  })
  

  # ====================================================================
  # ====================================================================
  # ====================================================================
  # EXPLORE MULTIPLE PROCESSES + COULORS widgets appearance 
  # ====================================================================
  # ====================================================================
  # ====================================================================
  
  #================================================================================================================
  # 1. MULTIPLE PROCESSES WIDGET (right-hand widget appearance)
  #================================================================================================================
  # output$UI_MMP_PROCESSES = renderUI ({
  #   # BOX for "APPLY" button
  #   box (width = NULL,  #For column-based layouts, use NULL for the width
  #        fluidRow( width = 12,
  #                  offset =2,
  #                  actionButton(inputId = "UI_MMP_LIST_ACTION",
  #                               width   = '80px',
  #                               label   = "Apply")),
  #        hr(),   # space btw Action button and next info
  #        lapply(1:length(ui_mmp_names), function(x) {
  #          fluidRow( offset = 1,
  #                    # CHECK BOXES
  #                    column (width = 1,
  #                            checkboxInput(
  #                              inputId = paste0("UI_MMP_LIST_CHECKBOX_", x),
  #                              value   = FALSE,
  #                              label   = NULL)),
  #                    # COLOUR PALETTE
  #                    column (width = 2,
  #                            colourWidget( elementId  = paste0("UI_MMP_LIST_COLORPICKER_", x),
  #                                          value      = "#000000",
  #                                          palette    = "square",
  #                                          showColour = "both",
  #                                          width      = '77px',
  #                                          height     = '20px')),
  #                    # PROCESSES
  #                    column (width = 9,
  #                            h5(ui_mmp_names[x]))
  #         )})
  #       )
  # })
################################################################################################

  
  # ===================================================================================================================================
  # 2. The function takes the complete list of input values and creates 
  # a dataframe for further processing.
  # vl:      global value, reactiveValuesToList(input)
  # RETURNS: a data frame with the input$ values as value-key pairs
  # ===================================================================================================================================
  convertValueListToDF = function(vl) {
    if (DEBUGGING_MODE) {
      Sys.time()
      print("convertValueListToDF")
    }
    if (!is.null(vl)) {
      df = data.frame(matrix(ncol = 2, 
                             nrow = length(vl)))  # create a data frame 
      colnames(df) = c("IDs","Value")
      df$IDs       = names(vl)
      df$Value     = lapply(1:length(vl), function (x) { values = vl[[x]]})
      return(df)
    }
    return (null)
    }
  
  

  # ===================================================================================================================================
  # 3. The function takes a dataframe which consists of value-key pairs
  # and compares it to the second string
  # INPUT: df - data frame with key-value pairs
  # INPUT: st - string value to compare to
  # RETURNS: the value of the key st that is contained in the df., NULL if not present
  # ===================================================================================================================================
    getValueOfDF = function(df, st){
      if (DEBUGGING_MODE) {
        Sys.time()
        print("getValueOfDF")
      }
      
    for (x in (1:dim(df)[1])){
      # TODO Artur STRING COMPARISON HERE
      if (st == df[x,1]) {
        # print("st")
        # print(st)
        # print("df")
        # print(df[x,1])
        # print(df[x,2])
        return (unlist(df[x, 2]))
      }
    }
      return (NULL)
    }

  # getValueOfDF = function(df, st){
  #   # print("getValueOfDF")
  #   lapply(1:dim(df)[1], function (x) {
  #     if (st == df[x,1]) {
  #       return (unlist(df[x, 2]))
  #     }
  #     else{
  #       return (NULL)
  #     }
  #     })
  # }
  

  # ===================================================================================================================================
  # 4. BUILD DATA FRAME OF SELECTED MULTIPLE PROCESSES WITH SELECTED COLOUR  reactiveValues
  # ===================================================================================================================================
  getMMPValuesSelected = function () {
    
    if (DEBUGGING_MODE) {
      Sys.time()
      print("getMMPValuesSelected")
    }
    
    df_valueKeysList = convertValueListToDF(reactiveValuesToList(input))           # IDs     Value
    df_result = data.frame(MMPRow=numeric(0),
                           CheckBoxID=character(0),
                           CheckBoxVal=logical(0),
                           ColID=character(0),
                           ColValue=character(0),
                           ProcessName=character(0))  # create a data frame
    for (val in (1:length(ui_mmp_names))){
      cb_id   = paste0("UI_MMP_LIST_CHECKBOX_", val)
      col_id  = paste0("UI_MMP_LIST_COLORPICKER_", val)
      cb_val  = getValueOfDF(df_valueKeysList, cb_id)
      
      if (is.logical(cb_val) & cb_val!="FALSE") {      # ARTUR as.logical(cb_val)
      #if (is.logical(cb_val)) {                       # is.logical returns TRUE or FALSE depending on whether its argument is of logical type or not.
        col_val = getValueOfDF(df_valueKeysList, col_id)
        proc_name  = unlist(ui_mmp_names)[val]
        df_result = rbind (df_result, data.frame(MMPRow     = val,
                                                 CheckBoxID = cb_id,
                                                 CheckBoxVal= as.logical(cb_val),
                                                 ColID      = col_id,
                                                 ColValue   = col_val,
                                                 ProcessName= proc_name))
      }
    }
    # print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    # print(df_result)
    return(df_result)
  }
  

  
  # ====================================================================
  # ====================================================================
  # ====================================================================
  # EXPLORE CELLULAR COMPARTMENT LOCALIZATION 
  # ====================================================================
  # ====================================================================
  # ====================================================================
  
  # #================================================================================================================
  # # 1. CELLULAR COMPARTMENT LOCALIZATION WIDGET (right-hand widget appearance)
  # #================================================================================================================

  # ====================================================================
  # ====================================================================
  # ====================================================================
  # 1. SUBSET DATA to SIGNIFICANT, PROCESSES
  # ====================================================================
  # ====================================================================
  # ====================================================================

  
  
  #================================================================================================================
  # 1.0 PARSE INPUT FILE provided by the user
  #================================================================================================================
  DataInputFile = reactive ({
    if (DEBUGGING_MODE) {
      Sys.time()
      print("DataInputFile()")
    }
    
    # Ensure that required values are available 
    req(input$UI_INPUT_FILE_NAME$datapath)

    # specify your location in the script
    print("DataInputFile() Reactive:")
    print(input$UI_INPUT_FILE_NAME$datapath)
    print(input$UI_INPUT_FILE_SEPARATOR)
    print(input$UI_INPUT_FILE_REMOVE_DUPLICATES)
    print("END ----  DataInputFile() Reactive: -------")
    print("-------------------------------------------")
    
    # handling errors and warnings
    tryCatch({
      # IF CHECK FOR THE FILE
      # parse file
      df = read.csv(file   = input$UI_INPUT_FILE_NAME$datapath,
                    sep    = input$UI_INPUT_FILE_SEPARATOR,
                    header = T,
                    quote  = "")
      # browser()
      
      # I.Number of columns 
      if (!ncol(df) ==5){
        displayErrorMessage("File Loading Error in Data Input File!", "Please check number of columns or select correct field separator character. Alternatively, review the Help Page for the file input format", "")
        return(NULL)
      }
      # II.Column names
      else if ( !names(df)[1]=="ID"){
        displayErrorMessage( "File Formatting Error", paste("Please check the name of the 1st column. It is ID, not", names(df)[1], sep=" "), "")
        return(NULL)
      }
      else if (!names(df)[2]=="GeneSymbol"){
        displayErrorMessage("File Formatting Error", paste("Please check the name of the 2nd column. It is GeneSymbol, not", names(df)[2], sep=" "), "")
        return(NULL)
      }
      else if (!names(df)[3]=="Description"){
        displayErrorMessage("File Formatting Error", paste("Please check the name of the 3rd column. It is Description, not", names(df)[3], sep=" "), "")
        return(NULL)
      }
      else if (!names(df)[4]=="Log2FC"){
        displayErrorMessage("File Formatting Error", paste("Please check the name of the 4th column. It is Log2FC, not", names(df)[4], sep=" "), "")
        return(NULL)
      }
      else if (!names(df)[5]=="AdjPValue"){
        displayErrorMessage("File Formatting Error", paste("Please check the name of the 5th column. It is AdjPValue, not", names(df)[5], sep=" "), "")
        return(NULL)
      }

      # III. IF CHECK FOR DUPLICATES BOX IS TICKED
      else if (input$UI_INPUT_FILE_REMOVE_DUPLICATES==TRUE) {
        df_dup = df %>%
          mutate( GeneSymbol = make.unique( sapply(strsplit( as.character(df$GeneSymbol),";"), `[`, 1) , sep=".") ) %>%    # Add numeric extention to duplicated gene name
          mutate( GeneSymbol = gsub(".*NA.*", "NA" , GeneSymbol))
        
       # browser()

        # Represent Gene Symbols that are not available as NA 
        displayUIStatusMessage("File Loading Successful!", FALSE)
        output$UI_INPUT_FILE_RESULTS = renderDT(DataInputFile())
        return(df_dup)}
      else { 
        displayUIStatusMessage("File Loading Successful!", FALSE)
        output$UI_INPUT_FILE_RESULTS = renderDT(DataInputFile())
        return(df)}
    },
    error = function(e) {
      displayErrorMessage("File Loading Error in Data Input File!", "Please choose the correct file separator! Alternatively, review the Help Page for the file input format", "")})
  })
  

  
  
  
  #================================================================================================================
  # 1.1 SUBSET input data to SIGNIF. threshold
  #================================================================================================================
  FilteredToSignif = reactive({
    if (DEBUGGING_MODE) {
      Sys.time()
      print("FilteredToSignif()")
    }
    
    
    # Ensure that required values are available
    req(DataInputFile())
    req(input$Signif)
    
    # specify your location in the script
    print("FilteredToSignif Reactive:")
    print("----")

    tryCatch({
      # Filter to significant  
      signif = DataInputFile() %>%
        filter( AdjPValue < input$Signif,
                !is.na(AdjPValue)) 
      return(signif[,c(1,2,4,5,3)])

    },
    error = function(e) {
      displayErrorMessage("File Loading Error in Data Input File!", 
                          "Check the Help Page for the file input format, column names", "")}
    )  })
  
  
  #================================================================================================================
  # 1.1.0 OUTPUT SIGNIF. to TABs: "Explore Plot Values" AND to "Explore Mitochondrial Processes"
  #================================================================================================================
  output$SignifData1 = output$SignifData3 = renderDT({ FilteredToSignif() })
  
  

  df_subset_input_to_reffiles = function(inputdata, mitorefprocesses, ribosomref){
    # 0. FUNCTION TASK:
    # This function takes INPUT file and subsets to Mito ref. and Ribosomal/OXPHOs ref.files
    
    # 1. FUNCTION ARGUMENTS:
    # A) inputdata        = DataInputFile()
    # Mouse or Human data
    # B) mitorefprocesses = mm_processes_file   | hs_processes_file
    # C) ribosomref       = mm_ribos_file       | hs_ribos_file
    
    # 2. FUNCTION BODY: 
    # MitoCarta ref.file
    upperCase      = mutate( inputdata, upcase = toupper(GeneSymbol) )
    mtfunct_in     = upperCase %>% filter(upcase %in% toupper(mitorefprocesses$GeneName))
    processdata_in = merge.data.frame(mtfunct_in, mitorefprocesses[,c(1,3)], by.x = "upcase", by.y = "GeneName")             #processdata_in[ , c(3,2,7,5,6,4)] 
    
    # Ribosom and OXPHOs ref.files
    mm_ribos_file_upper= mutate( mm_ribos_file, GeneName = toupper(GeneName) ) 
    mtfunct_rib        = upperCase %>% filter(upcase %in% toupper(mm_ribos_file_upper$GeneName))   # dim(mtfunct_rib)  # 58 6
    processdata_rib    = merge.data.frame(mtfunct_rib, mm_ribos_file_upper[,c(1,3)], by.x = "upcase", by.y = "GeneName")       #processdata_rib[1:5 , c(3,2,7,5,6,4)]  #   58  7
    
    # Assemble result
    final_processes    = rbind(processdata_in, processdata_rib)
    # browser()
    
    # 3. RETURN VALUE:  
    return(final_processes[,c(2,3,5,6,4,7)]) 
    }  
  
  
  
  #================================================================================================================
  # 1.2 COMBINE MT PROCESSES, such as MitoCarta + MitoXplorer AND Ribosomal
  #================================================================================================================
  MitoProcesses = reactive ({
# MitoProcesses = observe ({
    if (DEBUGGING_MODE) {
      Sys.time()
      print("MitoProcesses()")
    }
        
    # Ensure that required values are available
    req(DataInputFile())
    req(input$OrganismSource)
    
    # specify your location in the script
    print("MitoProcesses Reactive:")
    print(input$OrganismSource)
    print("END ---- MitoProcesses Reactive: -----")
    print("-------------------------------------------")
    
    tryCatch({
      # Mouse
      if (input$OrganismSource == "Mouse" & !is.null(DataInputFile()) ){
        df_subset_input_to_reffiles(DataInputFile(), mm_processes_file, mm_ribos_file)
        # browser()
      }
      
      # Human 
      else if (input$OrganismSource == "Human" & !is.null(DataInputFile()) ){
        df_subset_input_to_reffiles(DataInputFile(), hs_processes_file, hs_ribos_file)
      }
      
      # Mouse & NO INPUT
      else if (input$OrganismSource == "Mouse" & is.null(DataInputFile()) ){
        return(NULL)}
      
      # Human & NO INPUT
      else if (input$OrganismSource == "Human" & is.null(DataInputFile()) ){
        return(NULL)}
    },
    error = function(e) {
      displayErrorMessage("File Loading Error in Data Input File!", 
                          "Check the Help Page for the file input format, column names. /// MitoProcesses function |dependencies: df_subset_input_to_reffiles()", "")}
    )
  })
  
  
  #================================================================================================================
  # 1.2.0 OUTPUT PROCESSES
  #================================================================================================================
  output$ProcessesData3 = renderDT({
    MitoProcesses() })
  
  
  #================================================================================================================
  # Subset input data to selected ONE process  
  #================================================================================================================
  MitoProcessesTableRes = reactive ({
  #MitoProcessesTableRes = observe ({
    # Ensure that required values are available
    req(MitoProcesses())
    req(input$MtProcess)
    
    # specify your location in the script
    print("MitoProcessesTableRes Reactive:")
    print(input$MtProcess)
    print("END ---- MitoProcessesTableRes Reactive: -----")
    print("-------------------------------------------")

    SelectedProcess=MitoProcesses()[as.character(MitoProcesses()$Process) %in% input$MtProcess, ]
    #browser()  
    return(SelectedProcess)
    })
  
  output$ProcessesDataSubset3 = renderDT({
    MitoProcessesTableRes() })
  #================================================================================================================
  
  
  

  
  
  
  
  
  
  #================================================================================================================
  #================================================================================================================
  # 2.0 Create dataframe with colour identifier for visualization
  # TASK: Take input data and assign color according its significance values:  blue, red, grey
  #================================================================================================================
  #================================================================================================================
  DataFrameWithColors = reactive({
  # DataFrameWithColors = observe({
    # Ensure that required values are available
    req(DataInputFile())
    req(input$Signif)
    req(input$VerticalThreshold)
    
    # specify your location in the script
    print("DataFrameWithColors Reactive:")
    print(input$Signif)
    print("END DataFrameWithColors----")
    print("-------------------------------------------")        
    
    # 2.0.0 Initialise input varibales  
    tryCatch ({
      if (is.null(DataInputFile())){
        return(NULL) }
      
      else      {
        # 2.0.4 Add column that contains information about signif-negative, signif-positiv, not signif + signif 
        inputdata           = DataInputFile()
        logFC_threshold_pos =  as.numeric(input$VerticalThreshold)  # logFC_threshold_pos =  1
        logFC_threshold_neg = -logFC_threshold_pos                  # logFC_threshold_neg = -(logFC_threshold_pos) 
        signif_threshold    = input$Signif                          # signif_threshold    = 0.05
        
        # 2.0.5 1-SIGNIF. positive | prot_in$Log2FC > neg_val & prot_in$AdjPValue < input$Signif))] = sign_pos_color
        positiv_signif = inputdata %>%
          filter( Log2FC > logFC_threshold_pos & AdjPValue < signif_threshold) %>%
          mutate(CharValue = "red")
        
        # 2.0.6 2-SIGNIF. negative | prot_in$Log2FC < -neg_val & prot_in$AdjPValue < input$Signif))] = sign_neg_color
        neg_signif = inputdata %>%
          filter( Log2FC < logFC_threshold_neg & AdjPValue < signif_threshold) %>%
          mutate(CharValue = "blue")
        
        # 2.0.7 3-NOT SIGNIF between [-1;+1]
        notsignif1 = inputdata %>%
          filter( AdjPValue < signif_threshold & Log2FC >= logFC_threshold_neg,
                  AdjPValue < signif_threshold & Log2FC <= logFC_threshold_pos) %>%
          mutate(CharValue = "grey")
        
        # 2.0.8 4-NOT SIGNIF NA are excluded
        notsignif2 = inputdata %>% 
          filter( AdjPValue > signif_threshold) %>%
          mutate(CharValue = "grey")
        
        # 2.0.9 5-SUBSET to NA 
        na_data = inputdata %>% 
          filter(is.na(AdjPValue) | is.na(Log2FC)) %>%
          mutate(CharValue = "grey2")
        
        # 2.1.0 6-COMBINE ALL filtered data
        df_color = rbind(positiv_signif, neg_signif, notsignif1, notsignif2, na_data)
        # browser()
        return(df_color)  # ID -	GeneSymbol -	Log2FC -	AdjPValue -	Description -	CharValue
        
      }
    }, error = function(e) {
      displayErrorMessage("File Loading Error in Data Input File!", 
                          "Check the Help Page for the file input format, column names. /// DataFrameWithColors function", "")}
    )
  })
  
  
  #================================================================================================================
  # 2.1 CROSSTALK :)  # https://rstudio.github.io/crosstalk/shiny.html
  #================================================================================================================
  DataSharedWithColors = SharedData$new(DataFrameWithColors)
  
  
  
  #================================================================================================================
  # 2.2 REACTIVE VALUE, so plot can be saved 
  #================================================================================================================
  StorePlotForExplore = reactiveValues()   
  
 
  
  plot_colour_distrib = function(inputdatawithcolors){
    # 0. FUNCTION TASK:
    # This function creates a vector of colors for the plot and takes into consideration variouse scenarios of data and colors:
    # 1) data has blue - grey - white - red  values
    # 2) NO BLUE (neg signif), grey - white - red
    # 3) NO RED (pos signif),  blue - grey - white
    # 4) blue - grey - red
    # 5) grey white
    # 6) blue - red
    
    # 1. FUNCTION ARGUMENTS:
    # A) inputdatawithcolors        = DataFrameWithColors()
    
    # 2. FUNCTION BODY: color distribution
    colorvec = unique(inputdatawithcolors$CharValue)  # color order: red blue grey grey2
    plot_color_values = c()   # initialize empty vector
    
    # all values: left sig NA right
    if ( length(colorvec)==4){
      plot_color_values = c(plot_color_values, c("#9fd8fb", "#cccccc", "white", "#ffcccc"))  # => reverse coloring: blue - grey - white - red 
    }
    # left nsig na  ---
    else if (length(colorvec)==3 & (colorvec[1]=="red") & (!colorvec[2]=="blue")){            
      plot_color_values = c(plot_color_values, c("#cccccc", "white", "#ffcccc"))             # => reverse coloring: grey - white - red
    }
    # --- nsig na right
    else if (length(colorvec)==3 & (colorvec[1]=="blue") & (colorvec[2]=="grey")){           
      plot_color_values = c(plot_color_values, c("#9fd8fb", "#cccccc", "white"))             # => reverse coloring: blue - grey - white 
    }
    # left nsig --- right
    else if (length(colorvec)==3 & (!"grey2" %in% colorvec) & (colorvec[1]=="red") & (colorvec[2]=="blue") & (colorvec[3]=="grey")){  
      plot_color_values = c(plot_color_values, c("#9fd8fb", "#cccccc", "#ffcccc"))          # => reverse coloring: blue - grey - red
    }
    # --- nsig NA ---
    else if (length(colorvec)==2 & (colorvec[1]=="grey") & (colorvec[2]=="grey2") ){         # => reverse coloring: grey white
      plot_color_values = c(plot_color_values, c( "#cccccc", "white"))   
    }
    # left --- --- right
    else if (length(colorvec)==2 & (colorvec[1]=="red") & (colorvec[2]=="blue") ){         # => reverse coloring: blue - red
      plot_color_values = c(plot_color_values, c( "#9fd8fb", "#ffcccc"))   
    }
    # 3. RETURN VALUE: 
    return(plot_color_values)
  }
   
  #================================================================================================================
  # 2.3 VISUALIZATION ("Explore Plot Values")
  #================================================================================================================
  ExplorePlotVolPplot = reactive({
  # ExplorePlotVolPplot = observe({
    # Ensure that required values are available
    req(DataInputFile())
    req(input$Signif)
    req(input$VerticalThreshold)
    req(DataFrameWithColors())
    
    # specify your location in the script
    print("ExplorePlotVolPplot Reactive:")
    print("END ---- ExplorePlotVolPplot Reactive: ------")
    print("-------------------------------------------")
    
    # 0 Initialised parameters
    sigval                = input$Signif
    logFC_threshold_pos   = as.numeric(input$VerticalThreshold)
    logFC_threshold_neg   = -logFC_threshold_pos
    numrows               = nrow(DataInputFile())
    yaxis = list(tickmode = "array", automargin = TRUE )
    tex   = list(family   = "sans serif", size  = 14, color = toRGB("#262626"))
    
    # # Color distribution
    plot_color_values = plot_colour_distrib(DataFrameWithColors())
    
    tryCatch ({
      if (is.null(DataInputFile())){
        return(NULL) }
      
      else{
        # browser()
        VolcanoPlotExplore = ggplot(data  = DataSharedWithColors,
                                      mapping = aes(x    = Log2FC,
                                                    y    = -log10(AdjPValue),
                                                    text = GeneSymbol )) +
            # Plot value colours
            geom_point( aes( color  = CharValue),
                        show.legend = FALSE ) +
            scale_color_manual( values = plot_color_values) +   # blue grey white red
            # Axis
            geom_hline( yintercept = -log10(sigval),
                        color      = "#777777",
                        size       = 0.15 ) +
            geom_vline( xintercept = logFC_threshold_pos,
                        color      = "#777777",
                        size       = 0.15 ) +
            geom_vline( xintercept = logFC_threshold_neg,
                        color      = "#777777",
                        size       = 0.15 ) +
            # Plot background
            theme_classic() +
            # X axis scale
            scale_x_continuous(breaks = seq( round( min( DataInputFile()$Log2FC, na.rm = T)),
                                             round( max( DataInputFile()$Log2FC, na.rm = T)), 1) )+
            # Y axis scale
            scale_y_continuous(breaks = seq( round( min( -log10(DataInputFile()$AdjPValue), na.rm = T)), 
                                             round( max( -log10(DataInputFile()$AdjPValue), na.rm = T)), 2) )

          StorePlotForExplore$image0 = VolcanoPlotExplore

          # 2. PLOTLY
          VolcanoPlotExplore_plotly = ggplotly( VolcanoPlotExplore, tooltip = "text") %>%
            highlight(on         = "plotly_click",
                      off        = "plotly_doubleclick",
                      dynamic    = F,         
                      persistent = TRUE,
                      color      = "#777777",
                      opacityDim = 1,
                      selected   = attrs_selected(mode         = "text",
                                                  textfont     = tex,
                                                  textposition = "top right",
                                                  marker       = list(symbol = ".crossTalkKey"))) %>%
            layout(showlegend = FALSE,
                   autosize   = TRUE,
                   yaxis      = yaxis,
                   title = list(text = str_interp("Total = ${numrows} variables; Significant Threshold = ${sigval}; Vertical = +/-${as.integer(logFC_threshold_pos)} "),
                                font = list(family = "Arial",
                                            size   = 10),
                                xanchor= "center")
                   ) %>%
            config(toImageButtonOptions   = list(filename = "ExplorePlot",
                                                 format = "svg",
                                                 width  = 800,
                                                 height = 600,
                                                 dpi    = 1200),
                   modeBarButtonsToRemove = c("lasso2d", "resetScale2d", "toggleSpikelines", "select2d", "pan2d"))
          return(VolcanoPlotExplore_plotly)
        }
      }, 
      error = function(e) {
        displayErrorMessage("File Loading Error in Data Input File!", 
                            "Check the Help Page for the file input format, column names. Mac OS users, check if the XQuartz App (https://www.xquartz.org) is installed /// ExplorePlotVolPplot function", "")}
    )
  })
  
  
  #================================================================================================================
  # 2.3.3 OUT VISUAL  
  #================================================================================================================
  output$volcanoPlotNuclear = renderPlotly({
    a1 = ExplorePlotVolPplot()
    Sys.sleep(2)
    hide(id = "loading-content1")  
    a1
  })
  
  
  #================================================================================================================
  # 2.3.4 OUT Display Table
  #================================================================================================================
  output$InputOriginalData1 = renderDT({
    if (! is.null(DataSharedWithColors) ) {
      datatable(DataSharedWithColors)
    }
  }, 
  server = FALSE)
  
  
  
  # ==================================================================================
  # ==================================================================================
  # ==================================================================================
  # 3. VISUALIZE ("Explore Mitochondrial Processes") | crosstalk btw table and plot 
  # ==================================================================================
  # ==================================================================================
  # ==================================================================================
  df_of_all_processes_colors = function(inputdata, refprocess, ribosomal, logFC_threshold_pos, logFC_threshold_neg, signif_threshold){
    # 0. FUNCTION TASK:
    # This function creates a dataframe with all processes of input data and colors:

    # 1. FUNCTION ARGUMENTS:
    # A) inputdata        = DataInputFile()
    # B) refprocess   =     mm_processes_file   |  hs_processes_file
    # c) ribosomal    =     mm_ribos_file       |  hs_ribos_file
    
    # 2. FUNCTION BODY: color distribution
    # 3.1.1 Convert gene symbols in INPUT file to Upper case
    refprocess    = mutate(refprocess, upcase = toupper(GeneName))
    upperCaseDF   = mutate( inputdata, upcase = toupper(GeneSymbol) )   
    
    # 3.1.2 Convert gene symbols in REF file to Upper case 
    processInclud = upperCaseDF %>% filter(upcase %in% toupper(refprocess$GeneName))  
    
    # 3.1.3 Merge INPUT and REF file by gene symbol
    mergedataIncl = merge.data.frame(processInclud, refprocess[,c(3,4)], by = "upcase")   # 489   7 #  !!!!MAYBE gene IDS
    mergedataIncl = mergedataIncl[, c(2:7,1)]
    
    processExclud = upperCaseDF %>% filter(!upcase %in% toupper(refprocess$upcase))   
    Process       = rep( 'NA', dim(processExclud)[1])
    excludAddedNA = cbind(processExclud, Process)[, c(1,2,3,4,5,7,6)] 
    
    combined         = rbind(mergedataIncl, excludAddedNA)     
    finaldfpopulated = combined[ , c(1,2,4,5,6,3)][order(combined$Process), ]    # complete input data
    
    # 3.1.4 Add column that contains information about signif-negative, signif-positiv, not signif + signif 
    # logFC_threshold_pos =  as.numeric(input$VerticalThreshold)  # logFC_threshold_pos =  1
    # logFC_threshold_neg = -logFC_threshold_pos                  # logFC_threshold_neg = -(logFC_threshold_pos) 
    # signif_threshold    = input$Signif                          # signif_threshold    = 0.05
    
    # 3.1.5 1-SIGNIF. positive | prot_in$Log2FC > neg_val & prot_in$AdjPValue < input$Signif))] = sign_pos_color
    positiv_signif = finaldfpopulated %>%
      filter( Log2FC > logFC_threshold_pos & AdjPValue < signif_threshold) %>%
      mutate(CharValue = "red")
    
    # 3.1.6 2-SIGNIF. negative | prot_in$Log2FC < -neg_val & prot_in$AdjPValue < input$Signif))] = sign_neg_color
    neg_signif = finaldfpopulated %>%
      filter( Log2FC < logFC_threshold_neg & AdjPValue < signif_threshold) %>%
      mutate(CharValue = "blue")
    
    # 3.1.7 3-NOT SIGNIF between [-1;+1]
    notsignif1 = finaldfpopulated %>%
      filter( AdjPValue < signif_threshold & Log2FC >= logFC_threshold_neg,
              AdjPValue < signif_threshold & Log2FC <= logFC_threshold_pos) %>%
      mutate(CharValue = "grey")
    
    # 3.1.8 4-NOT SIGNIF NA are excluded
    notsignif2 = finaldfpopulated %>% 
      filter( AdjPValue > signif_threshold) %>%
      mutate(CharValue = "grey")
    
    # 3.1.9 5-SUBSET to NA 
    na_data = finaldfpopulated %>% 
      filter(is.na(AdjPValue) | is.na(Log2FC)) %>%
      mutate(CharValue = "grey2")
    
    # 3.2.0 Add Ribosomal
    upperCase_ribos   = mutate( ribosomal, GeneName = toupper(GeneName))  
    subsetData_ribos  = upperCaseDF %>% filter(upcase %in% upperCase_ribos$GeneName)  # dim(58  x 6)
    merge_ribos       = merge.data.frame(subsetData_ribos, upperCase_ribos[,c(1,3)], by.x = "upcase", by.y = "GeneName") # 58  x 7
    combine_oxpho_rib = merge_ribos   # 158   7 | rbind(merge_oxpho, merge_ribos) 
    
    # 3.2.1 Sign_pos_color
    positiv_signif_oxpho_rib = combine_oxpho_rib %>%
      filter( Log2FC > logFC_threshold_pos & AdjPValue < signif_threshold) %>%
      mutate(CharValue = "red")   # dim = 17  8
    
    # 3.2.2 Sign_neg_color
    neg_signif_oxpho_rib = combine_oxpho_rib %>%
      filter( Log2FC < logFC_threshold_neg & AdjPValue < signif_threshold) %>%
      mutate(CharValue = "blue")  # dim 40  8
    
    # 3.2.3 NOT SIGNIF between [-1;+1]
    notsignif1_oxpho_rib = combine_oxpho_rib %>%
      filter( AdjPValue < signif_threshold & Log2FC >= logFC_threshold_neg,
              AdjPValue < signif_threshold & Log2FC <= logFC_threshold_pos) %>%
      mutate(CharValue = "grey") # dim = 35  8
    
    # 3.2.4 NOT SIGNIF NA are excluded
    notsignif2_oxpho_rib = combine_oxpho_rib %>% 
      filter( AdjPValue > signif_threshold) %>%
      mutate(CharValue   = "grey")  # dim = 61  8
    
    # 3.2.5 NAs 
    na_data_oxpho_rib  = combine_oxpho_rib %>% 
      filter(is.na(AdjPValue) | is.na(Log2FC)) %>%
      mutate(CharValue = "grey2")  # dim = 5  8
    
    df_color_oxpho_rib = rbind(positiv_signif_oxpho_rib, neg_signif_oxpho_rib, notsignif1_oxpho_rib, notsignif2_oxpho_rib, na_data_oxpho_rib) # dim = 158  8
    df_color_oxpho_rib = df_color_oxpho_rib[, c(2,3,5,6,4,7,8)]
    
    # 3.2.6 COMBINE ALL filtered data
    df_color = rbind(positiv_signif, neg_signif, notsignif1, notsignif2, na_data) 
    df_color = df_color[, c(1,2,3,4,6,5,7)]  # Note: need process column for crosstalking with plot | 1388    7
    
    all_processes = rbind(df_color_oxpho_rib, df_color)
    # browser()
    
    # 3. RETURN VALUE: 
    return(all_processes)
  }
  
  
  #================================================================================================================
  # 3.0 Input data 
  #================================================================================================================
  # Note: dataframe of this function will have large dimentions as multiple genes may contribute to the same process 
  # DataFrameForMitoProcess
  DataFrameForMitoProcess = reactive({
  # DataFrameForMitoProcess = observe({
    # Ensure that required values are available
    req(DataInputFile())
    req(input$Signif)
    req(input$VerticalThreshold)
    req(input$OrganismSource)
    
    # 3.1.0 Initialise input varibales  
    inputdata  = DataInputFile()        # testdata 1388 5 | ID GeneSymbol Description Log2FC AdjPValue
    
    # specify your location in the script
    print("DataFrameForMitoProcess Reactive:")
    print(input$Signif)
    print(input$VerticalThreshold)
    print(input$OrganismSource)
    print( head(inputdata))
    print("END ---- DataFrameForMitoProcess Reactive: ------")
    print("-------------------------------------------")
    tryCatch ({
      
      if (input$OrganismSource == "Mouse" & is.null(inputdata )) {
        return(NULL)      }
      
      else if (input$OrganismSource == "Mouse" & !is.null(inputdata )) {
      # df_of_all_processes_colors = function(inputdata, refprocess, ribosomal, logFC_threshold_pos, logFC_threshold_neg, signif_threshold)
        df0 = df_of_all_processes_colors(DataInputFile(), 
                                         mm_processes_file, 
                                         mm_ribos_file, 
                                         as.numeric(input$VerticalThreshold),
                                         -(as.numeric(input$VerticalThreshold)),
                                         input$Signif)
        # browser()
        return(df0)}

      else if (input$OrganismSource == "Human" & is.null(inputdata)){    
        return(NULL)}
      
      else if (input$OrganismSource == "Human" & !is.null(inputdata )) {
        # browser()
        df1 = df_of_all_processes_colors(DataInputFile(), 
                                         hs_processes_file, 
                                         hs_ribos_file,
                                         as.numeric(input$VerticalThreshold),
                                         -(as.numeric(input$VerticalThreshold)),
                                         input$Signif)
        
        return(df1)}
    },
    error = function(e) {
      displayErrorMessage("File Loading Error in Data Input File!", 
                          "Check the Help Page for the file input format, column names. /// DataFrameForMitoProcess function", "")}
    )
  })
  
  
  #================================================================================================================
  # 3.5 Get all mito genes present in data 
  #================================================================================================================
  df_mito_processes_inputdata_tohighlight = function(dfmitoprc, refprocess, ribosomal){
    # 0. FUNCTION TASK:
    # This function creates a dataframe with all processes of input data and colors:
    
    # 1. FUNCTION ARGUMENTS:
    # A) dfmitoprc     = DataFrameForMitoProcess()
    # B) refprocess    = mm_processes_file    | hs_processes_file  
    # C) ribosomal     = mm_ribos_file        | hs_ribos_file     
    # browser()
    # 2. FUNCTION BODY: color distribution
    sel_process = dfmitoprc[ toupper(as.character(dfmitoprc$GeneSymbol)) %in% toupper(as.character(refprocess$GeneName)),  ] # 639   7
    ribos   = dfmitoprc[ toupper(as.character(dfmitoprc$GeneSymbol)) %in%  toupper(ribosomal$GeneName),  ]               # 119   7
    df_mt      = rbind(sel_process, ribos) # 951   4   | 
    unique_mt_genes  = df_mt[ !duplicated(df_mt$GeneSymbol), ]  
    
    # 3. RETURN VALUE: 
    return(unique_mt_genes)
  }
  
  
    AllMitoProcesses = reactive({
  # Allmito_processes = observe({
    # Ensure that required values are available
    req(input$OrganismSource)
    req(DataFrameForMitoProcess())
    
    # specify your location in the script
    print("AllMitoProcesses Reactive:")
    print(input$OrganismSource)
    print("END ---- AllMitoProcesses Reactive: -----")
    print("-------------------------------------------")
    tryCatch({
      if (input$OrganismSource == "Mouse"){
        df_with_process_mm = df_mito_processes_inputdata_tohighlight(DataFrameForMitoProcess(), 
                                                           mm_processes_file, 
                                                           mm_ribos_file )
        return(df_with_process_mm)
      }
      else if (input$OrganismSource == "Human"){
        df_with_process_hs = df_mito_processes_inputdata_tohighlight(DataFrameForMitoProcess(), 
                                                                     hs_processes_file, 
                                                                     hs_ribos_file )
        return(df_with_process_hs)  
      }
    },
    error = function(e) {
      displayErrorMessage("File Loading Error in Data Input File!", 
                          "Check the Help Page for the file input format, column names. /// AllMitoProcesses function", "")}
    )
  })
  
  
  #================================================================================================================
  # 3.6 CROSSTALK 
  #================================================================================================================
  DataSharedForMitoProcess = SharedData$new(DataFrameForMitoProcess)
  AllSharedMitoProcesses   = SharedData$new(AllMitoProcesses)


  #================================================================================================================
  # 3.6.0 OUT Display Table
  #================================================================================================================
  output$InputOriginalData3 = renderDT({
    datatable( DataSharedForMitoProcess )}, server = FALSE) 
  
  
  #================================================================================================================
  # 3.6.1 OUT VISUAL
  #================================================================================================================
  ExploreMitoVolcanoStore = reactiveValues()
  
  
  #================================================================================================================
  # 3.7 Highlight all MT genes/proteins OR only specific MT function | persistent 
  # Subset dataset to selected process, Create condition to highlight selected process
  # if padjas < 0.05 and logFC > 1 darker red  | plotCol ffcccc  | ff2f2f
  # if padjas < 0.05 and logFC =1 darker blue  | plotCol 87CEFA  | 087fc8
  # else darker grey                           | plotCol cccccc  | 6a6a6a
  #================================================================================================================
  VolcanoPlot_allmito_plotly = function(inputfile, inputcolordf,plot_color_values, sigval, numrows, logFC_threshold_pos, logFC_threshold_neg, mm_all_data_shared){
    # 0. FUNCTION TASK:
    # This function creates a dataframe with all processes of input data and colors:
    
    # 1. FUNCTION ARGUMENTS:
    # inputfile    = DataInputFile()
    # inputcolordf = DataSharedForMitoProcess
    # sigval                = input$Signif
    # logFC_threshold_pos   = as.numeric(input$VerticalThreshold)
    # logFC_threshold_neg   = -logFC_threshold_pos
    # mm_all_data_shared
    # numrows               = nrow(inputfile)

    # 2. FUNCTION BODY: color distribution
    # GGPLOT
    VolcanoPlot_mm_allmito = ggplot(  data    = inputcolordf,
                                      mapping = aes(x    = Log2FC,
                                                    y    = -log10(AdjPValue),
                                                    text = GeneSymbol)) +
      # Data values
      geom_point( aes( color = as.factor(CharValue) ), show.legend = FALSE ) +
      scale_color_manual( values = plot_color_values) +
      # Axis
      geom_hline( yintercept = -log10(sigval),
                  color      = "#777777",
                  size       = 0.15 ) +
      geom_vline( xintercept = logFC_threshold_pos,
                  color      = "#777777",
                  size       = 0.15 ) +
      geom_vline( xintercept = logFC_threshold_neg,
                  color      = "#777777",
                  size       = 0.15 ) +
      geom_point(data  = mm_all_data_shared,
                 aes(x = Log2FC,
                     y = -log10(AdjPValue)),
                 color = mm_all_data_shared$origData()[,7], size = 1.5) +
      theme_classic() +
      # X axis scale
      scale_x_continuous(breaks = seq( round( min( inputfile$Log2FC, na.rm = T)),
                                       round( max( inputfile$Log2FC, na.rm = T)), 1) )+
      # Y axis scale
      scale_y_continuous(breaks = seq( round( min( -log10(inputfile$AdjPValue), na.rm = T)), 
                                       round( max( -log10(inputfile$AdjPValue), na.rm = T)), 2) )
    
    # 4. PLOTLY
    VolcanoPlot_mm_allmito_plotly = ggplotly( VolcanoPlot_mm_allmito, tooltip = "text") %>%
      highlight(on        = "plotly_click",
                off       = "plotly_doubleclick",
                persistent= F,
                opacityDim= 1,
                selected  = attrs_selected(mode        = "text",
                                           textfont    = list(family = "sans serif", 
                                                              size   = 14, 
                                                              color  = toRGB("#262626")),
                                           textposition= "top right",
                                           marker      = list(symbol = ".crossTalkKey"))) %>%
      layout(showlegend = FALSE,
             autosize   = TRUE,
             yaxis      = list(tickmode = "array", automargin = TRUE ),
             title = list(text = str_interp("Total = ${numrows} variables; Significant Threshold = ${sigval}; Vertical = +/-${as.integer(logFC_threshold_pos)} "),
                          font = list(family = "Arial",
                                      size   = 10),
                          xanchor= "center")
      ) %>%
      config(toImageButtonOptions   = list(filename = "OneMitoProcess",
                                           format = "svg",
                                           width  = 800,
                                           height = 600,
                                           dpi    = 1200),
             modeBarButtonsToRemove = c("lasso2d", "resetScale2d", "toggleSpikelines", "select2d", "pan2d"))
    
    # 3. RETURN VALUE: 
    return(VolcanoPlot_mm_allmito_plotly)
  }
  
  
  HighlightProcess = reactive({
  # HighlightProcess = observe({
    # Ensure that required values are available
    req(input$Signif)
    req(input$VerticalThreshold)
    req(DataInputFile())
    req(DataFrameWithColors())
    req(input$MtProcess)
    
    # specify your location in the script
    print("HighlightProcess Reactive:")
    print(input$Signif)
    print(input$VerticalThreshold)
    print(dim(DataInputFile()))
    print(dim(DataFrameWithColors()))   
    print(input$MtProcess)
    print("END ---- HighlightProcess Reactive: -------")
    print("-------------------------------------------")
    
    # 0 Initialize thresholds
    sigval              = input$Signif
    logFC_threshold_pos = as.numeric(input$VerticalThreshold)
    logFC_threshold_neg = -logFC_threshold_pos
    inputfile           = DataInputFile()
    numrows             = nrow(inputfile)
    plot_color_values   = plot_colour_distrib(DataFrameWithColors())
    
    
    tryCatch(
      if (is.null(inputfile)){
        return(NULL) }
      
      else {
        #################################################################################
        # 1. "Mouse" and "Show All Mitochondrial Genes"
        #################################################################################
        if (input$MtProcess == "Show All Mitochondrial Genes" & input$OrganismSource == "Mouse"){
          # a. Data frame with colors for MT mm
          mm_colors_to_highlight_mt_all = AllSharedMitoProcesses$data() %>%
            mutate(CharValue  = case_when(AdjPValue < sigval & Log2FC > as.numeric(logFC_threshold_pos)      ~ "#ff2f2f",    # red
                                          AdjPValue < sigval & Log2FC < (-1)*as.numeric(logFC_threshold_pos) ~ "#087fc8",    # blue
                                          AdjPValue > sigval & Log2FC > (-1)*as.numeric(logFC_threshold_pos) | Log2FC < as.numeric(logFC_threshold_pos) ~ "#6a6a6a",
                                          AdjPValue > sigval  ~ "#6a6a6a" ))   
          # b. Crosstalking / share
          mm_all_data_shared = SharedData$new(mm_colors_to_highlight_mt_all)
          # c. GGPLOT
          mm_volcano_highlight= VolcanoPlot_allmito_plotly( inputfile, 
                                      DataSharedForMitoProcess, 
                                      plot_color_values, 
                                      sigval, numrows,
                                      logFC_threshold_pos,
                                      logFC_threshold_neg,
                                      mm_all_data_shared)
          return(mm_volcano_highlight)            }

        #################################################################################
        # 3.7.2 "Human" and "Show All Mitochondrial Genes"
        #################################################################################
        else if (input$MtProcess == "Show All Mitochondrial Genes" & input$OrganismSource == "Human"){
          # a- data frame with colors for MT human
          hs_colors_to_highlight_mt_all = AllSharedMitoProcesses$data() %>%
            mutate(CharValue  = case_when(AdjPValue < sigval & Log2FC > as.numeric(logFC_threshold_pos)      ~ "#ff2f2f",    # red
                                          AdjPValue < sigval & Log2FC < (-1)*as.numeric(logFC_threshold_pos) ~ "#087fc8",    # blue
                                          AdjPValue > sigval & Log2FC > (-1)*as.numeric(logFC_threshold_pos) | Log2FC < as.numeric(logFC_threshold_pos) ~ "#6a6a6a",
                                          AdjPValue > sigval  ~ "#6a6a6a" ))   # 467   7
          # b- Crosstalking / share
          hs_all_data_shared = SharedData$new(hs_colors_to_highlight_mt_all)
          # c. GGPLOT
          hs_volcano_highlight= VolcanoPlot_allmito_plotly( inputfile, 
                                                           DataSharedForMitoProcess, 
                                                           plot_color_values, 
                                                           sigval, numrows,
                                                           logFC_threshold_pos,
                                                           logFC_threshold_neg,
                                                           hs_all_data_shared)
          return(hs_volcano_highlight)            }

        #################################################################################
        # 3.7.3 "Mouse" and  seleceted process of interest 
        #################################################################################
        else if (input$MtProcess != "Show All Mitochondrial Genes" & input$OrganismSource == "Mouse"){
          # a. data frame with colors for MT processes mouse
          colors_to_highlight_process = DataSharedForMitoProcess$data() %>%
            filter( Process   == input$MtProcess)     %>%
            mutate(CharValue  = case_when(AdjPValue < sigval & Log2FC > as.numeric(logFC_threshold_pos)      ~ "#ff2f2f",    # red
                                          AdjPValue < sigval & Log2FC < (-1)*as.numeric(logFC_threshold_pos) ~ "#087fc8",    # blue
                                          AdjPValue > sigval & Log2FC > (-1)*as.numeric(logFC_threshold_pos) | Log2FC < as.numeric(logFC_threshold_pos) ~ "#6a6a6a",
                                          AdjPValue > sigval  ~ "#6a6a6a" ))
          # browser()
          # b. crosstalking sharing dataframe with colors
          data_shared_mm_process = SharedData$new(colors_to_highlight_process) 
          # c. GGPLOT
          mm_volcano_highlight_one= VolcanoPlot_allmito_plotly( inputfile, 
                                                            DataSharedForMitoProcess, 
                                                            plot_color_values, 
                                                            sigval, numrows,
                                                            logFC_threshold_pos,
                                                            logFC_threshold_neg,
                                                            data_shared_mm_process)
          return(mm_volcano_highlight_one)            }

        #################################################################################
        # 3.7.4 "Human" and  seleceted process of interest 
        #################################################################################
        else if (input$MtProcess != "Show All Mitochondrial Genes" & input$OrganismSource == "Human"){
          # a. data frame with colors for MT processes mouse
          colors_to_highlight_hs_process = DataSharedForMitoProcess$data() %>%
            filter( Process   == input$MtProcess)     %>%
            mutate(CharValue  = case_when(AdjPValue < sigval & Log2FC > as.numeric(logFC_threshold_pos)      ~ "#ff2f2f",    # red
                                          AdjPValue < sigval & Log2FC < (-1)*as.numeric(logFC_threshold_pos) ~ "#087fc8",    # blue
                                          AdjPValue > sigval & Log2FC > (-1)*as.numeric(logFC_threshold_pos) | Log2FC < as.numeric(logFC_threshold_pos) ~ "#6a6a6a",
                                          AdjPValue > sigval  ~ "#6a6a6a" ))
          # browser()
          # b. crosstalking sharing dataframe with colors
          data_shared_hs_process = SharedData$new(colors_to_highlight_hs_process)
          # c. GGPLOT
          hs_volcano_highlight_one= VolcanoPlot_allmito_plotly( inputfile, 
                                                                DataSharedForMitoProcess, 
                                                                plot_color_values, 
                                                                sigval, numrows,
                                                                logFC_threshold_pos,
                                                                logFC_threshold_neg,
                                                                data_shared_hs_process)
          return(hs_volcano_highlight_one)            }
      },
      error = function(e) {
        displayErrorMessage("File Loading Error in Data Input File!", 
                            "Check the Help Page for the file input format, column names. /// HighlightProcess function", "")}
    )
  })
  
  
  #================================================================================================================
  # 3.7.5 OUTPUT visualization
  #================================================================================================================
  output$VolcanoPlotOutExploreMito = renderPlotly({
    a3 = HighlightProcess()
    Sys.sleep(2)
    hide(id = "loading-content3")    
    a3    })
  
 
  
  
  
  
  
  
  
  
  # ====================================================================
  # ====================================================================
  # ====================================================================
  # 4. HIGHLIGHT MULTIPLE MITO PROCESSES ON THE PLOT
  # ====================================================================
  # ====================================================================
  # ====================================================================
  
  #================================================================================================================
  # 4.1.0 Populates input data with processes, is done based on gene name 
  #================================================================================================================
  DFforMULTIPLEMitoProcesses = function(inputdata, refprocess, ribosomal, logFC_threshold_pos, logFC_threshold_neg, signif_threshold){
    # 0. FUNCTION TASK:
    # This function creates a dataframe with all processes of input data and colors:
    
    # 1. FUNCTION ARGUMENTS:
    # inputdata  = DataInputFile()     
    # refprocess = mm_processes_file     
    # ribosomal  = mm_ribos_file         
    # logFC_threshold_pos =  as.numeric(input$VerticalThreshold)  # logFC_threshold_pos =  1
    # logFC_threshold_neg = -logFC_threshold_pos                  # logFC_threshold_neg = -(logFC_threshold_pos) 
    # signif_threshold    = input$Signif   
    
    # 2. FUNCTION BODY: color distribution
    # 3.1.1 Convert gene symbols in INPUT file to Upper case
    refprocess    = mutate(refprocess, upcase = toupper(GeneName))
    upperCaseDF   = mutate( inputdata, upcase = toupper(GeneSymbol) )   # 1388    6
    
    # 3.1.2 Convert gene symbols in REF file to Upper case 
    processInclud = upperCaseDF %>% filter(upcase %in% toupper(refprocess$GeneName))   # 489   6
    
    # 3.1.3 Merge INPUT and REF file by gene symbol
    mergedataIncl = merge.data.frame(processInclud, refprocess[,c(4,3)], by = "upcase")   # 489   7 #  !!!!MAYBE gene IDS
    mergedataIncl = mergedataIncl[, c(2:7,1)]
    
    processExclud = upperCaseDF %>% filter(!upcase %in% toupper(refprocess$GeneName))   # 899   6
    Process       = rep( 'NA', dim(processExclud)[1])
    excludAddedNA = cbind(processExclud, Process)[, c(1,2,3,4,5,7,6)]  # 899   7 
    
    combined         = rbind(mergedataIncl, excludAddedNA)      # 1388    7
    finaldfpopulated = combined[ , c(1,2,4,5,6,3)][order(combined$Process), ]    # complete input data
    
    # 3.1.5 1-SIGNIF. positive | prot_in$Log2FC > neg_val & prot_in$AdjPValue < input$Signif))] = sign_pos_color
    positiv_signif = finaldfpopulated %>%
      filter( Log2FC > logFC_threshold_pos & AdjPValue < signif_threshold) %>%
      mutate(CharValue = "red")
    
    # 3.1.6 2-SIGNIF. negative | prot_in$Log2FC < -neg_val & prot_in$AdjPValue < input$Signif))] = sign_neg_color
    neg_signif = finaldfpopulated %>%
      filter( Log2FC < logFC_threshold_neg & AdjPValue < signif_threshold) %>%
      mutate(CharValue = "blue")
    
    # 3.1.7 3-NOT SIGNIF between [-1;+1]
    notsignif1 = finaldfpopulated %>%
      filter( AdjPValue < signif_threshold & Log2FC >= logFC_threshold_neg,
              AdjPValue < signif_threshold & Log2FC <= logFC_threshold_pos) %>%
      mutate(CharValue = "grey")
    
    # 3.1.8 4-NOT SIGNIF NA are excluded
    notsignif2 = finaldfpopulated %>% 
      filter( AdjPValue > signif_threshold) %>%
      mutate(CharValue = "grey")
    
    # 3.1.9 5-SUBSET to NA 
    na_data = finaldfpopulated %>% 
      filter(is.na(AdjPValue) | is.na(Log2FC)) %>%
      mutate(CharValue = "grey2")
    
    # 3.2.0 Add Ribosomal
    upperCase_ribos   = mutate( ribosomal, GeneName = toupper(GeneName))  
    subsetData_ribos  = upperCaseDF %>% filter(upcase %in% upperCase_ribos$GeneName)  # dim(58  x 6)
    merge_ribos       = merge.data.frame(subsetData_ribos, upperCase_ribos[,c(1,3)], by.x = "upcase", by.y = "GeneName") # 58  x 7
    combine_oxpho_rib = merge_ribos   # 158   7 | rbind(merge_oxpho, merge_ribos) 
    
    # 3.2.1 Sign_pos_color
    positiv_signif_oxpho_rib = combine_oxpho_rib %>%
      filter( Log2FC > logFC_threshold_pos & AdjPValue < signif_threshold) %>%
      mutate(CharValue = "red")   # dim = 17  8
    
    # 3.2.2 Sign_neg_color
    neg_signif_oxpho_rib = combine_oxpho_rib %>%
      filter( Log2FC < logFC_threshold_neg & AdjPValue < signif_threshold) %>%
      mutate(CharValue = "blue")  # dim 40  8
    
    # 3.2.3 NOT SIGNIF between [-1;+1]
    notsignif1_oxpho_rib = combine_oxpho_rib %>%
      filter( AdjPValue < signif_threshold & Log2FC >= logFC_threshold_neg,
              AdjPValue < signif_threshold & Log2FC <= logFC_threshold_pos) %>%
      mutate(CharValue = "grey") # dim = 35  8
    
    # 3.2.4 NOT SIGNIF NA are excluded
    notsignif2_oxpho_rib = combine_oxpho_rib %>% 
      filter( AdjPValue > signif_threshold) %>%
      mutate(CharValue   = "grey")  # dim = 61  8
    
    # 3.2.5 NAs 
    na_data_oxpho_rib  = combine_oxpho_rib %>% 
      filter(is.na(AdjPValue) | is.na(Log2FC)) %>%
      mutate(CharValue = "grey2")  # dim = 5  8
    
    df_color_oxpho_rib = rbind(positiv_signif_oxpho_rib, neg_signif_oxpho_rib, notsignif1_oxpho_rib, notsignif2_oxpho_rib, na_data_oxpho_rib) # dim = 158  8
    df_color_oxpho_rib = df_color_oxpho_rib[, c(2,3,5,6,4,7,8)]
    
    # 3.2.6 COMBINE ALL filtered data
    df_color = rbind(positiv_signif, neg_signif, notsignif1, notsignif2, na_data) 
    df_color = df_color[, c(1,2,3,4,6,5,7)]  # Note: need process column for crosstalking with plot | 1388    7
    
    all_processes_mm = rbind(df_color_oxpho_rib, df_color)
    # browser()
    
    # 3. RETURN VALUE
    return(all_processes_mm) }
  
  
  
  #================================================================================================================
  # 4.2.0 Populates input data with processes for Mouse or Human  
  #================================================================================================================
  DataFrameForMULTIPLEMitoProcess = reactive({
    # Ensure that required values are available
    req(DataInputFile())
    req(input$Signif)
    req(input$VerticalThreshold)
    req(input$OrganismSource2)
    print("-------------------------------------------------------------------- DataFrameForMultipleMProcesses")

    # 3.1.0 Initialise input varibales  
    # specify your location in the script
    print("DataFrameForMULTIPLEMitoProcess Reactive:")
    print(input$Signif)
    print(input$VerticalThreshold)
    print(input$OrganismSource2)
    print("END ---- DataFrameForMULTIPLEMitoProcess Reactive: ------")   #OrganismSource
    print("-------------------------------------------")          
    
    inputdata           = DataInputFile()
    logFC_threshold_pos =  as.numeric(input$VerticalThreshold)  # logFC_threshold_pos =  1
    logFC_threshold_neg = -logFC_threshold_pos                  # logFC_threshold_neg = -(logFC_threshold_pos) 
    signif_threshold    = input$Signif 
    
    tryCatch ({
      if (input$OrganismSource2 == "Mouse" & is.null(inputdata )) {
        return(NULL)
        }
      else if (input$OrganismSource2 == "Mouse" & !is.null(inputdata )) {
        mult_proc_df_mm = DFforMULTIPLEMitoProcesses(inputdata, mm_processes_file, mm_ribos_file, logFC_threshold_pos, logFC_threshold_neg, signif_threshold)
        # browser()
        return(mult_proc_df_mm)
        }
      else if (input$OrganismSource2 == "Human" & is.null(inputdata)){    
        return(NULL)
        }
      else if (input$OrganismSource2 == "Human" & !is.null(inputdata )) {
        mult_proc_df_hs = DFforMULTIPLEMitoProcesses(inputdata, hs_processes_file, hs_ribos_file, logFC_threshold_pos, logFC_threshold_neg, signif_threshold)
        # browser()
        return(mult_proc_df_hs)
        }
    },
    error = function(e) {
      displayErrorMessage("File Loading Error in Data Input File!", 
                          "Check the Help Page for the file input format, column names. /// DataFrameForMULTIPLEMitoProcess function", "")}
    )
  })
  
  
  
  DataSharedForMULTIPLEMitoProcess = SharedData$new(DataFrameForMULTIPLEMitoProcess)  #DataFrameForMULTIPLEMitoProcess   DataSharedForMitoProcess
  

  
  #============================================================================================================================
  # 4.3.0 selectedMultiplProcesses_df() for mmp_createTabDataFrame(), which subsets input data to selected multiple processes 
  #=============================================================================================================================
  selectedMultiplProcesses_df = function(dfmitoprc, refprocess_file, ribosomal_file, mmpvalues){
    # 0. FUNCTION TASK:
    # Subsets input data to selected multiple processes
    
    # 1. FUNCTION ARGUMENTS:
    # dfmitoprc       = DataFrameForMULTIPLEMitoProcess()
    # refprocess_file = mm_processes_file | hs_processes_file
    # ribosomal_file  = mm_ribos_file     | hs_ribos_file
    # mmpvalues
    
    # 2. FUNCTION BODY:
    process_df = dfmitoprc[ toupper(as.character(dfmitoprc$GeneSymbol)) %in% toupper(as.character(refprocess_file$GeneName)),  ]
    ribos_df   = dfmitoprc[ toupper(as.character(dfmitoprc$GeneSymbol)) %in%  toupper(ribosomal_file$GeneName),  ]        
    mt_df      = rbind(process_df, ribos_df) # 639   7   | #rbind(process, oxpho, ribos)
    selectedMultiplProcesses = mt_df[as.character(mt_df$Process) %in% as.character(mmpvalues$ProcessName), ]
    
    # 3. RETURN VALUE
    return(selectedMultiplProcesses)
    }
  
  
  mmp_createTabDataFrame = function(mmpvalues) {
    # 0. FUNCTION TASK:
    # Return dataframe for mouse or human of selected mutliple processes  

        # 1. FUNCTION ARGUMENTS:
    dfmitoprc     = DataFrameForMULTIPLEMitoProcess()
    refprocess_mm = mm_processes_file    # mm 1495 3       | GeneName Description Process
    ribosomal_mm  = mm_ribos_file        # mm 82   3       | GeneName Description Process
    refprocess_hs = hs_processes_file    # mm 1516    4    | GeneName Description Process
    ribosomal_hs  = hs_ribos_file        # mm 82   3       | GeneName Description Process ribosomal

    # 2. FUNCTION BODY:
    tryCatch({
      # Mouse
      if (input$OrganismSource2 == "Mouse"){
        mult_proces_for_mm= selectedMultiplProcesses_df(dfmitoprc, refprocess_mm, ribosomal_mm, mmpvalues)
        # browser()
    # 3. RETURN VALUE
        return(mult_proces_for_mm)}

      # Human
      else if (input$OrganismSource2 == "Human"){
        mult_proces_for_hs= selectedMultiplProcesses_df(dfmitoprc, refprocess_hs, ribosomal_hs, mmpvalues)
    # 3. RETURN VALUE
        return(mult_proces_for_hs)}
    },
    error = function(e) {
      displayErrorMessage("File Loading Error in Data Input File!",
                          "Select organism. /// mmp_createTabDataFrame function", "")}
    )}
  
  
  
  
  
  #================================================================================================================
  # 4.4.0 Legend 
  #================================================================================================================
  mmp_create_plot_legend = function(mmpvalues) {
    if (input$OrganismSource2 == "Mouse"){

      # a- Subset df to selected MULTIPLE processes | 88x7 |
      # NOTE: some selecetd processes may be not present in the data
      # multiprocess_df_mm = DataFrameForMULTIPLEMitoProcess()[ as.character(DataFrameForMULTIPLEMitoProcess()$Process) %in% as.character(mmpvalues$ProcessName), ]
      # NOTE: remove genes with logFC or PAdjust =NA
      multiprocess_df_no_na = na.omit(DataFrameForMULTIPLEMitoProcess(), na.omit("Log2FC","AdjPValue"))
      multiprocess_df_mm = multiprocess_df_no_na[ as.character(multiprocess_df_no_na$Process) %in% as.character(mmpvalues$ProcessName), ]
      
      # b- Factors with the same levels before merging
      # Merge getMMPValuesSelected() with input data frame that conatins same processes, and distribute colours
      combined_fact_mm  = sort( union( levels(multiprocess_df_mm$Process), levels(mmpvalues$ProcessName)))
      colors_to_highlight_mm_multiple_process = inner_join(mutate(multiprocess_df_mm, Process = factor(Process, levels = combined_fact_mm)),
                                                           mutate(mmpvalues, ProcessName = factor(ProcessName, levels = combined_fact_mm)),
                                                           by = c("Process"="ProcessName"))       # dim(colors_to_highlight_mm_multiple_process)  # 44 x 8
      colors_to_highlight_mm_multiple_process = colors_to_highlight_mm_multiple_process[, c(1,2,3,4,5,6,7,12)]
      colors_to_highlight_mm_multiple_process = as.data.frame(colors_to_highlight_mm_multiple_process, stringsAsFactors=FALSE)
      # c- validate number of selecetd multiple processes in input data | unique
      # NOTE: to enable same color selection for multiple processes "unique()" cant be used for creating color vector
      uniq_processes_df = colors_to_highlight_mm_multiple_process[!duplicated(colors_to_highlight_mm_multiple_process$Process), ]
      uniq_sel_col  = as.character(uniq_processes_df$ColValue)
      
      
      # # selected processes data frame
      # dim(uniq_processes_df)
      sel_pr_col_df = data.frame(
        shape_names = rep("circle filled",  length(uniq_processes_df$Process)),
        yourtext    = as.character(uniq_processes_df$Process),
        y           = rep(1, length(uniq_processes_df$Process)),
        color       = as.character(uniq_processes_df$ColValue),
        stringsAsFactors = FALSE)
      sel_pr_col_df$yourtext = factor(sel_pr_col_df$yourtext, levels = sel_pr_col_df$yourtext)
      
      leg = ggplot(sel_pr_col_df, aes(y=yourtext, x=1, label=yourtext)) +
        geom_point(stat='identity', aes(col=yourtext), show.legend = T, size=2) +
        scale_color_manual(name= "Selected Processes", labels = sel_pr_col_df$yourtext, values = sel_pr_col_df$color) +
        #coord_flip() +
        # ylim(0.99,1.9)+
        xlim(0.99,1.9)+
        expand_limits(y = c(0, 40))+
        # remove background, axis, ticks etc
        theme (panel.background = element_rect(fill = "white"), 
               axis.text.x  =element_blank(),
               axis.title.y =element_blank(),
               axis.title.x =element_blank(),
               axis.ticks.y =element_blank(),
               axis.ticks.x =element_blank(),
               #legend.position = "none"
        )
      browser()
      # legend_plotly = ggplotly(leg, tooltip =NULL) %>%
      #   layout(legend = list(showlegend = TRUE, orientation = "h"))
      #subplot(legend_plotly, VolcanoPlot_mm_mult_process_plotly, nrows = 2)
      legend = get_legend(leg)
      grid.newpage()
      grid.draw(legend)
      #grid.draw(legend)
     # as_ggplot(legend) # https://rpkgs.datanovia.com/ggpubr/reference/get_legend.html
      
      # plot_grid(NULL, legend, ncol=1)
      # browser()
      #a=ggdraw(plot_grid(VolcanoPlot_mm_mult_process, legend, ncol=1))
      
      # g_legend <- function(a.gplot){ 
      #   tmp <- ggplot_gtable(ggplot_build(a.gplot)) 
      #   leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box") 
      #   legend <- tmp$grobs[[leg]] 
      #   legend
      # } 
      # 
      # legend = g_legend(my_hist)
      # grid.newpage()
      # grid.draw(legend) 
      
    # return(grid.draw(legend))
      return(NULL)
    }

  else{

    multiprocess_df_no_na = na.omit(DataFrameForMULTIPLEMitoProcess(), na.omit("Log2FC","AdjPValue"))
    multiprocess_df_mm = multiprocess_df_no_na[ as.character(multiprocess_df_no_na$Process) %in% as.character(mmpvalues$ProcessName), ]

    # b- Factors with the same levels before merging
    # Merge getMMPValuesSelected() with input data frame that conatins same processes, and distribute colours
    combined_fact_mm  = sort( union( levels(multiprocess_df_mm$Process), levels(mmpvalues$ProcessName)))
    colors_to_highlight_mm_multiple_process = inner_join(mutate(multiprocess_df_mm, Process = factor(Process, levels = combined_fact_mm)),
                                                         mutate(mmpvalues, ProcessName = factor(ProcessName, levels = combined_fact_mm)),
                                                         by = c("Process"="ProcessName"))       # dim(colors_to_highlight_mm_multiple_process)  # 44 x 8
    colors_to_highlight_mm_multiple_process = colors_to_highlight_mm_multiple_process[, c(1,2,3,4,5,6,7,12)]
    colors_to_highlight_mm_multiple_process = as.data.frame(colors_to_highlight_mm_multiple_process, stringsAsFactors=FALSE)
    # c- validate number of selecetd multiple processes in input data | unique
    # NOTE: to enable same color selection for multiple processes "unique()" cant be used for creating color vector
    uniq_processes_df = colors_to_highlight_mm_multiple_process[!duplicated(colors_to_highlight_mm_multiple_process$Process), ]
    uniq_sel_col  = as.character(uniq_processes_df$ColValue)

    # # selected processes data frame
    # dim(uniq_processes_df)
    sel_pr_col_df = data.frame(
      shape_names = rep("circle filled",  length(uniq_processes_df$Process)),
      yourtext    = uniq_processes_df$Process,
      y           = rep(1, length(uniq_processes_df$Process)),
      color       = uniq_processes_df$ColValue,
      stringsAsFactors = FALSE)
    sel_pr_col_df$yourtext = factor(sel_pr_col_df$yourtext, levels = sel_pr_col_df$yourtext)


    # Make LEGEND with ggplot
    legendplot = ggplot(sel_pr_col_df,
                        aes(x    = -log10(y),
                            y    = yourtext,
                            color= yourtext)) +
      geom_point( size=3,
                  show.legend = T)+
      scale_colour_manual(name   = "Selected Processes",
                          values = as.vector(sel_pr_col_df$color),  # DO NOT USE UNIQUE()
                          labels = as.vector(sel_pr_col_df$yourtext)
      ) +
      theme_void()+
      theme(legend.title =element_text(size=12),
            legend.text  =element_text(size=12),
            #legend.position  = "left",
            legend.direction ="vertical",
            legend.justification = c(1,0),
            legend.position = c(0.95, 0.02))

    legendplotly = ggplotly( legendplot, tooltip = "text") %>%
      config(toImageButtonOptions   = list(filename = "Legend_PlotMultipleProcesses_hs",
                                           format = "svg",
                                           width  = 800,
                                           height = 600,
                                           dpi    = 1200),
             modeBarButtonsToRemove = c("lasso2d", "resetScale2d", "toggleSpikelines", "select2d", "pan2d"))

    return(legendplotly)
  }
  }
  
  
  
  
  #================================================================================================================
  # 4.5.0 Highlight Multiple Processes 
  #================================================================================================================
  
  mmp_create_plot_processes_highlighted = function(mmpvalues) {
    # 0. FUNCTION TASK:
    # Creates a plot with selected mutliple processes

    # specify your location in the script
    print("mmp_create_plot_processes_highlighted():")
    print(input$Signif)
    print(input$VerticalThreshold)
    print("END ---- mmp_create_plot_processes_highlighted(): -------")
    print("-------------------------------------------")
    
    # 1. FUNCTION ARGUMENTS:
    sigval                = input$Signif
    logFC_threshold_pos   = as.numeric(input$VerticalThreshold)
    logFC_threshold_neg   = -logFC_threshold_pos
    inputfile             = DataInputFile()
    numrows               = nrow(inputfile)
    yaxis = list(tickmode = "array", automargin = TRUE )
    tex   = list(family   = "sans serif", 
                 size     = 14, 
                 color    = toRGB("#262626"))
    # Colour distribution
    plot_color_values = plot_colour_distrib(DataFrameWithColors()) 

    # 2. FUNCTION BODY:
    tryCatch({
      if (is.null(inputfile)){
        return(NULL) }
      
      else {
        #################################################################################
        # 1. "Mouse" and multiple processes
        #################################################################################
        if (input$OrganismSource2 == "Mouse"){    
          # a- Subset df to selected MULTIPLE processes | 88x7 |
          # NOTE: some selected processes may be not present in the data
          multiprocess_df_mm = DataSharedForMULTIPLEMitoProcess$data()[ as.character(DataSharedForMULTIPLEMitoProcess$data()$Process) %in% as.character(mmpvalues$ProcessName), ]
          
          # b- Factors with the same levels before merging
          # Merge getMMPValuesSelected() with input data frame that conatins same processes, and distribute colours
          combined_fact_mm  = sort( union( levels(multiprocess_df_mm$Process), levels(mmpvalues$ProcessName)))
          colors_to_highlight_mm_multiple_process = inner_join(mutate(multiprocess_df_mm, 
                                                                      Process = factor(Process, 
                                                                                       levels = combined_fact_mm)),
                                                               mutate(mmpvalues, 
                                                                      ProcessName = factor(ProcessName, 
                                                                                           levels = combined_fact_mm)),
                                                               by = c("Process"="ProcessName"))       # dim(colors_to_highlight_mm_multiple_process)  # 44 x 8
          colors_to_highlight_mm_multiple_process = colors_to_highlight_mm_multiple_process[, c(1,2,3,4,5,6,7,12)]
          colors_to_highlight_mm_multiple_process = as.data.frame(colors_to_highlight_mm_multiple_process, stringsAsFactors=FALSE)
          # c- validate number of selecetd multiple processes in input data | unique 
          # NOTE: to enable same color selection for multiple processes "unique()" cant be used for creating color vector
          # NOTE: DONOT use UNIQUE(), as same colors can\t be displayed
          uniq_processes_df = colors_to_highlight_mm_multiple_process[!duplicated(colors_to_highlight_mm_multiple_process$Process), ]
          uniq_sel_col  = as.character(uniq_processes_df$ColValue)
          
          # d- Subset to df that has no matched values
          no_match_multi_process_df =  DataSharedForMULTIPLEMitoProcess$data()[! as.character(DataSharedForMULTIPLEMitoProcess$data()$Process) %in% as.character(mmpvalues$ProcessName), ]
          no_match_multi_process_df$ColValue = no_match_multi_process_df$CharValue   # add dummy color column for equal amount of columns (for rbind())
          
          # e - Assemble DFs with all required values
          final_df_mm =rbind(no_match_multi_process_df, colors_to_highlight_mm_multiple_process)
          
          # f- Replace red/blue/grey colour with HEX encoding, less intense colour
          final_df_mm$ColValue[final_df_mm$ColValue == "red"]   = "#ffcccc"
          final_df_mm$ColValue[final_df_mm$ColValue == "blue"]  = "#9fd8fb"
          final_df_mm$ColValue[final_df_mm$ColValue == "grey2"] = "#cccccc"
          final_df_mm$ColValue[final_df_mm$ColValue == "grey"]  = "#cccccc"
          final_df_mm = as.data.frame(final_df_mm, stringsAsFactors=FALSE)
          # dim(final_df_mm)   
          #as.vector(unique(final_df_mm$col))
          
          # g- crosstalking sharing dataframe with colors
          data_shared_mm_mult_process = SharedData$new(final_df_mm)  #works but only for highlighted dots
          # browser()
          
          
          value_key_for_legend = factor(uniq_processes_df$Process)
          color_key_for_legend = as.vector(uniq_processes_df$ColValue)

          # 
          data_shared_subset_to_selected_proc_df = SharedData$new(multiprocess_df_mm)
         
          VolcanoPlot_mm_mult_process = ggplot(  data    = data_shared_mm_mult_process,
                                                 mapping = aes(x    = Log2FC,
                                                               y    = -log10(AdjPValue),
                                                               text = GeneSymbol)) +
            # Colour all selected processes and data values correctly
            geom_point(color = data_shared_mm_mult_process$origData()[,8],
                       size  = 1.5) +
            # Axis
            geom_hline( yintercept = -log10(sigval),
                        color      = "#777777",
                        size       = 0.15 ) +
            geom_vline( xintercept = logFC_threshold_pos,
                        color      = "#777777",
                        size       = 0.15 ) +
            geom_vline( xintercept = logFC_threshold_neg,
                        color      = "#777777",
                        size       = 0.15 ) +
            # Plot background
            theme_classic() +
            # X axis scaling
            scale_x_continuous(breaks = seq( round( min( inputfile$Log2FC, na.rm = T)),
                                             round( max( inputfile$Log2FC, na.rm = T)), 1) )+
            # Y axis scale
            scale_y_continuous(breaks = seq( round( min( -log10(inputfile$AdjPValue), na.rm = T)),
                                             round( max( -log10(inputfile$AdjPValue), na.rm = T)), 2) )

          ExploreMitoVolcanoStore$image1 = VolcanoPlot_mm_mult_process
          # browser()
          # h- PLOTLY | Plotly webpage apperance
          VolcanoPlot_mm_mult_process_plotly = ggplotly( VolcanoPlot_mm_mult_process, tooltip = "text") %>%
            highlight(on         = "plotly_click",
                      off        = "plotly_doubleclick",
                      persistent = T,
                      opacityDim = 1,
                      selected   = attrs_selected(mode         = "text",
                                                  textfont     = tex,
                                                  textposition = "top right",
                                                  marker = list(symbol = ".crossTalkKey"))) %>%
            layout(showlegend = FALSE,
                   autosize   = TRUE,
                   yaxis      = yaxis,
                   title = list(text = str_interp("Total = ${numrows} variables; Significant Threshold = ${sigval}; Vertical = +/-${as.integer(logFC_threshold_pos)} "),
                                font = list(family = "Arial",
                                            size   = 10),
                                xanchor= "center")
            ) %>%
            config(toImageButtonOptions   = list(filename = "PlotMultipleProcesses_mm",
                                                 format = "svg",
                                                 width  = 800,
                                                 height = 600,
                                                 dpi    = 1200),
                   modeBarButtonsToRemove = c("lasso2d", "resetScale2d", "toggleSpikelines", "select2d", "pan2d"))
          
          return(VolcanoPlot_mm_mult_process_plotly)
          }
          
        #################################################################################
        # 1. "Human" and multiple processes
        #################################################################################
        else if (input$OrganismSource2 == "Human"){     #else if (input$OrganismSource2 == "Human"){
          
          # a- Subset df to selected MULTIPLE processes | 88x7 |
          # NOTE: some selecetd processes may be not present in the data
          # mmpvalues <- getMMP valeus needs to be replaced!!!!! getMMPValuesSelected()
          multiprocess_df_hs = DataSharedForMULTIPLEMitoProcess$data()[ as.character(DataSharedForMULTIPLEMitoProcess$data()$Process) %in% as.character(mmpvalues$ProcessName), ]
          
          # b- Factors with the same levels before merging
          # Merge getMMPValuesSelected() with input data frame that conatins same processes, and distribute colours
          combined_fact_hs  = sort( union( levels(multiprocess_df_hs$Process), levels(mmpvalues$ProcessName)))
          colors_to_highlight_hs_multiple_process = inner_join(mutate(multiprocess_df_hs, Process = factor(Process, levels = combined_fact_hs)),
                                                               mutate(mmpvalues, ProcessName = factor(ProcessName, levels = combined_fact_hs)),
                                                               by = c("Process"="ProcessName"))       # dim(colors_to_highlight_hs_multiple_process)  # 44 x 8
          colors_to_highlight_hs_multiple_process = colors_to_highlight_hs_multiple_process[, c(1,2,3,4,5,6,7,12)]
          colors_to_highlight_hs_multiple_process = as.data.frame(colors_to_highlight_hs_multiple_process, stringsAsFactors=FALSE)
          # c- validate number of selecetd multiple processes in input data | unique 
          # NOTE: to enable same color selection for multiple processes "unique()" cant be used for creating color vector
          uniq_processes_df_hs = colors_to_highlight_hs_multiple_process[!duplicated(colors_to_highlight_hs_multiple_process$Process), ]
          uniq_sel_col_hs  = as.character(uniq_processes_df_hs$ColValue)
          
          # d- Subset to df that has no matched values
          no_match_multi_process_df =  DataSharedForMULTIPLEMitoProcess$data()[! as.character(DataSharedForMULTIPLEMitoProcess$data()$Process) %in% as.character(mmpvalues$ProcessName), ]
          no_match_multi_process_df$ColValue = no_match_multi_process_df$CharValue   # add dummy color column for equal amount of columns (for rbind())
          
          # e - Assemble DFs with all required values
          final_df_hs =rbind(no_match_multi_process_df, colors_to_highlight_hs_multiple_process)
          
          # f- Replace red/blue/grey colour with HEX encoding, less intense colour
          final_df_hs$ColValue[final_df_hs$ColValue == "red"]   = "#ffcccc"
          final_df_hs$ColValue[final_df_hs$ColValue == "blue"]  = "#9fd8fb"
          final_df_hs$ColValue[final_df_hs$ColValue == "grey2"] = "#cccccc"
          final_df_hs$ColValue[final_df_hs$ColValue == "grey"]  = "#cccccc"
          final_df_hs = as.data.frame(final_df_hs, stringsAsFactors=FALSE)
          # dim(final_df_hs)   # 1447  x  8
          #as.vector(unique(final_df_hs$col))
          
          # g- crosstalking sharing dataframe with colors
          data_shared_hs_mult_process = SharedData$new(final_df_hs)  #works but only for highlighted dots
          
          
          VolcanoPlot_hs_mult_process = ggplot(  data    = data_shared_hs_mult_process,
                                                 mapping = aes(x    = Log2FC,
                                                               y    = -log10(AdjPValue),
                                                               text = GeneSymbol)) +
            # Colour all selected processes and data values correctly
            geom_point(color = data_shared_hs_mult_process$origData()[,8],
                       size  = 1.5) +
            # Axis
            geom_hline( yintercept = -log10(sigval),
                        color      = "#777777",
                        size       = 0.15 ) +
            geom_vline( xintercept = logFC_threshold_pos,
                        color      = "#777777",
                        size       = 0.15 ) +
            geom_vline( xintercept = logFC_threshold_neg,
                        color      = "#777777",
                        size       = 0.15 ) +
            # Plot background
            theme_classic() +
            # X axis scaling
            scale_x_continuous(breaks = seq( round( min( inputfile$Log2FC, na.rm = T)),
                                             round( max( inputfile$Log2FC, na.rm = T)), 1) )+
            # Y axis scale
            scale_y_continuous(breaks = seq( round( min( -log10(inputfile$AdjPValue), na.rm = T)),
                                             round( max( -log10(inputfile$AdjPValue), na.rm = T)), 2) )
          
          
          ExploreMitoVolcanoStore$image1 = VolcanoPlot_hs_mult_process
          # browser()
          
          # h- PLOTLY | Plotly webpage apperance
          VolcanoPlot_hs_mult_process_plotly = ggplotly( VolcanoPlot_hs_mult_process, tooltip = "text") %>%
            highlight(on         = "plotly_click",
                      off        = "plotly_doubleclick", 
                      persistent = T,      
                      opacityDim = 1, 
                      selected   = attrs_selected(mode         = "text", 
                                                  textfont     = tex, 
                                                  textposition = "top right",
                                                  marker = list(symbol = ".crossTalkKey"))) %>%
            layout(showlegend = FALSE,
                   autosize   = TRUE,
                   yaxis      = yaxis,
                   title = list(text = str_interp("Total = ${numrows} variables; Significant Threshold = ${sigval}; Vertical = +/-${as.integer(logFC_threshold_pos)} "),
                                font = list(family = "Arial",
                                            size   = 10),
                                xanchor= "center")
            ) %>% 
            config(toImageButtonOptions   = list(filename = "PlotMultipleProcesses_hs",
                                                 format = "svg", 
                                                 width  = 800, 
                                                 height = 600, 
                                                 dpi    = 1200),
                   modeBarButtonsToRemove = c("lasso2d", "resetScale2d", "toggleSpikelines", "select2d", "pan2d"))
          # browser()
          return(VolcanoPlot_hs_mult_process_plotly)}
      }
    },
    error = function(e) {
      displayErrorMessage("Data Input Error!", 
                          "Check the Help Page for the file input format, column names. /// mmp_create_plot_processes_highlighted() function", "")}
    )}
  
  
  
  
  
  observeEvent(input$UI_MMP_LIST_ACTION, {
    if (DEBUGGING_MODE) {
      Sys.time()
      print("ActionButtonSelectedProcCol()")
    }
    mmpvalues = getMMPValuesSelected()
    SelectedMultProcCol = mmp_createTabDataFrame(mmpvalues)
    output$ProcessesDataSubsetMult4 = renderDT(SelectedMultProcCol)
    output$VolcanoPlotOutMultipleProcessesMito = renderPlotly(mmp_create_plot_processes_highlighted(mmpvalues))
    output$VolcanoPlotOutMultipleProcessesMitoLEGEND= renderPlotly(mmp_create_plot_legend(mmpvalues))
  })
  
  
  
  # output$VolcanoPlotOutMultipleProcessesMito = renderPlotly({
     #ActionButtonSelectedProcCol()
  #   # a4 = HighlightMultipleProcess()
  #   a4 = mmp_create_plot_processes_highlighted()
  #   Sys.sleep(2)
  #   hide(id = "loading-content4")
  #   a4
  # })
  

  

  # 4.1.1. Subset of mutliple processes Tab under Mutliple processes Plot
#  output$ProcessesDataSubsetMult4 = renderDT({
#    ActionButtonSelectedProcCol() })
  
  # 4.1.2. InputData Tab under Mutliple processes Plot 
  output$InputOriginalDataMult4 = renderDT({
    datatable(DataSharedForMULTIPLEMitoProcess )}, server = FALSE) 
  
  

  
  

  
  
  
  ###############################################

  ###############################################
  
  
  #================================================================================================================
  # 4.3.0 OUTPUT HIGHLIGHTED SELECTED MULTIPLE PROCESSES 
  #================================================================================================================  

  

  
  

  
  
  
  
  
  # ====================================================================
  # ====================================================================
  # ====================================================================
  # 5. CELLULAR COMPARTMENT LOCALIZATION
  # ====================================================================
  # ====================================================================
  # ====================================================================
  
  # Created data frame that contains infomation of genes and related cellular compartment name
  DataFrameForCellularCompartLocaliz = reactive({
  # DataFrameForCellularCompartLocaliz = observe({
    # Ensure that required values are available
    req(DataInputFile())
    req(input$Signif)
    req(input$VerticalThreshold)
    print("-------------------------------------------------------------------- DataFrameForCellularCompartLocaliz")
    #input$UI_MMP_LIST_ACTION
    # 3.1.0 Initialise input varibales  
    inputdata  = DataInputFile()        # testdata 1388 5 | ID GeneSymbol Description Log2FC AdjPValue
    refcellularcompartloc = list_of_cellular_values     # mm 1495 3       | 
    print("DataFrameForCellularCompartLocaliz")
    
    # specify your location in the script
    print("DataFrameForCellularCompartLocaliz Reactive:")
    print(input$Signif)
    print(input$VerticalThreshold)
    print( head(inputdata))
    print("END ---- DataFrameForCellularCompartLocaliz Reactive: ------")   #OrganismSource
    print("-------------------------------------------")
    
    tryCatch ({
      
      if (!is.null(inputdata) & (input$CellularLocal %in% unlist(name_list_of_cellular_values))){
        # browser()
        # 5.1.1 Convert data frame gene names to upper case | upperCaseDF   = mutate( inputdata, upcase = toupper(GeneSymbol) )   
        inputdata_upper = mutate( inputdata, upcase = toupper(GeneSymbol) )
            
        # 5.1.1 Get a vector of gene names for selected cellular compartment of interest, subset to input data  
        # 1. Get position of the selecetd term
        term_ind = as.numeric(grep(input$CellularLocal, unlist(name_list_of_cellular_values)))
        # Name in a list 
        term_name_inlist = names(refcellularcompartloc)[term_ind]               # "Actin"
        # GET GENS stored in selecetd term
        genes_per_term = toupper( as.character(refcellularcompartloc[[term_ind]]))
        # subset input data to genes of selecetd term of cellular compartment
        subset_input_to_cellularcompart = inputdata_upper[ as.character(inputdata_upper$upcase) %in% as.character(genes_per_term), ]
        # dim(subset_input_to_cellularcompart)   # 28x6
        
        cellular_term = rep(input$CellularLocal, length(subset_input_to_cellularcompart$GeneSymbol))
        subset_input_to_cellularcompart$CellularTerm = cellular_term
        
        # browser()
        return(subset_input_to_cellularcompart[, c(1,2,3,4,5,7)])
      }
      
      else{
        return(NULL)
      }
      },
    error = function(e) {
      displayErrorMessage("File Loading Error in Data Input File!", 
                          "Check the Help Page for the file input format, column names. /// DataFrameForCellularCompartLocaliz function", "")}
    )
})

# 5.1.1. Selected cellular compartment
output$ProcessesDataSubsetMult5 = renderDT({
  DataFrameForCellularCompartLocaliz()
  })  # not developed yet
  
# 5.1.2. InputData Tab under Cellular Compartment Plot
output$InputOriginalDataMult5 = renderDT({
  datatable(DataSharedForMULTIPLEMitoProcess )}, server = FALSE) 






######################################################
HighlightCellularLocalization = reactive({
  # HighlightCellularLocalization = observe({
  # Ensure that required values are available
  req(input$Signif)
  req(input$VerticalThreshold)
  req(DataInputFile())
  req(DataFrameWithColors())
  req(input$CellularLocal)
  
  # specify your location in the script
  print("HighlightCellularLocalization Reactive:")
  print(input$Signif)
  print(input$VerticalThreshold)
  print(dim(DataInputFile()))
  print(dim(DataFrameWithColors()))   
  print(input$CellularLocal)
  print("END ---- HighlightCellularLocalization Reactive: -------")
  print("-------------------------------------------")
  
  # 0 Initialise thresholds
  sigval                = input$Signif
  logFC_threshold_pos   = as.numeric(input$VerticalThreshold)
  logFC_threshold_neg   = -logFC_threshold_pos
  inputdata             = DataInputFile()
  numrows               = nrow(inputdata)
  yaxis = list(tickmode = "array", automargin = TRUE )
  tex   = list(family   = "sans serif", 
               size     = 14, 
               color    = toRGB("#262626"))
  # Color distribution
  plot_color_values = plot_colour_distrib(DataFrameWithColors())
  
  tryCatch(
      if (!is.null(inputdata) & (input$CellularLocal %in% unlist(name_list_of_cellular_values)) ){
        # browser()
        # a- data frame with colors for MT mm
        hs_colors_to_highlight_cellular = DataFrameForCellularCompartLocaliz() %>%
          mutate(CharValue  = case_when(AdjPValue < input$Signif & Log2FC > as.numeric(input$VerticalThreshold)      ~ "#ff2f2f",    # red
                                        AdjPValue < input$Signif & Log2FC < (-1)*as.numeric(input$VerticalThreshold) ~ "#087fc8",    # blue
                                        AdjPValue > input$Signif & Log2FC > (-1)*as.numeric(input$VerticalThreshold) | Log2FC < as.numeric(input$VerticalThreshold) ~ "#6a6a6a",
                                        AdjPValue > input$Signif  ~ "#6a6a6a" ))   # 28x7
        # 2. Crosstalking / share
        hs_all_data_shared_cellular = SharedData$new(hs_colors_to_highlight_cellular)
        
        # 3. GGPLOT
        VolcanoPlot_hs_cellularLocal = ggplot(  data    = DataSharedForMitoProcess,
                                          mapping = aes(x    = Log2FC,
                                                        y    = -log10(AdjPValue),
                                                        text = GeneSymbol)) +
          # Data values
          geom_point( aes( color = as.factor(CharValue) ), show.legend = FALSE ) +
          scale_color_manual( values = plot_color_values) +
          # Axis
          geom_hline( yintercept = -log10(sigval),
                      color      = "#777777",
                      size       = 0.15 ) +
          geom_vline( xintercept = logFC_threshold_pos,
                      color      = "#777777",
                      size       = 0.15 ) +
          geom_vline( xintercept = logFC_threshold_neg,
                      color      = "#777777",
                      size       = 0.15 ) +
          geom_point(data  = hs_all_data_shared_cellular,
                     aes(x = Log2FC,
                         y = -log10(AdjPValue)),
                     color = hs_all_data_shared_cellular$origData()[,7], size = 1.5) +
          theme_classic() +
          # X axis scale
          scale_x_continuous(breaks = seq( round( min( inputdata$Log2FC, na.rm = T)),
                                           round( max( inputdata$Log2FC, na.rm = T)), 1) )+
          # Y axis scale
          scale_y_continuous(breaks = seq( round( min( -log10(inputdata$AdjPValue), na.rm = T)), 
                                           round( max( -log10(inputdata$AdjPValue), na.rm = T)), 2) )
        # labs( title ="Volcano Plot",
        #       caption = str_interp("Total = ${numrows} variables; Significant Threshold = ${sigval}; Vertical = +/-${as.integer(logFC_threshold_pos)} "))
        
        # 4. PLOTLY
        VolcanoPlot_hs_cellLoc_plotly = ggplotly( VolcanoPlot_hs_cellularLocal, tooltip = "text") %>%
          highlight(on        = "plotly_click",
                    off       = "plotly_doubleclick",
                    persistent= F,
                    opacityDim= 1,
                    selected  = attrs_selected(mode        = "text",
                                               textfont    = tex,
                                               textposition= "top right",
                                               marker      = list(symbol = ".crossTalkKey"))) %>%
          layout(showlegend = FALSE,
                 autosize   = TRUE,
                 yaxis      = yaxis,
                 title = list(text = str_interp("Total = ${numrows} variables; Significant Threshold = ${sigval}; Vertical = +/-${as.integer(logFC_threshold_pos)} "),
                              font = list(family = "Arial",
                                          size   = 10),
                              xanchor= "center")
          ) %>%
          config(toImageButtonOptions   = list(filename = "CellularLocalization_hs",
                                               format = "svg",
                                               width  = 800,
                                               height = 600,
                                               dpi    = 1200),
                 modeBarButtonsToRemove = c("lasso2d", "resetScale2d", "toggleSpikelines", "select2d", "pan2d"))
        
        return(VolcanoPlot_hs_cellLoc_plotly) 
      }
      else{
        return(NULL)
      },

    error = function(e) {
      displayErrorMessage("File Loading Error in Data Input File!", 
                          "Check the Help Page for the file input format, column names. /// HighlightCellularLocalization function", "")}
  )
})

  #================================================================================================================
  # 5 OUTPUT HIGHLIGHTED CELLULAR LOCALIZATION
  #================================================================================================================  
output$CellularCompartmentLocalPlot = renderPlotly({
  a5 = HighlightCellularLocalization()
  Sys.sleep(2)
  hide(id = "loading-content5")
  a5    })

  

  
  
  
  
  
  
  
  
  
  
  
  
  
  # ====================================================================
  # ====================================================================
  # ====================================================================
  # 5. VISUALIZE (Custom Tab) | visualize labels of genes of interest 
  # ====================================================================
  # ====================================================================
  # ====================================================================
  
  
  #================================================================================================================
  # 5.0.0 Reactive values for plot
  #================================================================================================================
  CustomVolcanoPlotStore = reactiveValues()
  
  
  #================================================================================================================
  # 5.1.0 User input file with custom list
  #================================================================================================================
  CustomDataFile = reactive({
 # CustomDataFile = observe({
    inFile       = input$UserGeneNamesFile
    tryCatch({
      # no file
      if (is.null(inFile)){
        return(NULL) }
      # loaded file
      else{
        cust_file = read.table(input$UserGeneNamesFile$datapath, header = F, sep = "\t", quote = "")   # /
        # browser()
        # check if file has more than one column
        if (dim(cust_file)[2]>1){
          return(NULL)
        }
        else{
          return(cust_file)
        }
        }
      },
      error = function(e) {
        displayErrorMessage("File Loading Error in Custom Data Input File!", 
                            "Check the Help Page for the custom file input format, each gene name is on own row. /// CustomDataFile function", "")}
    )
  })
  
  
  #================================================================================================================
  # 5.2.0 PROVIDE OWN LIST OF GENES TO BE VISUALIZED ON THE PLOT
  #================================================================================================================
  CustomListOfInterest = reactive({
    # CustomListOfInterest = observe({
    # Ensure that required values are available
    req(input$Signif)
    req(input$VerticalThreshold)
    req(DataInputFile())
    
    # Specify your location in the script
    print("CustomListOfInterest Reactive:")
    print(input$Signif)
    print(input$VerticalThreshold)
    print("END ---- CustomListOfInterest Reactive: ------")
    print("-------------------------------------------")
    
    dfinput     = DataInputFile()
    custominputfile =  CustomDataFile()
    sigval_cust = input$Signif
    logFC_threshold_pos_cust   = as.numeric(input$VerticalThreshold)
    logFC_threshold_neg_cust   = -logFC_threshold_pos_cust
    numrows_cust               = nrow(dfinput)
    tex   = list(family   = "sans serif", size  = 14, color = toRGB("#262626"))
    yaxis = list(tickmode = "array", automargin = TRUE )
    
    # Color distribution
    plot_color_values = plot_colour_distrib(DataFrameWithColors())
    
    tryCatch({ 
      if (is.null(dfinput)){
        return(NULL) }
      
      ###########################################################################
      # 5.2.1 - UPLOAD own file with list of genes, one gene per row
      ###########################################################################
      else if (!is.null(custominputfile)){
        # a- Custom data with uploaded custom file
        inputfile_customdata = toupper(custominputfile[,1])

        # b- Highlight color for custom file input
        col_to_highlight_infile_custom = DataFrameWithColors()  %>%
          mutate( GeneSymbol = toupper(GeneSymbol)) %>%
          filter( GeneSymbol %in% inputfile_customdata) %>%
          mutate( CharValue  = case_when(AdjPValue < input$Signif & Log2FC > as.numeric(input$VerticalThreshold)      ~ "#ff2f2f",    # red
                                         AdjPValue < input$Signif & Log2FC < (-1)*as.numeric(input$VerticalThreshold) ~ "#087fc8",    # blue
                                         AdjPValue > input$Signif & Log2FC > (-1)*as.numeric(input$VerticalThreshold) | Log2FC < as.numeric(input$VerticalThreshold) ~ "#6a6a6a",
                                         AdjPValue > input$Signif  ~ "#6a6a6a" ))
        # c- GGPLOT
        volcanoplotInputFileCustom = ggplot(data= DataFrameWithColors(), mapping = aes(x = Log2FC, y = -log10(AdjPValue), text = GeneSymbol)) +
          geom_point( aes( color     = as.factor(CharValue) ), show.legend = FALSE ) +
          scale_color_manual( values = plot_color_values)  +
          geom_hline( yintercept = -log10(sigval_cust),
                      color      = "#777777",
                      size       = 0.15 ) +
          geom_vline( xintercept = logFC_threshold_pos_cust,
                      color      = "#777777",
                      size       = 0.15 ) +
          geom_vline( xintercept = logFC_threshold_neg_cust,
                      color      = "#777777",
                      size       = 0.15 ) +
          geom_point(data = col_to_highlight_infile_custom, aes(x = Log2FC,
                                                                y = -log10(AdjPValue)),
                     color= col_to_highlight_infile_custom$CharValue, size = 1.7) +
          geom_text(data      = col_to_highlight_infile_custom,
                    aes(x     = Log2FC,
                        y     = -log10(AdjPValue),
                        label = stringr::str_to_title(GeneSymbol)),
                    nudge_x   = 0,
                    nudge_y   = 0.18,
                    size      = 3.5,
                    family    = "sans serif") +
          theme_classic() +
          scale_x_continuous(breaks = seq( round( min( dfinput$Log2FC, na.rm = T)),
                                           round( max( dfinput$Log2FC, na.rm = T)), 1) )
          # labs( title ="Volcano Plot",
          #       caption = str_interp("Total = ${numrows_cust} variables; Significant Threshold = ${sigval_cust}; Vertical = +/-${as.integer(logFC_threshold_pos_cust)} "))
        
        CustomVolcanoPlotStore$image2 = volcanoplotInputFileCustom
        
        # d- PLOTLY
        volcanoplotInputFileCustom_plotly = ggplotly( volcanoplotInputFileCustom,
                                                      tooltip = "text") %>%
          layout(showlegend = FALSE,
                 autosize   = TRUE,
                 yaxis      = yaxis, 
                 title = list(text = str_interp("Total = ${numrows_cust} variables; Significant Threshold = ${sigval_cust}; Vertical = +/-${as.integer(logFC_threshold_pos_cust)} "),
                              font = list(family = "Arial",
                                          size   = 10),
                              xanchor= "center")
                 ) %>%
          config(toImageButtonOptions   = list(filename = "CustomGeneListFromFile",
                                               format = "svg",
                                               width  = 800,
                                               height = 600,
                                               dpi    = 1200),
                 modeBarButtonsToRemove = c("lasso2d", "resetScale2d", "toggleSpikelines", "select2d", "pan2d"))
        return(volcanoplotInputFileCustom_plotly)    }
      
      
      ###########################################################################
      # 5.2.3 INSERT own list of genes 
      ###########################################################################
      else if (!is.null(input$CustomList)){
        
        # b- Subset orginal data to custom list
        convert_to_vector_customlist = toupper(unlist(strsplit(input$CustomList, " +")))[toupper(unlist(strsplit(input$CustomList, " +")))!= ""]
        col_to_highlight  = DataFrameWithColors() %>%
          mutate( GeneSymbol = toupper(GeneSymbol)) %>%
          filter( GeneSymbol %in% convert_to_vector_customlist) %>%
          mutate( CharValue  = case_when(AdjPValue < input$Signif & Log2FC > as.numeric(input$VerticalThreshold)      ~ "#ff2f2f",    # red
                                         AdjPValue < input$Signif & Log2FC < (-1)*as.numeric(input$VerticalThreshold) ~ "#087fc8",    # blue
                                         AdjPValue > input$Signif & Log2FC > (-1)*as.numeric(input$VerticalThreshold) | Log2FC < as.numeric(input$VerticalThreshold) ~ "#6a6a6a",
                                         AdjPValue > input$Signif  ~ "#6a6a6a" ))
        # browser()
        
        # c- Visualize custom genes
        volcanoplotcustom = ggplot(data    = DataFrameWithColors(),
                                   mapping = aes(x    = Log2FC,
                                                 y    = -log10(AdjPValue),
                                                 text = GeneSymbol)) +
          geom_point( aes( color = as.factor(CharValue) ), show.legend = FALSE ) +
          scale_color_manual( values = plot_color_values)  +
          geom_hline( yintercept = -log10(sigval_cust),
                      color      = "#777777",
                      size       = 0.15 ) +
          geom_vline( xintercept = logFC_threshold_pos_cust,
                      color      = "#777777",
                      size       = 0.15 ) +
          geom_vline( xintercept = logFC_threshold_neg_cust,
                      color      = "#777777",
                      size       = 0.15 ) +
          geom_point(data  = col_to_highlight,
                     aes(x = Log2FC,
                         y = -log10(AdjPValue)),
                     color = col_to_highlight$CharValue,
                     size  = 1.7) +
          geom_text(data  = col_to_highlight,
                    aes(x = Log2FC,
                        y = -log10(AdjPValue),
                        label = stringr::str_to_title(GeneSymbol)),
                    nudge_x = 0,
                    nudge_y = 0.18,
                    size    = 3.5,
                    family  = "sans serif") +
          theme_classic() +
          scale_x_continuous(breaks = seq( round( min( dfinput$Log2FC, na.rm = T)),
                                           round( max( dfinput$Log2FC, na.rm = T)), 1) )+    # Y axis scale
          scale_y_continuous(breaks = seq( round( min( -log10(dfinput$AdjPValue), na.rm = T)), 
                                           round( max( -log10(dfinput$AdjPValue), na.rm = T)), 2) )

        CustomVolcanoPlotStore$image2 = volcanoplotcustom
        
        # d- PLOTLY     # m = list(l = 50, r = 50, b = 100, t = 100,  pad = 4)
        volcanoplotcustom_plotly = ggplotly( volcanoplotcustom,
                                             tooltip = "text") %>%
          layout(showlegend = FALSE,
                 autosize   = TRUE,
                 yaxis      = yaxis,
                 title = list(text = str_interp("Total = ${numrows_cust} variables; Significant Threshold = ${sigval_cust}; Vertical = +/-${as.integer(logFC_threshold_pos_cust)} "),
                              font = list(family = "Arial",
                                          size   = 10),
                              xanchor= "center")
        ) %>% 
          config(toImageButtonOptions   = list(filename = "CustomGeneList",
                                               format = "svg",
                                               width  = 800,
                                               height = 600,
                                               dpi    = 1200),
                 modeBarButtonsToRemove = c("lasso2d", "resetScale2d", "toggleSpikelines", "select2d", "pan2d"))
        return(volcanoplotcustom_plotly) }
      
      # 5.2.4 No File
      else if (is.null(custominputfile)){
        return(NULL) }
    },
    error = function(e) {
      displayErrorMessage("File Loading Error in Data Input File!", 
                          "Check the Help Page for the file input format, column names. /// CustomListOfInterest function", "")}
    )
  })
  
  
  #================================================================================================================
  # 5.3.0 OUTPUT visualization
  #================================================================================================================
  output$CustomisedPlot = renderPlotly({
    a2 = CustomListOfInterest()
    Sys.sleep(2)
    hide(id = "loading-content2")  
    a2 
  } )
  
  
  
  #================================================================================================================
  # 5.4.0 OUTPUT table
  #================================================================================================================
  output$CustomisedTable2 = renderDT({
    if (!is.null(CustomDataFile())){
      convert_file_data_uppercase   = toupper(CustomDataFile()[,1])
      subset_filedata_to_list       = DataFrameWithColors() %>%  
        mutate( GeneSymbol = toupper(GeneSymbol)) %>%
        filter( GeneSymbol %in% convert_file_data_uppercase) %>%
        mutate( GeneSymbol = stringr::str_to_title(GeneSymbol))
    }
    else if (!is.null(input$CustomList)){ 
      convert_own_gene_list= toupper(unlist(strsplit(input$CustomList, " ")))
      subset_to_list       = DataFrameWithColors() %>%  
        mutate( GeneSymbol = toupper(GeneSymbol)) %>%
        filter( GeneSymbol %in% convert_own_gene_list) %>%
        mutate( GeneSymbol = stringr::str_to_title(GeneSymbol))
    }
    else if (is.null(CustomDataFile())){
      return(NULL)
    }
  })
  
  
  
  
  
  # ====================================================================
  # ====================================================================
  # ====================================================================
  # 6. DOWNLOAD results
  # ====================================================================
  # ====================================================================
  # ====================================================================  
  
  #================================================================================================================
  # 6.0.0 Download table results
  #================================================================================================================
  output$DownloadTbl = downloadHandler(
    filename = function(){
      # 1.SIGNIF
      if (input$TableDownload == "Significant" & input$Tablefiletype == "csv"){
        paste("Signif_Table", "_", format(Sys.Date(), "%d%b%Y"),  paste(".", input$Tablefiletype, sep="") , sep = "")}
      else if (input$TableDownload == "Significant" & input$Tablefiletype == "txt"){
        paste("Signif_Table", "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Tablefiletype, sep=""), sep = "")}
      
      # 2.MITO Processe
      else if (input$TableDownload == "Mito Processes" & input$Tablefiletype == "csv"){
        paste("Mito_Processes_Table", "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Tablefiletype, sep="") ,sep="")}
      else if (input$TableDownload == "Mito Processes" & input$Tablefiletype == "txt"){
        paste("Mito_Processes_Table", "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Tablefiletype, sep=""), sep="")}
      
      # 3.ALL PROCESSES
      else if (input$TableDownload == "All Processes in Input Data" & input$Tablefiletype == "csv"){
        paste("AllInput_Processes_Table", "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Tablefiletype, sep="") ,sep="")}
      else if (input$TableDownload == "All Processes in Input Data" & input$Tablefiletype == "txt"){
        paste("AllInput_Processes_Table", "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Tablefiletype, sep=""), sep="")}
      
      # 4.SELECTED MULTIPLE PROCESSES
      else if (input$TableDownload == "Multiple Processes" & input$Tablefiletype == "csv"){
        paste("Multiple_Processes_Table", "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Tablefiletype, sep="") ,sep="")}
      else if (input$TableDownload == "Multiple Processes" & input$Tablefiletype == "txt"){
        paste("Multiple_Processes_Table", "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Tablefiletype, sep=""), sep="")}
      
      # 5.CELLULAR LOCALIZATION
      else if (input$TableDownload == "Cellular Localization" & input$Tablefiletype == "csv"){
        paste("Cellular_Localization_Table", "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Tablefiletype, sep="") ,sep="")}
      else if (input$TableDownload == "Cellular Localization" & input$Tablefiletype == "txt"){
        paste("Cellular_Localization_Table", "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Tablefiletype, sep=""), sep="")}
    },
    content = function(file) {
      # SIGNIF
      if(input$TableDownload == "Significant" & input$Tablefiletype == "csv"){
        write.csv( FilteredToSignif(), file = file, row.names = FALSE)}
      else if(input$TableDownload == "Significant" & input$Tablefiletype == "txt"){
        write.table( FilteredToSignif(), file = file, row.names = FALSE, sep = "\t")}
      
      # MITO PROCESSES
      else if(input$TableDownload == "Mito Processes" & input$Tablefiletype == "csv"){
        write.csv( MitoProcesses(), file = file, row.names = FALSE)}
      else if(input$TableDownload == "Mito Processes" & input$Tablefiletype == "txt"){
        write.table( MitoProcesses() , file = file, row.names = FALSE, sep = "\t")}
      
      # ALL PROCESSES
      if(input$TableDownload == "All Processes in Input Data" & input$Tablefiletype == "csv"){
        write.csv( DataSharedForMULTIPLEMitoProcess$data()[,c(1,2,3,4,5,6)], file = file, row.names = FALSE)}
      else if(input$TableDownload == "All Processes in Input Data" & input$Tablefiletype == "txt"){
        write.table( DataSharedForMULTIPLEMitoProcess$data()[,c(1,2,3,4,5,6)], file = file, row.names = FALSE, sep = "\t")}
      
      # SELECTED MULTIPLE PROCESSES
      else if(input$TableDownload == "Multiple Processes" & input$Tablefiletype == "csv"){
        # browser()
        write.csv( mmp_createTabDataFrame(getMMPValuesSelected()), file = file, row.names = FALSE)}
      else if(input$TableDownload == "Multiple Processes" & input$Tablefiletype == "txt"){
        write.table( mmp_createTabDataFrame(getMMPValuesSelected()) , file = file, row.names = FALSE, sep = "\t")}
      
      # CELLULAR LOCALIZATION
      else if(input$TableDownload == "Cellular Localization" & input$Tablefiletype == "csv"){
        write.csv( DataFrameForCellularCompartLocaliz(), file = file, row.names = FALSE)}
      else if(input$TableDownload == "Cellular Localization" & input$Tablefiletype == "txt"){
        write.table( DataFrameForCellularCompartLocaliz() , file = file, row.names = FALSE, sep = "\t")}
    })
  
  
  
  output$DownloadPlot = downloadHandler(
    filename = function(){
      if (input$PlotDownload == "Custom Gene List" & input$Plotfiletype == "png"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      else if (input$PlotDownload == "Custom Gene List" & input$Plotfiletype == "pdf"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      else if (input$PlotDownload == "Custom Gene List" & input$Plotfiletype == "svg"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      else if (input$PlotDownload == "Custom Gene List" & input$Plotfiletype == "jpeg"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
      else if (input$PlotDownload == "Custom Gene List" & input$Plotfiletype == "tiff"){
        paste( input$PlotDownload, "_", format(Sys.Date(), "%d%b%Y"), paste(".", input$Plotfiletype, sep=""), sep="")}
    },
    content = function(file){
      # print(file)
      if (input$PlotDownload == "Custom Gene List" & input$Plotfiletype == "png"){
        ggsave(  filename=file, plot = CustomVolcanoPlotStore$image2, device = "png",  width = 400, height = 300, dpi= 1200, units = "mm")}
      else if (input$PlotDownload == "Custom Gene List" & input$Plotfiletype == "pdf"){
        ggsave(  filename=file, plot = CustomVolcanoPlotStore$image2, device = "pdf",  width = 400, height = 300, dpi= 1200, units = "mm")}
      else if (input$PlotDownload == "Custom Gene List" & input$Plotfiletype == "svg"){
        ggsave(  filename=file, plot = CustomVolcanoPlotStore$image2, device = "svg",  width = 400, height = 300, dpi= 1200, units = "mm")}
      else if (input$PlotDownload == "Custom Gene List" & input$Plotfiletype == "jpeg"){
        ggsave(  filename=file, plot = CustomVolcanoPlotStore$image2, device = "jpeg",  width = 400, height = 300, dpi= 1200, units = "mm")}
      else if (input$PlotDownload == "Custom Gene List" & input$Plotfiletype == "tiff"){
        ggsave(  filename=file, plot = CustomVolcanoPlotStore$image2, device = "tiff",  width = 400, height = 300, dpi= 1200, units = "mm")}
    } )
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
# Running under: Windows 10 x64 (build 17134)
# 
# Matrix products: default
# 
# Random number generation:
#   RNG:     Mersenne-Twister 
# Normal:  Inversion 
# Sample:  Rounding 
# 
# locale:
#   [1] LC_COLLATE=English_Australia.1252  LC_CTYPE=English_Australia.1252    LC_MONETARY=English_Australia.1252 LC_NUMERIC=C                      
# [5] LC_TIME=English_Australia.1252    
# 
# attached base packages:
#   [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
#   [1] colourpicker_1.1.0       shinyjs_2.0.0            shinyalert_1.1           shinythemes_1.1.2        shinydashboardPlus_0.7.5 config_0.3              
# [7] crosstalk_1.0.0          stringr_1.4.0            svglite_1.2.3            DT_0.12                  plotly_4.9.1             ggplot2_3.2.1           
# [13] shinyWidgets_0.5.0       shinydashboard_0.7.1     dplyr_0.8.3              shiny_1.4.0             
# 
# loaded via a namespace (and not attached):
#   [1] tidyselect_0.2.5      purrr_0.3.3           colorspace_1.4-1      vctrs_0.2.2           miniUI_0.1.1.1        htmltools_0.4.0       viridisLite_0.3.0    
# [8] yaml_2.2.1            rlang_0.4.2           later_1.0.0           pillar_1.4.3          glue_1.3.1            withr_2.1.2           gdtools_0.2.1        
# [15] lifecycle_0.1.0       munsell_0.5.0         gtable_0.3.0          htmlwidgets_1.5.1     fastmap_1.0.1         httpuv_1.5.2          Rcpp_1.0.3           
# [22] xtable_1.8-4          promises_1.1.0        scales_1.1.0          EnhancedVolcano_1.4.0 jsonlite_1.6.1        mime_0.9              systemfonts_0.1.1    
# [29] digest_0.6.23         stringi_1.4.4         ggrepel_0.8.1         grid_3.6.1            tools_3.6.1           magrittr_1.5          lazyeval_0.2.2       
# [36] tibble_2.1.3          crayon_1.3.4          tidyr_1.0.2           pkgconfig_2.0.3       data.table_1.12.8     assertthat_0.2.1      httr_1.4.1           
# [43] rstudioapi_0.11       R6_2.4.1              compiler_3.6.1       





##############################################################################################################################
#
# PLOT with legend. However, ggplotly alter legend colors  
#
##############################################################################################################################
# h- selecetd multiple processes vector and color
# uniq_processes_df
# colors_to_highlight_mm_multiple_process | value_key_for_legend = as.character(unique(colors_to_highlight_mm_multiple_process$Process))
# NOTE: to enbale same colour usage , unique() is not used
# NOTE: scale_color_manual() to use ONLY "values=c()" will sort colour names alphabetically, therefore use "labels=c()"
# VolcanoPlot_mm_mult_process = ggplot(  data    = final_df_mm,
#                                        mapping = aes(x    = Log2FC,
#                                                      y    = -log10(AdjPValue),
#                                                      text = GeneSymbol
#                                        )) +
#   # Colour all selected processes and data values correctly
#   geom_point(
#     color = data_shared_mm_mult_process$origData()[,8],
#     size  = 1.5
#   ) +
#   # Selection of value labels (reactivity, crosstalking)
#   geom_point(data        = data_shared_subset_to_selected_proc_df,    # 40x8
#              aes(colour  = Process),
#              show.legend = T) +
#   # Legend title and correct colour scaling
#   scale_color_manual(
#     #aesthetics = c("colour", "fill"),
#     name   = "Selected Processes",
#     labels = value_key_for_legend,
#     values = color_key_for_legend
#   ) +
#   # Axis
#   geom_hline( yintercept = -log10(sigval),
#               color      = "#777777",
#               size       = 0.15 ) +
#   geom_vline( xintercept = logFC_threshold_pos,
#               color      = "#777777",
#               size       = 0.15 ) +
#   geom_vline( xintercept = logFC_threshold_neg,
#               color      = "#777777",
#               size       = 0.15 ) +
#   # Plot background
#   theme_classic() +
#   # X axis scaling
#   scale_x_continuous(breaks = seq( round( min( inputfile$Log2FC, na.rm = T)),
#                                    round( max( inputfile$Log2FC, na.rm = T)), 1) )+
#   # Y axis scale
#   scale_y_continuous(breaks = seq( round( min( -log10(inputfile$AdjPValue), na.rm = T)),
#                                    round( max( -log10(inputfile$AdjPValue), na.rm = T)), 2) )
# 
# ExploreMitoVolcanoStore$image1 = VolcanoPlot_mm_mult_process
# 
# # h- PLOTLY | Plotly webpage apperance
# # NOTE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ggplotly(messes up legend colors )
# VolcanoPlot_mm_mult_process_plotly = ggplotly( VolcanoPlot_mm_mult_process, tooltip = "text") %>%
#   highlight(on         = "plotly_click",
#             off        = "plotly_doubleclick", 
#             persistent = T,      
#             opacityDim = 1, 
#             selected   = attrs_selected(mode         = "text", 
#                                         textfont     = tex, 
#                                         textposition = "top right",
#                                         marker = list(symbol = ".crossTalkKey"))) %>%
#   layout(showlegend = TRUE,
#          autosize   = TRUE,
#          yaxis      = yaxis,
#          title = list(text = str_interp("Total = ${numrows} variables; Significant Threshold = ${sigval}; Vertical = +/-${as.integer(logFC_threshold_pos)} "),
#                       font = list(family = "Arial",
#                                   size   = 10),
#                       xanchor= "center")
#   ) %>% 
#   config(toImageButtonOptions   = list(format = "svg", 
#                                        width  = 800, 
#                                        height = 600, 
#                                        dpi    = 1200),
#          modeBarButtonsToRemove = c("lasso2d", "resetScale2d", "toggleSpikelines", "select2d", "pan2d"))
# 
# 
# return(VolcanoPlot_mm_mult_process_plotly)
