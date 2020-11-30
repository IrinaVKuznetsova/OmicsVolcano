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
# SOFTWARE DEVELOPERS
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
# LICENSE
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






# ====================================================================
# ====================================================================
# ====================================================================
# HELPER FUNCTIONS
# ====================================================================
# ====================================================================
# ====================================================================
modify_stop_propagation = function(x) {
  x$children[[1]]$attribs$onclick = "event.stopPropagation()"
  x
}





# ====================================================================
# ====================================================================
# ====================================================================
# STATUS BAR IMPLEMENTATION
# ====================================================================
# ====================================================================
# ====================================================================


# ===================================================================================================================================
# ===================================================================================================================================
# 1. STATUS AND ERROR BAR
# ===================================================================================================================================
# ===================================================================================================================================
# TOP ICONS
ui_info_box = box(width = 12,
                  fluidRow(
                    width = 12,
                    # A static infoBox
                    infoBoxOutput("UI_INFO_GENERAL"),
                    infoBoxOutput("UI_INFO_PROCESS"),
                    infoBoxOutput("UI_INFO_EXPLORE")
                  ))





# ====================================================================
# ====================================================================
# ====================================================================
# UI COMPONENTS AND ELEMENTS
# ====================================================================
# ====================================================================
# ====================================================================


# ===================================================================================================================================
# ===================================================================================================================================
# 1. GENERAL ELEMENTS
# ===================================================================================================================================
# ===================================================================================================================================
ui_menue_body_elements = c("menue_tab_home_body", "menue_tab_file_open_body")


# ===================================================================================================================================
# ===================================================================================================================================
# 2. DOWNLOAD DEMO FILE LINK
# ===================================================================================================================================
# ===================================================================================================================================
ui_download_demo_file =
  tags$a(
    href     = CONST_DEMO_FILE,
    target   = "_blank",
    icon     = icon("fa fa-heart"),
    icon("disk"),
    "Download demo file to local PC...",
    download = "demofile.txt")


# ===================================================================================================================================
# ===================================================================================================================================
# 3. FILE UPLOAD
# ===================================================================================================================================
# ===================================================================================================================================
ui_file_input_diag = box (
  width = 12,
  checkboxInput(
    inputId = "UI_INPUT_FILE_REMOVE_DUPLICATES",
    label   = "Check for Duplicates",
    value   = TRUE),
  
  radioButtons(
    inputId = "UI_INPUT_FILE_SEPARATOR",
    "File Separator",
    choices = c( Semicolon = ";", Tab = "\t"),
    selected= "\t"),
  
  tags$hr(),
  ui_download_demo_file,
  tags$hr(),
  
  fileInput(
    inputId     = "UI_INPUT_FILE_NAME",
    label       = NULL,
    buttonLabel = "Open...",
    multiple    = FALSE,
    accept      = c("text/csv",
                    "text/comma-separated-values,text/plain",
                    ".csv") ),
  
  DTOutput(outputId     = "UI_INPUT_FILE_RESULTS")
)


# ===================================================================================================================================
# ===================================================================================================================================
# 4. THRESHOLD BOX
# ===================================================================================================================================
# ===================================================================================================================================
ui_threshold_configuration = box (id    = "ui_threshold_configuration",
                                  color = "orange",
                                  title = "Threshold",
                                  solidHeader = TRUE,
                                  width = 12,
                                  
                                  # Vertical threshold
                                  numericInput("VerticalThreshold",
                                               label = "Plot Vertical Threshold",
                                               value = 1,
                                               min   = 0.1,  
                                               max   = 1000,
                                               step  = 0.5),
                                  
                                  tags$style(
                                    type = "text/css",
                                    ".irs-grid-text:nth-child(-2n+18) {color: black; }",   #https://stackoverflow.com/questions/50370958/color-tick-mark-tick-mark-labels-in-sliderinput-shiny
                                    ".irs-grid-text:nth-child(2n+20)  {color: red;   font-size:12}",
                                    ".irs-grid-pol:nth-of-type(-n+0)  {background: black; }",
                                    ".irs-grid-pol:nth-of-type(n+0)  {background:  black}" ),
                                  
                                  sliderInput(inputId   = "Signif",
                                              label     = "Significance",
                                              min       = 0,
                                              max       = 0.1,
                                              value     = c(0.05),
                                              step      = 0.01,
                                              round     = -3 ))


