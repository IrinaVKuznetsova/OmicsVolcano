# OmicsVolcano Help Page


```diff
! *OmicsVolcano Version 1.0 is available 06/05/2020  
```


© Copyright (C) 2020  
https://github.com/IrinaVKuznetsova/OmicsVolcano.git  


  
**Software developers:**  
Irina Kuznetsova | email: irina.kuznetsova@perkins.org.au  
Artur Lugmayr | email: lartur@acm.org  

------  


Help Page  
------


Software Download
------
* Anyone with RStuio can use the OmicsVolcano software. If you don’t have RStuio follow the installation instructions. You need to install both R and RStudio. For R [https://www.r-project.org/](https://www.r-project.org/) and RStudio [https://rstudio.com/products/rstudio/download/](https://rstudio.com/products/rstudio/download/)  
* Download the OmicsVolcano software from GitHub repository as zip folder (Clone or Download; Download ZIP). Unzip folder into a directory of your choice. For example, to the desktop  
* Open RStudio   
* Select R script with App prefix (File – Open File ..  – App.r). To run the software, click  ![Run App](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/docs/images/RunApp_image.jpg)  


Software Icons  
------

The software will appear as a webpage interface in a default browser   
 <img align="center" src="https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/docs/images/AppLook_image.jpg">   
 
  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/docs/images/FileTabIcon_image.jpg)  **File** tab enables to upload users  input file      

  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/docs/images/ExploreIcon_image.jpg)  **Explore** tab enables to select one of three plot`s functionality: such as explore entire plot and visualize labels of any selelcted data points; or visualize a custom list of genes; or visualize a mitochodrial process(es)   

  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/docs/images/ExportIcon_image.jpg)  **Export** tab enables to download generated plot. Tables show significant values or mitochondrial process(es)   

  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/docs/images/HelpIcon_image.jpg)  **Help** tab provides brief description of the software usage     

  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/docs/images/AboutIcon_image.jpg)  **About** tab provides information about authors, license, used packages and their versions, citation   

  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/docs/images/SettingsIcon_image.jpg)  **Settings** tab enables to setup settings  


Plot Managment  
------
* Set significance and logFC thresholds (**Settings** at right top corner)      
* Hold Shift and right click of the mouse to select as many gene labels as required  
**Note:** related information of the selected gene is represented in the table "InputData" below the plot   
* To disable any changes double click on the plot   
* Plot has own icons on the right top corner (visible when hovering with the mouse). Icons enable to save image with selected gene labels in SVG format, to zoom, zoom in, zoom out, autoscale, show closest data on hover, compare data on hover  
* If the image is frozen use browser Reload webpage button   
  
  
  
File Tab
------  
* Input file should contain five columns with exactly the same column names as shown below:  

| ID | GeneSymbol | Description | log2FC | AdjPValue
| - | - | - | - | - | 
Q4U4S6 | Xirp2 | Xin actin-binding repeat-containing protein 2 | 6.64 | 1.33E-08
Q497D7 | Rpl30 | Rpl30 protein | 2.14 | 0.8
Q9CPP6 | Ndufa5 | NADH dehydrogenase [ubiquinone] 1 alpha subcomplex subunit 5 | -1.52 | 6.24E-08
P09055 | Itgb1 | Integrin beta-1 | 0.08 | 6.29E-08
... | ... | ... | ... | ...

* **Remove Duplicates** checks for the presence of duplicated gene names in the input file. Provides a numeric extension 1,2,3.. to gene names that are duplicated  
* **File Separator** p[tion of character separtion in the input file  
* **Download demo file to local PC...** option provides example file  


 
Explore Tab 
------
* **Plot** tab enables to visualize a gene label of any value represented on the plot  
&nbsp;&nbsp;&nbsp;&nbsp; *set significance and logFC thresholds (**Settings** at right top corner)      
&nbsp;&nbsp;&nbsp;&nbsp; *explore any value represented on the plot

 
* **Custom Gene List** tab enables to visualize custom list of genes of interest   
&nbsp;&nbsp;&nbsp;&nbsp; *set significance and logFC thresholds (**Settings** at right top corner)     
&nbsp;&nbsp;&nbsp;&nbsp; *typein own gene names separated by space or upload file with  


* **Mitochondrial Process** tab enables to explore mitochodrial processes present in the data  
&nbsp;&nbsp;&nbsp;&nbsp; * initial image highlights all mitochodrial genes present in the data vs nuclear genes  
&nbsp;&nbsp;&nbsp;&nbsp; * select organism  
&nbsp;&nbsp;&nbsp;&nbsp; * select process of interest  
**Note:** User can chose which gene label(s) of the selected process are seen on the plot    
 

 
Export Tab
------
* **Plot** enables to download image in the selected format, such as SVG, PDF, JPEG, PNG, TIFF  
* **Table** emables to download table in the selected format, such as CSV or TXT  









