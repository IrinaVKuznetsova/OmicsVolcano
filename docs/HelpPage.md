# OmicsVolcano Help Page


------  
Help Page  
------
Help page was designed to help you with the OmicsVolcano software  
**IMPORTANT** Mac OS users are required to install the [**XQuartz app**](https://www.xquartz.org)

Software Download and Usage
------
* Anyone with RStudio can use the OmicsVolcano software. If you don’t have RStudio follow the installation instructions. You need to install both R and RStudio latest version. The software works for R version 3.6.1 or above. For R [https://www.r-project.org/](https://www.r-project.org/) and RStudio [https://rstudio.com/products/rstudio/download/](https://rstudio.com/products/rstudio/download/)  
* Download the OmicsVolcano software from GitHub repository as zip folder ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/www/images/GitHubDownloadIcon_image.jpg) and  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/www/images/GitHubDownloadZIPIcon_image.jpg).  Unzip folder into a directory of your choice. For example, to the desktop  
* Open RStudio   
* Select R script OmicsVolcano_App.r (File – Open File ..  – OmicsVolcano_App.r). To run the software, click  ![Run App](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/www/images/RunApp_image.jpg). Make sure "Run External", which will load the software to the default web browser, or "Run in Window", which will load the software to R environment.  
* The software will appear as a webpage interface  

<img align="center" src="https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/www/images/AppLook_image.jpg">   


Software Icons  
------
  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/www/images/FileTabIcon_image.jpg)  **File** tab enables to upload users  input file      

  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/www/images/ExploreIcon_image.jpg)  **Explore** tab enables to select one of three plot`s functionality: (1) explore entire plot and visualize labels of any selected data points; (2) visualize a custom list of genes; (3) visualize a mitochondrial process(es)   

  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/www/images/ExportIcon_image.jpg)  **Export** tab enables to download generated plots and tables   

  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/www/images/HelpIcon_image.jpg)  **Help** tab provides brief description of the software usage     

  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/www/images/AboutIcon_image.jpg)  **About** tab provides information about authors, license, used packages and their versions, citation   


Plot Managment  
------
* Set significance and log2FC thresholds by using **Settings** tab located on the right side      
* **Windows users**: Hold **Shift** and **right click mouse** to select as many gene labels as desired   
**Mac users**: Hold **shift+command** / **Command** and **right click mouse** to select as many gene labels as desired   
**Note:** related information of the selected gene is represented in the table "InputData" below the plot   
* To disable any changes double click on the plot   
* Plot has own icons on the right top corner of the plot (become visible when hovering over). Icons enable to save image with selected gene labels in SVG format, to zoom, zoom in, zoom out, autoscale, show closest data on hover, compare data on hover  
* If the image/page is frozen refresh the browser page in which you are running the application  
* **IMPORTANT** if gene`s AdjPValue is not available, this gene will not be visualized! 
  
  
  
File Tab
------  
* Input file can be in tab, comma or semicolon separated format saved as a text file. It should contain five columns with the same column names as shown below  

| ID | GeneSymbol | Description | Log2FC | AdjPValue
| - | - | - | - | - | 
Q4U4S6 | Xirp2 | Xin actin-binding repeat-containing protein 2 | 6.64 | 1.33E-08
Q497D7 | Rpl30 | Rpl30 protein | 2.14 | 0.8
Q9CPP6 | Ndufa5 | NADH dehydrogenase [ubiquinone] 1 alpha subcomplex subunit 5 | -1.52 | 6.24E-08
P09055 | Itgb1 | Integrin beta-1 | 0.08 | 6.29E-08
... | ... | ... | ... | ...

* **Check for Duplicates** checks for the presence of duplicated gene names in the input file. Provides a numeric extension 1,2,3.... to gene names that are duplicated  
* **File Separator** character separation in the input file  
* **Download demo file to local PC...** option provides example file  


 
Explore Tab 
------
* **Plot** tab enables to visualize a gene label of any value represented on the plot  
&nbsp;&nbsp;&nbsp;&nbsp; * set significance and log2FC thresholds (**Settings** on the right side)      
&nbsp;&nbsp;&nbsp;&nbsp; * explore any value represented on the plot

 
* **Custom Gene List** tab enables to visualize custom list of genes of interest   
&nbsp;&nbsp;&nbsp;&nbsp; * set significance and log2FC thresholds (**Settings** on the right side)     
&nbsp;&nbsp;&nbsp;&nbsp; * type in own gene names separated by space or upload them as a file, where each gene name is on own row  

||
| - | 
| Ndufs2 |
| Gatc |
| Cox7a1 |
| lmnb1 |
| Ndufa8 |
| ... |  


* **Mitochondrial Process** tab enables to explore mitochondrial processes present in the data  
&nbsp;&nbsp;&nbsp;&nbsp; * default image highlights all mitochondrial genes present in the data vs nuclear genes  
&nbsp;&nbsp;&nbsp;&nbsp; * select organism  
&nbsp;&nbsp;&nbsp;&nbsp; * select process of interest  
**Note:** User can chose which gene label(s) of the selected process are seen on the plot    
 
 * **Mutliple Processes** tab enables to select and highlight in different colors multiple mitochodrial processes present in the data  
&nbsp;&nbsp;&nbsp;&nbsp; * select organism  
&nbsp;&nbsp;&nbsp;&nbsp; * select different processes of interest and assign colors  
&nbsp;&nbsp;&nbsp;&nbsp; * press Apply button  
**Note:** Same color can be assigned to different processes    
**Note:** To label plot points, hover over the plot's point of interest. The hover will indicate a gene name information with the same background color as the point of interest    


 * **Cellular Localization**  tab enables to explore cellular compartment localization  
&nbsp;&nbsp;&nbsp;&nbsp; * select cellular localization of interest from drop-down menue  
**Note:** Information is available only for Human data    
**Note:** User can choose which gene label(s) of the selected process are seen on the plot    



 
Export Tab
------
* **Plot** enables to download "Custom Gene List" plot in one of the selected formats, such as SVG, PDF, JPEG, PNG, TIFF  
* **Table** enables to download table in the selected format, such as CSV or TXT  



Support
------
Explore OmicsVolcano. Get general feeling how software works, it`s flow and functionality. You can use Demo to explore OmicsVolcano, which is provided in the **File** tab.
When you email your question please include OS you are using, R version, screenshort of the error message.

Irina Kuznetsova | email: irina.kuznetsova@perkins.org.au  
 
© Copyright (C) 2020  
https://github.com/IrinaVKuznetsova/OmicsVolcano.git  