# ===================================================================================================================================
# ===================================================================================================================================
# 5. EXPLORE ONE MITOCHONDRIAL PROCESS
# ===================================================================================================================================
# ===================================================================================================================================
ui_explore_mitochondrial_process = box (
  color = "orange",
  title = "Mitochondrial Process",
  solidHeader = TRUE,
  width = 12,
  
  # Organism of interest
  radioButtons(
    inputId  = "OrganismSource",
    label    = "Select Organism",
    choices  = c("Mouse", "Human"),
    inline   = TRUE),
  
  # A process of interest
  selectInput(    
    inputId   = "MtProcess",
    label     = "Show Mitochondrial Process",
    # IF: mult=F, selectize=F, size - 5 box anables to see 5 options, but to select only one 
    # IF: mult=T, selectize=T | no size option
    multiple  =F,                                
    selected ="Show All Mitochondrial Genes",   
    choices   = list( `Processes:` = list(
    # choices   = list( 
      "Show All Mitochondrial Genes", "Amino Acid Metabolism",
      "Apoptosis", "Bile Acid Synthesis",
      "Calcium Signaling & Transport", "Cardiolipin Biosynthesis",
      "Fatty Acid Biosynthesis & Elongation",
      "Fatty Acid Degradation & Beta-oxidation",
      "Fatty Acid Metabolism", "Fe-S Cluster Biosynthesis",
      "Folate & Pterin Metabolism", "Fructose Metabolism", "Glycolysis",
      "Heme Biosynthesis", "Import & Sorting", "Lipoic Acid Metabolism",
      "Metabolism of Lipids & Lipoproteins", "Metabolism of Vitamins & Co-Factors",
      "Mitochondrial Carrier", "Mitochondrial Dynamics",
      "Mitochondrial Gene Expression", "Mitochondrial Signaling",
      "Mitophagy", "Nitrogen Metabolism", "Nucleotide Metabolism",
      "Oxidative Phosphorylation", "Pentose Phosphate Pathway",
      "Protein Stability & Degradation", "Pyruvate Metabolism",
      "Replication & Transcription", "Ribosomal", "ROS Defense", "Transcription (nuclear)",
      "Translation", "Transmembrane Transport", "Tricarboxylic Acid Cycle",
      "Ubiquinone Biosynthesis", "Unknown MT process", "UPRmt"), 
      # "Oxidative Phosphorylation (MT)", "Translation (MT)")
      `MT DNA encoded:` = list("Oxidative Phosphorylation (MT)", "Translation (MT)"))
    )
)


# ===================================================================================================================================
# ===================================================================================================================================
# 6. EXPLORE MULTIPLE MITOCHONDRIAL PROCESSES
# ===================================================================================================================================
# ===================================================================================================================================
ui_explore_multiple_mitochondrial_processes = box(
  color       = "orange",
  title       = "Mutliple Mitochondrial Processes",
  solidHeader = TRUE,
  width       = 12,
  
  # ORGANISM OF INTEREST
  radioButtons(
    inputId  = "OrganismSource2",
    label    = "Select Organism",
    choices  = c("Mouse", "Human"),
    inline   = TRUE),
  
  # uiOutput("UI_MMP_PROCESSES")
  actionButton(inputId = "UI_MMP_LIST_ACTION",
                              width   = '80px',
                              label   = "Apply"),
  # actionButton("selectall", "Select All"),
  hr(),   # space btw Action button and next info
  h4("Select Processes and Colours"),
  h6("Hex colour code - #D91414, or colour name - red"),
  lapply(1:length(ui_mmp_names), function(x) {
  fluidRow( offset = 1,
            # CHECK BOXES
            column (width = 1,
                    checkboxInput(
                      inputId = paste0("UI_MMP_LIST_CHECKBOX_", x),
                      value   = FALSE,
                      label   = NULL)),
            # COLOUR PALETTE
            column (width = 2,
                    colourWidget( elementId  = paste0("UI_MMP_LIST_COLORPICKER_", x),
                                  value      = "#000000",
                                  palette    = "square",
                                  showColour = "both",
                                  width      = '77px',
                                  height     = '20px')),
            # PROCESSES
            column (width = 9,
                    h5(ui_mmp_names[x]))
  )})

)





