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

**Software Download**
1. Anyone with RStuio can use the OmicsVolcano software. If you don’t have RStuio follow the installation instructions. You need to install both R and RStudio. For R [https://www.r-project.org/](https://www.r-project.org/) and RStudio [https://rstudio.com/products/rstudio/download/](https://rstudio.com/products/rstudio/download/)  
1. Download the OmicsVolcano software from GitHub repository as zip folder (Clone or Download; Download ZIP). Unzip folder into a directory of your choice. For example, to the desktop  
1. Open RStudio   
1. Select R script with App prefix (File – Open File ..  – App.r). To run the software, click  ![Run App](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/docs/images/RunApp_image.jpg)  

--  
**Software Icons**
1. The software will appear as a webpage interface in a default browser   
 <img align="center" src="https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/docs/images/AppLook_image.jpg">  
1.  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/docs/images/FileTabIcon_image.jpg)  enables to upload user`s input file      

1.  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/docs/images/ExploreIcon_image.jpg)  enables to select one of three plot`s functionality: such as explore entire plot and visualize labels of any selelcted data points; or visualize a custom list of genes; or visualize a mitochodrial process(es)   

1.  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/docs/images/ExportIcon_image.jpg)  enables to download generated plot. Also, a table that represents significant results or mitochodrial process(es)   

1.  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/docs/images/HelpIcon_image.jpg)  provides breife description of help images   

1.  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/docs/images/AboutIcon_image.jpg)  proides infomation about authors, license, used packages and their versions, citation   

1.  ![tab](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/docs/images/SettingsIcon_image.jpg)  enables to setup settings  


--  
**File Tab**  
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


--  
**Explore Tab**  
* **Plot** tab enables to explore entire plot and visualize any clicked gene labels  
* **Custom Gene List** tab enables to visualis custom genes of interest   
* **Mitochondrial Process** tab enables to explore mitochodrial processes present in the data  


--  
**Export Tab**  
* **Plot** enables to download image in selected format, such as SVG, PDF, JPEG, PNG, TIFF  
* **Table** emables to download table in selected format, such as CSV or TXT  









