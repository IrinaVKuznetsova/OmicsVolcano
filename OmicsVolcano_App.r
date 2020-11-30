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
# install.packages("colourpicker") # colour palette






# ====================================================================
# ====================================================================
# ====================================================================
# Required libraries
# ====================================================================
# ====================================================================
# ====================================================================

req_packages = c(
  "dplyr",
  "shiny",
  "shinydashboard",
  "shinyWidgets",
  "plotly",
  "DT",
  "ggplot2",
  "svglite",
  "stringr",
  "crosstalk",
  "config",
  "shinydashboardPlus",
  "shinythemes",
  "shinyalert",
  "shinyjs",
  "colourpicker",
  "cowplot",      # for extracting only legend from the plot
  "gridExtra"
  )
  # "ggpubr" 
    # colour palette       



package.check = lapply(
  req_packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }
)

# library(dplyr)             # v 0.8.3
# library(shiny)             # v '1.4.0'
# library(shinydashboard)    # v '0.7.1'
# library(shinyWidgets)
# library(plotly)            # v '4.9.1'
# library(DT)                # v '0.12'
#
# library(ggplot2)           # v '3.2.1'
# library(svglite)           # v '1.2.2'
# library(stringr)           # v '1.4.0'
# library(crosstalk)         # v '1.0.0'
# library(config)
# library(colourpicker)      # v.'1.1.0'
# library(htmltools)         # v.0.4.0   na

#
# Change development environment: homepc, university
#
Sys.setenv(R_CONFIG_ACTIVE = "homepc")


`%then%` <-
  shiny:::`%OR%` # Note: %then% does not exist in current preview implementations of Shiny.
#       You can use the first line of code below to create a %then% operator.
#       https://shiny.rstudio.com/articles/validation.html


options(shiny.maxRequestSize = 900 * 1024 ^ 2)   # Increase file size for upload | https://shiny.rstudio.com/articles/upload.html

source('config.r')
source('OmicsVolcano_Server.r')
source('OmicsVolcano_UI.r', local=TRUE)

print("Current working directory: ")
print(getwd())

shinyApp(ui = ui, server = server)





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
# Running under: Windows 10 x64 (build 18363)
# 
# Matrix products: default
# 
# Random number generation:
#   RNG:     Mersenne-Twister 
# Normal:  Inversion 
# Sample:  Rounding 
# 
# locale:
#   [1] LC_COLLATE=English_Australia.1252  LC_CTYPE=English_Australia.1252    LC_MONETARY=English_Australia.1252
# [4] LC_NUMERIC=C                       LC_TIME=English_Australia.1252    
# 
# attached base packages:
#   [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
#   [1] gridExtra_2.3            colourpicker_1.1.0       shinyjs_2.0.0            shinyalert_1.1          
# [5] shinythemes_1.1.2        shinydashboardPlus_0.7.5 config_0.3               crosstalk_1.0.0         
# [9] stringr_1.4.0            svglite_1.2.3            DT_0.12                  plotly_4.9.1            
# [13] ggplot2_3.2.1            shinyWidgets_0.5.0       shinydashboard_0.7.1     dplyr_0.8.3             
# [17] shiny_1.4.0             
# 
# loaded via a namespace (and not attached):
#   [1] xfun_0.12             tidyselect_0.2.5      purrr_0.3.3           colorspace_1.4-1      vctrs_0.2.2          
# [6] miniUI_0.1.1.1        htmltools_0.4.0       viridisLite_0.3.0     yaml_2.2.1            rlang_0.4.2          
# [11] later_1.0.0           pillar_1.4.3          glue_1.3.1            withr_2.1.2           gdtools_0.2.1        
# [16] lifecycle_0.1.0       munsell_0.5.0         gtable_0.3.0          htmlwidgets_1.5.1     evaluate_0.14        
# [21] knitr_1.28            fastmap_1.0.1         httpuv_1.5.2          Rcpp_1.0.3            xtable_1.8-4         
# [26] promises_1.1.0        scales_1.1.0          EnhancedVolcano_1.4.0 jsonlite_1.6.1        mime_0.9             
# [31] systemfonts_0.1.1     digest_0.6.23         stringi_1.4.4         ggrepel_0.8.1         grid_3.6.1           
# [36] tools_3.6.1           magrittr_1.5          lazyeval_0.2.2        tibble_2.1.3          crayon_1.3.4         
# [41] tidyr_1.0.2           pkgconfig_2.0.3       data.table_1.12.8     rmarkdown_2.3         assertthat_0.2.1     
# [46] httr_1.4.1            rstudioapi_0.11       R6_2.4.1              compiler_3.6.1