# ===================================================================================================================================
# ===================================================================================================================================
# 7. EXPLORE CELLULAR COMPARTMENT LOCALIZATION
# ===================================================================================================================================
# ===================================================================================================================================
ui_explore_cellular_compartment_localiz = box (
  color = "orange",
  title = "Cellular Compartment Localization (Human)",
  solidHeader = TRUE,
  width = 12,

  # A process of interest
  selectInput(
    inputId   = "CellularLocal",
    label     = "Cellular Localization",
    multiple  = F,
    selected  ="actin",
    choices   = list("Actin Filaments", "Centrosome", "Cytosol", "Endoplasmic Reticulum", "Golgi Apparatus", "Intermediate Filaments",
                     "Microtubules", "Mitochondria", "Nucleoli", "Nuclear Membrane", "Plasma Membrane", "Vesicles")
  )
)

# ui_explore_cellular_compartment_localiz = box(
#   color       = "orange",
#   title       = "Cellular Compartment Localization (Human)",
#   solidHeader = TRUE,
#   width       = 12,
# 
#   uiOutput("UI_MMP_CELLULAR_LOCALIZ")
# )

# ===================================================================================================================================
# ===================================================================================================================================
# 8. EXPLORE CUSTOM GENE LIST
# ===================================================================================================================================
# ===================================================================================================================================
ui_explore_custom_gene_list = box(color = "orange",
                                  title = "Custom Gene List",
                                  solidHeader = TRUE,
                                  width = 12,
                                  
                                  radioButtons( inputId  = "CustomInputOptions",
                                                label     = NULL,
                                                choices   = c("Insert a list of genes", "Upload a gene file"),
                                                inline    = TRUE),
                                  
                                  # a-Condition to insert own list of genes
                                  conditionalPanel( condition = "input.CustomInputOptions == 'Insert a list of genes'",
                                                    tabPanel(  title    = "Explore Custom Gene List",
                                                      textInput(inputId = "CustomList",
                                                                label   = "Insert a list of genes separated by space",
                                                                value   = "ptcd3 sf1 mrp130")
                                                      )
                                                    ),
                                  # b-Condition to upload a file with list of genes
                                  conditionalPanel(
                                    condition = "input.CustomInputOptions == 'Upload a gene file'",
                                    fileInput(inputId = "UserGeneNamesFile",
                                              label   = "Upload a gene file")
                                    )
                                  )


# ===================================================================================================================================
# ===================================================================================================================================
# 10. PLOT DOWNLOAD
# ===================================================================================================================================
# ===================================================================================================================================
ui_download_plot = box (selectInput(inputId  = "PlotDownload",
                                    label    = "Select Plot",
                                    choices  = c("Custom Gene List"),
                                    selected = c("Custom Gene List")),
                        selectInput(
                          inputId  = "Plotfiletype",
                          label    = "Select Plot File Format",
                          choices  = c("svg", "pdf", "jpeg", "png", "tiff"),
                          selected = "svg"),
                        downloadButton(outputId  = "DownloadPlot",
                                       label     = "Download Plot")
                        )
# ===================================================================================================================================
#  --------------------------------------- END --------------------------------------- "PLOT DOWNLOAD"
# ===================================================================================================================================


# ===================================================================================================================================
# ===================================================================================================================================
# 11.TABLE DOWNLOAD
# ===================================================================================================================================
# ===================================================================================================================================
ui_download_table = box ( selectInput(inputId  = "TableDownload",
                                      label    = "Select Table",
                                      choices  = c("Significant", "Mito Processes", 
                                                   "All Processes in Input Data", "Multiple Processes", "Cellular Localization"),
                                      selected = c("Significant") ),
                          selectInput(inputId  = "Tablefiletype",
                                      label    = "Select File Format",
                                      choices  = c("csv", "txt"),
                                      selected = "csv"),
                          downloadButton(outputId = "DownloadTbl",
                                         label    = "Download Table")
                          )
# ===================================================================================================================================
#  --------------------------------------- END --------------------------------------- "TABLE DOWNLOAD"
# ===================================================================================================================================





# ====================================================================
# ====================================================================
# ====================================================================
# RIGHT DASHBOARD SIDEBAR
# ====================================================================
# ====================================================================
# ====================================================================

