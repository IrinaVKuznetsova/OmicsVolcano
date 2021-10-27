#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# OmicsVolcano V1.1
#
# UPDATED !!!!!!!!!!!!!!!!!!!!
# 
# The initial version of OmicsVolcano used shinydashboardPlus() v.0.7.5 function,
# which has been depreciated. 
# The software has updated version of shinydashboardPlus() v.2.0.0 now.
#
# rightSidebar() is replaced with dashboardControlbar()
#
# fontawesome package has been added |  packageVersion("fontawesome") - '0.2.2'
#
# The software has been tested on R version 4.1.1 (2021-08-10) "Kick Things"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




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
# install.packages("fontawesome")





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
  "shinyjs",
  "colourpicker",
  "gridExtra",
  "fontawesome" # 2021 | icon management has changed in newer shiny version (the initial script was developed in R-3.6.1)
  )
    



package.check = lapply(
  req_packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }
)


#
# Change development environment: homepc, university
#
Sys.setenv(R_CONFIG_ACTIVE = "homepc")



options(shiny.maxRequestSize = 900 * 1024 ^ 2)   # Increase file size for upload | https://shiny.rstudio.com/articles/upload.html

# source('config.r')
# source('OmicsVolcano_Server.r')
# source('OmicsVolcano_UI.r', local=TRUE)

source('config.r')
source('OmicsVolcano_v1_1_Server.r')
source('OmicsVolcano_v1_1_UI.r', local=TRUE)

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


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# START
# October 2021
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 
# > sessionInfo()
# R version 4.1.1 (2021-08-10)
# Platform: x86_64-w64-mingw32/x64 (64-bit)
# Running under: Windows 10 x64 (build 19043)
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
#   [1] fontawesome_0.2.2        gridExtra_2.3            colourpicker_1.1.1       shinyjs_2.0.0           
# [5] shinythemes_1.2.0        shinydashboardPlus_2.0.3 config_0.3.1             crosstalk_1.1.1         
# [9] stringr_1.4.0            svglite_2.0.0            DT_0.19                  plotly_4.10.0           
# [13] ggplot2_3.3.5            shinyWidgets_0.6.2       shinydashboard_0.7.2     dplyr_1.0.7             
# [17] shiny_1.7.1             
# 
# loaded via a namespace (and not attached):
#   [1] Rcpp_1.0.7        tidyr_1.1.4       assertthat_0.2.1  digest_0.6.28     utf8_1.2.2        mime_0.12        
# [7] R6_2.5.1          evaluate_0.14     httr_1.4.2        pillar_1.6.4      rlang_0.4.11      lazyeval_0.2.2   
# [13] data.table_1.14.2 miniUI_0.1.1.1    jquerylib_0.1.4   rmarkdown_2.11    labeling_0.4.2    htmlwidgets_1.5.4
# [19] munsell_0.5.0     compiler_4.1.1    httpuv_1.6.3      xfun_0.26         pkgconfig_2.0.3   systemfonts_1.0.3
# [25] htmltools_0.5.2   tidyselect_1.1.1  tibble_3.1.5      fansi_0.5.0       viridisLite_0.4.0 crayon_1.4.1     
# [31] withr_2.4.2       later_1.3.0       grid_4.1.1        jsonlite_1.7.2    xtable_1.8-4      gtable_0.3.0     
# [37] lifecycle_1.0.1   DBI_1.1.1         magrittr_2.0.1    scales_1.1.1      stringi_1.7.5     cachem_1.0.6     
# [43] promises_1.2.0.1  bslib_0.3.1       ellipsis_0.3.2    generics_0.1.0    vctrs_0.3.8       tools_4.1.1      
# [49] glue_1.4.2        purrr_0.3.4       fastmap_1.1.0     yaml_2.2.1        colorspace_2.0-2  knitr_1.36       
# [55] sass_0.4.0   
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# October 2021
# END
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# sessionInfo()
# R version 4.0.3 (2020-10-10)
# Platform: x86_64-w64-mingw32/x64 (64-bit)
# Running under: Windows 10 x64 (build 18363)
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
#   [1] gridExtra_2.3            colourpicker_1.1.0       shinyjs_2.0.0            shinythemes_1.2.0        shinydashboardPlus_0.7.5
# [6] config_0.3.1             crosstalk_1.1.1          stringr_1.4.0            svglite_1.2.3.2          DT_0.17                 
# [11] plotly_4.9.3             ggplot2_3.3.3            shinyWidgets_0.5.6       shinydashboard_0.7.1     dplyr_1.0.3             
# [16] shiny_1.6.0             
# 
# loaded via a namespace (and not attached):
#   [1] Rcpp_1.0.6        tidyr_1.1.2       assertthat_0.2.1  digest_0.6.27     mime_0.9          R6_2.5.0          evaluate_0.14    
# [8] httr_1.4.2        pillar_1.4.7      gdtools_0.2.3     rlang_0.4.10      lazyeval_0.2.2    data.table_1.13.6 miniUI_0.1.1.1   
# [15] jquerylib_0.1.3   rmarkdown_2.6     labeling_0.4.2    htmlwidgets_1.5.3 munsell_0.5.0     tinytex_0.29      compiler_4.0.3   
# [22] httpuv_1.5.5      xfun_0.20         pkgconfig_2.0.3   systemfonts_0.3.2 htmltools_0.5.1.1 tidyselect_1.1.0  tibble_3.0.5     
# [29] viridisLite_0.3.0 crayon_1.4.0      withr_2.4.1       later_1.1.0.1     grid_4.0.3        jsonlite_1.7.2    xtable_1.8-4     
# [36] gtable_0.3.0      lifecycle_0.2.0   DBI_1.1.1         magrittr_2.0.1    scales_1.1.1      cachem_1.0.1      stringi_1.5.3    
# [43] promises_1.1.1    bslib_0.2.4       ellipsis_0.3.1    generics_0.1.0    vctrs_0.3.6       tools_4.0.3       glue_1.4.2       
# [50] purrr_0.3.4       fastmap_1.1.0     yaml_2.2.1        colorspace_2.0-0  knitr_1.31        sass_0.3.1  



####################################################################
# was developed with this R verssion
####################################################################
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





