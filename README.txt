

SHINY:
- right context menue generated on server
  (plot, custome gene list, mito process)
  standard thresshold per default
  -> only activated if one of the three
  is selected
  -> others: nothging to select or help 
  texts


STATUS HANDLING
- General
  - filename
- Threshold
  - Plot vertical threshold
  - significance
- Custom Gene List
  - list of genes OR gene file
- Process
  - Mouse OR Human
  - show mito proces

Status Message
  - general status message into some place (e.g. one line or so into the header)
  - or as messages in the header menue


- status menue should display the values
  of the selections in the config menue

UI Improvements
- make nicer descriptions in the different processes, and style pages better for
  the processes
- design logo, and display it on the dashboard
- add about info onto the left dashbaord (copyright, authors, etc.)
- style the front page better
- irina's colour scheme
OK - add about tab: menue_tab_about
OK - add help tab: menue_tab_help
- insert main body into some nicer box (e.g. file open, processes, etc.)
- resolve issue with NULL in the help text, when no left menue is selectedh

NEW TABS
menue_tab_help + help text
menue_tab_about + about text








FILE LOADING
- if a file is stored as a csv file with a tab, and e.g. loaded as comma separated file the software crashes as teh variables are uploaded accross teh software




MENUE VARIABLES (DONT CHANGE THIS)
==============================================
TAB NAMES
FILE
menue_tab_home
menue_tab_file_open
- UI_INPUT_FILE_REMOVE_DUPLICATES
- UI_INPUT_FILE_HASHEADER
- UI_INPUT_FILE_SEPARATOR
- UI_INPUT_FILE_NAME

menue_tab_file_close

EXPLORE
menue_tab_exp_plot
menue_tab_exp_genelist
menue_tab_exp_mitproc

EXPORT
menue_tab_download_plot
menue_tab_download_table


UI ELEMENTS
ui_threshold_configuration
ui_explore_custom_gene_list
ui_explore_mitrochondrial_process

ui_download_plot
ui_download_table



MENUE
=================================

HOME

FILE
- Open File...
- Open & Convert File...
 (duplicates removal -> extension, Open File and remove duplicates
- Save Demo File...
- Close

DOWNLOAD PLOT
- Save Mitrochindal processes
- Save Plot values
- Explore Gene list
filetiypes: svg, pdf, jpg, tiff, png

DOWNLOAD TABLE
- Save Significance Table...
- Save Processes Table...
types: csv, txt

CONTACT


Home
Converter
Visualize



SIDEBAR
================================
Vertical plot threshold (steps 0-inf, step 0.5), type in or select, etc.
Significance slider 0 - 0.1


MODES
================================

Explore plot
Explore custom gene list
-> text box with gene list
-> alternatively upload file as gene list

Explore mitrochondrial processes
-> selected list
-> Mouse or Human (boxes)




- define base directory
- create config file


user interface
- green  numbers in significance
- radio buttons vertically align text in the middle / center
- example file as a button e.g.


example file button in UI file:
"Example File",
                                                                      download ="mm_input.txt"),
                                                    multiple = TRUE,

- no computer dependend class/file pathes
- color shemes / gray on turkise too dark
- error handling - how?
- significance slider - colour tourqwuise / red --> misleading
  -> slider has wrong colours / jumps at the end just to red
- drawing window resizing shoudl go automatically (if it fits) / event management
- different dots don't highlight after a windows resize


left menue
- plot vertical threshold shoudl have some e.g. dashed line, colour, etc. to identify it in the graphics
- plot sginficance the same - shoudl be identifyable in the drawing visually


Menue structure
- display menues only if they are relevant (e.g. disactivate them, when not required)
- same with mito process


Explore custom plot
- misleading eitehr file / or typing?
- change Or Submit a file
--> tickbox or similar and deactivate the not used one

Tabs
- change Tab names that they correlate (e.g. I. Explore Plot, II. Explore Custom Gene List

- Rename "Explore Custom Input" to "Explore Custome Gene List"
- Rename "Explore Mito" to "Explore Mitrochnotrial Processes"

Order of the left side module:
FIXED
 - Select Input
 - Download
 
 FLOATING / Reactivating dependend on selected Tab
  - Explore Plot
  - Explore Custom Gene List
  - Explore Mitrochindiral Processes
  
  
LEFT SIDE PANEL
- add text and email who developed it
- add some images
- add icon of the software
  
  
  SIGINFICANCe
  <= 50 (add <=)
  
  
- add into status menue the file name, duplicates presents, etc.



.skin-blue .sidebar-menu > li.active > a,
.skin-blue .sidebar-menu > li:hover > a {
  border-left-color: #ff0000;
}