# ===================================================================================================================================
# ===================================================================================================================================
# 1. SETTING OPTIONS FOR THE RIGHT-SIDE DASHBOARD MENUE
# ===================================================================================================================================
# ===================================================================================================================================
function_para_tabs =  tagList (tags$style("#UI_RIGHT_SIDEBAR_SELECTMODE { display:none; }"),
                               tabsetPanel (id       = "UI_RIGHT_SIDEBAR_SELECTMODE",
                                            selected = "menue_tab_exp_plot",
                                            ui_threshold_configuration,
                                 tabPanel("menue_tab_exp_plot"),                 
                                 tabPanel("menue_tab_exp_genelist",
                                          ui_explore_custom_gene_list ),
                                 tabPanel("menue_tab_exp_mitproc",
                                          ui_explore_mitochondrial_process),
                                 tabPanel("menue_tab_exp_cellular_compartment",           
                                          ui_explore_cellular_compartment_localiz),
                                 tabPanel("menue_tab_exp_multiple_mitoprocesses",           
                                          ui_explore_multiple_mitochondrial_processes),
                                 
                                 tabPanel("UI_RIGHT_SIDEBAR_NONE",
                                          p(""))
                                 )
                               )
# ===================================================================================================================================
#  --------------------------------------- END -------------------------------- "SETTING OPTIONS FOR THE RIGHT-SIDE DASHBOARD MENUE"
# ===================================================================================================================================


# ===================================================================================================================================
# ===================================================================================================================================
# 2. CONFIGURATION (RIGHT DASHBOARD)
# ===================================================================================================================================
# ===================================================================================================================================
ui_right_sidebar = rightSidebar(
  background     = "light",
  width          = 350,
  fluid          = FALSE,
  h1("Settings"),
  function_para_tabs)
# ===================================================================================================================================
#  --------------------------------------- END -------------------------------- "CONFIGURATION"
# ===================================================================================================================================





# ====================================================================
# ====================================================================
# ====================================================================
# LEFT DASHBOARD SIDEBAR
# ====================================================================
# ====================================================================
# ====================================================================
ui_dash_sidebar = dashboardSidebar(
  collapsed = FALSE,
  disable   = FALSE,
  sidebarMenu(id           = "ui_dashboard_sidebar",
              sartExpanded = TRUE,        
              
              menuItem("Home Page",
                       tabName = "menue_tab_home",
                       icon    = icon("home")),
              
              menuItem("File",
                       icon    = icon("database"),
                       
                       menuSubItem("Open...",
                                   tabName = "menue_tab_file_open",
                                   icon    = icon("folder-open")) ),
              
              menuItem("Explore",
                       icon = icon("eye"),
                       menuSubItem("Plot",
                                   tabName = "menue_tab_exp_plot",
                                   icon    = icon("image")),
                       menuSubItem("Custom Gene List",
                                   tabName = "menue_tab_exp_genelist",
                                   icon    = icon("dna")),
                       menuSubItem( "Mitochondrial Process",
                                    tabName = "menue_tab_exp_mitproc",
                                    icon    = icon("project-diagram") ),
                       menuSubItem( "Multiple Processes",                              
                                    tabName = "menue_tab_exp_multiple_mitoprocesses",      
                                    icon    = icon("balance-scale") ),
                       menuSubItem( "Cellular Localization",                              
                                    tabName = "menue_tab_exp_cellular_compartment",      
                                    icon    = icon("anchor") )),
              
              menuItem( "Export",
                        icon = icon("save"),
                        menuSubItem("Plot",
                                    tabName = "menue_tab_download_plot",
                                    icon    = icon("file-export")),
                        menuSubItem("Table",
                                    tabName = "menue_tab_download_table",
                                    icon    = icon("file-export"))   ),
              menuItem("Help",  icon = icon("question"), tabName = "menue_tab_help"),
              menuItem("About", icon = icon("info"),     tabName = "menue_tab_about")
              )
  )





# ====================================================================
# ====================================================================
# ====================================================================
# BODY ELEMENTS
# ====================================================================
# ====================================================================
# ====================================================================



# ===================================================================================================================================
# ===================================================================================================================================
# I. MENUE ITEMS FOR BODY TAB
# ===================================================================================================================================
# ===================================================================================================================================
# 1. HOMEPAGE
menue_tab_home_body = tabItem("menue_tab_home",
                              h1("Home Page"),
                              
                              # Textual info at HOME page
                              mainPanel(tags$div( h3("OmicsVolcano"),
                                                  p("OmicsVolcano is a visualization software tool that enables to explore interactively volcano plot for presence of mitochondrial localized genes or proteins"),
                                                  img(src = './images/OmicsVolcano_example.svg',
                                                      height = '300px',
                                                      width  = '600px',
                                                      align  = "middle"),
                                                  br(),
                                                  br(),
                                                  p("Copyright (C) 2020") )) )
