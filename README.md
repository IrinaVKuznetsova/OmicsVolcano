# OmicsVolcano

```diff
! *OmicsVolcano Version 1.0 is available 06/05/2020  
```

### Don't know where to start? Start at [Help Page](https://github.com/IrinaVKuznetsova/OmicsVolcano/tree/master/docs/HelpPage.md)

 
General Usage Notes  
------

**Description:** OmicsVolcano is the R software for intuitive visualization and interactive exploration of high throughput biological data in a volcano plot. Unique feature of this software is the possibility to explore Mitochodrial Process(es) present in the data  


**Software workflow:**  
**Note:** Anyone with RStudio can use the OmicsVolcano software   
&nbsp;&nbsp;&nbsp;(Step 1) Checks presence of duplicated gene names in the input file. Provides a numeric extension 1,2,3.. to gene names that are duplicated  
&nbsp;&nbsp;&nbsp;(Step 2) Represents data as volcano plot, and enables interactive way of exploring plot   
&nbsp;&nbsp;&nbsp;(Step 3) Exports results as an image in selected format  


Input Data Format  
------
**Note:** Input file can be tab, comma or semicolon separated format saved as a text file. It should contain five columns with the same column names as shown below 

| ID | GeneSymbol | Description | Log2FC | AdjPValue
| - | - | - | - | - | 
Q4U4S6 | Xirp2 | Xin actin-binding repeat-containing protein 2 | 6.64 | 1.33E-08
Q497D7 | Rpl30 | Rpl30 protein | 2.14 | 0.8
Q9CPP6 | Ndufa5 | NADH dehydrogenase [ubiquinone] 1 alpha subcomplex subunit 5 | -1.52 | 6.24E-08
P09055 | Itgb1 | Integrin beta-1 | 0.08 | 6.29E-08
... | ... | ... | ... | ...


Version Control  
------ 
OmicsVolcano Version 1.0 R 3+     
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Tested on Windows 10  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; R version 3.6.1 (2019-07-05)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "dplyr" v.0.8.3  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "shiny" v.1.4.0  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "shinydashboard" v.0.7.1  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "shinyWidgets" v.0.5.1   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "plotly" v.4.9.1  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "DT" v.0.11  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "ggplot2" v.3.2.1  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "svglite" v.1.2.2  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "stringr" v.1.4.0   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "crosstalk" v.1.0.0  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "config" v.0.3  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "shinydashboardPlus" v.0.7.0  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "shinythemes" v.1.1.2   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "shinyjs" v.1.1  





## Example Image  
![visualization plot generated by OmicsVolcano](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/www/images/OmicsVolcano_example.svg)     


## Copyright Notice  
This project is licensed under the terms of the [**GNU version 3**](https://github.com/IrinaVKuznetsova/OmicsVolcano/blob/master/LICENSE.txt) general public license  

## Cite  
Kuznetsova I, Lugmayr A, Rackham O, Filipovska A. OmicsVolcano: software for intuitive visualization and interactive exploration of high throughput biological data. 2020  
 
 
## Software Developers 
Irina Kuznetsova | email: irina.kuznetsova@perkins.org.au  
Artur Lugmayr | email: lartur@acm.org   
 
 � Copyright (C) 2020  
https://github.com/IrinaVKuznetsova/OmicsVolcano.git  
  
 