# ===================================================================================================================================
#  --------------------------------------- END --------------------------------------- "MENUE ITEMS FOR BODY TAB"
# ===================================================================================================================================



# ===================================================================================================================================
# ===================================================================================================================================
# II. EXPLORE PLOT VALUES
# ===================================================================================================================================
# ===================================================================================================================================
# 1. PLOT enables to explore and visualize all values
# LOCATION: "PLOT" tab (left-hand side menue tab)
menue_tab_exp_plot_body = tabItem("menue_tab_exp_plot",
                                  h1("Explore Plot Values"),
                                  helpText("Explore your data for any genes/proteins of interest"),
                                  
                                  # Loading message
                                  div(id = "loading-content1",
                                      h4("Loading Data...")),
                                  plotlyOutput(outputId = "volcanoPlotNuclear"),
                                  br(),
                                  br(),
                                  tabBox(
                                    width  = 12,
                                    # Table INPUT, SIGNIF
                                    tabPanel(title  = "Input Data",
                                             DTOutput(outputId = "InputOriginalData1")),
                                    tabPanel(title  = "Signif",
                                             DTOutput(outputId = "SignifData1"))  ))


# 2. PLOT enables to visualize custom gene list which may be related to specific process
# LOCATION: "CUSTOM GENE LIST" (left-hand side menue tab)
menue_tab_exp_genelist_body = tabItem("menue_tab_exp_genelist",
                                      h1("Explore Custom Gene List"),
                                      # Plot3 and Table   #  ui_explore_custom_gene_list
                                      helpText("Type in a list of gene names of interest in 'Explore Custom Gene List' tab, separated by space or upload own file with one gene per row Genes that are present in your data will be visualized on Volcano Plot"),
                                      
                                      # Loading message
                                      div(id = "loading-content2",
                                          h4("Loading Data...")),
                                      plotlyOutput(outputId = "CustomisedPlot"),
                                      br(),
                                      br(),
                                      tabBox(width = 12,
                                             tabPanel(
                                               title = "Selected Gene(s) Info",
                                               DTOutput(outputId = "CustomisedTable2")   )) )


# 3. EXPLORE ONE MITO PROCESS
# LOCATION: "MITOCHONDRIAL PROCESS" (left-hand side menue tab)
menue_tab_exp_mitproc_body = tabItem( "menue_tab_exp_mitproc",
                                      h1("Explore Mitochondrial Process"),
                                      title = "Explore Mitochondrial Processes",
                                      #Plot2
                                      helpText("Explore your data for mitochondrial processes"),
                                      
                                      # Loading message
                                      div(id = "loading-content3",
                                          h4("Loading Data...")),
                                      plotlyOutput(outputId = "VolcanoPlotOutExploreMito"),
                                      br(),
                                      br(),
                                      tabBox (
                                        width  = 12,
                                        # Table INPUT, SIGNIF, PROCESSES
                                        tabPanel(title  = "All Processes",
                                                 DTOutput(outputId = "InputOriginalData3")),
                                        tabPanel(title  = "Signif",
                                                 DTOutput(outputId = "SignifData3")),
                                        tabPanel(title  = "MITO Processes",
                                                 DTOutput(outputId = "ProcessesData3")),
                                        tabPanel(title="Selected Process",                      
                                                 DTOutput(outputId = "ProcessesDataSubset3"))))


# 4. EXPLORE MITO MULTIPLE PROCESSES   
# LOCATION: "MULTIPLE PROCESSES" (left-hand side menue tab)
menue_tab_exp_multiple_mitoprocesses_body = tabItem( "menue_tab_exp_multiple_mitoprocesses",
                                      h1("Explore Multiple Mitochondrial Processes"),
                                      title = "Explore Multiple Mitochondrial Processes",
                                      #Plot2
                                      helpText("Explore multiple mitochondrial processes"),
                                      
                                      # Loading message
                                      div(id = "loading-content4",
                                          h4("Select Processes and colours from the right-hand pannel, press Apply to visualize plot")),
                                      # plotlyOutput(outputId = "VolcanoPlotOutMultipleProcessesMito"),
                                      
                                      column(12,
                                             plotlyOutput(outputId = "VolcanoPlotOutMultipleProcessesMito")),
                                      # column(4,
                                      #        plotlyOutput(outputId = "VolcanoPlotOutMultipleProcessesMitoLEGEND")),
                                      br(),
                                      br(),
                                      tabBox (
                                        width  = 12,
                                        # Table INPUT, SIGNIF, PROCESSES
                                        tabPanel(title  = "All Processes",
                                                 DTOutput(outputId = "InputOriginalDataMult4")),
                                        tabPanel(title="Selected Multiple Processes",                      
                                                 DTOutput(outputId = "ProcessesDataSubsetMult4"))))


# 5. EXPLORE CELL CELLULAR COMPARTMENT   
# LOCATION: "MULTIPLE PROCESSES" (left-hand side menue tab)
menue_tab_exp_cellular_compartment_body = tabItem( "menue_tab_exp_cellular_compartment",
                                                     h1("Explore Cellular Compartment Localizations"),
                                                     title = "Explore Cellular Compartment Localization",
                                                     #Plot
                                                     helpText("Explore cellular compartment localization (Human)"),  
                                                     
                                                     # # Loading message
                                                     div(id = "loading-content5",
                                                         h4("Loading Data...")),
                                                     plotlyOutput(outputId = "CellularCompartmentLocalPlot"),
                                                     br(),
                                                     br(),
                                                     tabBox (
                                                       width  = 12,
                                                       # Table INPUT, SIGNIF, PROCESSES
                                                       tabPanel(title  = "All Processes",
                                                                DTOutput(outputId = "InputOriginalDataMult5")),
                                                       tabPanel(title="Selected Cellular Compartment(s)",                      
                                                                DTOutput(outputId = "ProcessesDataSubsetMult5"))))

# NOTE: dont use anymore
# menue_tab_exit_body = tabItem ( "menue_tab_exit",
#                                 h1("Exit Application"),
#                                 p("Are you sure you would like to exit the application?"),
#                                 actionButton ("ExitApplication",
#                                               "Exit") )
# ===================================================================================================================================
#  --------------------------------------- END --------------------------------------- "EXPLORE PLOT VALUES"
# ===================================================================================================================================



# ===================================================================================================================================
# ===================================================================================================================================
# III. SOFTWARE NAVIGATION BUTTONS
# ===================================================================================================================================
# ===================================================================================================================================
# OPEN FILE
menue_tab_file_open_body = tabItem("menue_tab_file_open",
                                   h1("Open File"),
                                   ui_file_input_diag)

# DOWNLOAD PLOT
menue_tab_download_plot_body = tabItem("menue_tab_download_plot",
                                       ui_download_plot)

# DOWNLOAD TABLE
menue_tab_download_table_body = tabItem ("menue_tab_download_table",
                                         ui_download_table)

# ABOUT 
menue_tab_help_body = tabItem ("menue_tab_about",
                               h1("About"),
                               includeHTML("www/AboutPage2.html"))

# HELP 
menue_tab_about_body = tabItem ("menue_tab_help",
                                h1("Help"),
                                includeHTML("www/HelpPage2.html"))
# ===================================================================================================================================
# --------------------------------------- END --------------------------------------- "SOFTWARE NAVIGATION BUTTONS"
# ===================================================================================================================================





# ====================================================================
# ====================================================================
# ====================================================================
# MAIN USER INTERFACE CONTAINER
# ====================================================================
# ====================================================================
# ====================================================================
ui = dashboardPagePlus(skin = "yellow",
                       
                       dashboardHeaderPlus(
                         dropdownMenuOutput("UI_NOTIFICATIONS"),
                         enable_rightsidebar = FALSE,
                         rightSidebarIcon    = "gears",
                         title               = "OmicsVolcano"),
                       
                       ui_dash_sidebar,
                       # alternative right sidebar
                       
                       dashboardBody (useShinyjs(),
                                      fluidRow (width = 12,
                                                ui_info_box),
                                      fluidRow (
                                        column(width = 8,
                                               fluidRow (
                                                 width = 12,
                                                 tabItems (
                                                   menue_tab_file_open_body,
                                                   menue_tab_home_body,
                                                   menue_tab_exp_plot_body,
                                                   menue_tab_exp_genelist_body,
                                                   menue_tab_exp_mitproc_body,
                                                   menue_tab_exp_multiple_mitoprocesses_body,
                                                   menue_tab_exp_cellular_compartment_body,
                                                   menue_tab_download_plot_body,
                                                   menue_tab_download_table_body,
                                                   menue_tab_help_body,
                                                   menue_tab_about_body       #        menue_tab_exit_body
                                                   )
                                                 )),
                                        column (width = 4,
                                                function_para_tabs) ))  )





# ====================================================================
# ====================================================================
# ====================================================================
# PACKAGES VERSION
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



