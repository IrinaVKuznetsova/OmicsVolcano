# -*- coding: utf-8 -*-
"""
Created on Fri Nov  1 11:28:20 2019

@author: 00090658
"""

# -*- coding: utf-8 -*-
"""
Created on Thu Oct 31 11:08:29 2019

@author: 00090658


Subset RNA MitoCarta results of top ten TFs to MitoXplorer
"""

###################################################################################################################################
# 0. READ mitoXplorer & MitoCarta with TFs
################################################################################################################################### 
file_Xplorer = open("C:/Users/Murzilanka Circos/Desktop/ShinyForArtur/00_RefFiles/Human/Human_Interactome_28March2020.txt", "r")
line_Xplorer= file_Xplorer.readlines()[1:]    #


file_mitoCarta = open("C:/Users/Murzilanka Circos/Desktop/ShinyForArtur/00_RefFiles/Human/Human_MitoCarta2_0_28March2020.txt", "r")
line_mito = file_mitoCarta.readlines()[1:]    #

result = open("C:/Users/Murzilanka Circos/Desktop/ShinyForArtur/00_RefFiles/Human/1_missingInfo_human_mitoXplorer.txt", "w")
result.write("GeneName" + "\t" + "Description" + "\t"+ "Process" + "\n") # 



###################################################################################################################################
# 1. FIND HOW MANY MATCHES AND DIFFERENCE btw TWO datasets
################################################################################################################################### 

# All mitoXplorer genes -------------------------------------------------------
gene_lis_Xplorer2 = []    
for char1 in line_Xplorer:    # mitoXplorer
    line_info1 = char1.strip().split("\t")
    GeneSymbol = line_info1[0].upper()
    gene_lis_Xplorer2.append(GeneSymbol)

len(gene_lis_Xplorer2)  #1222
gene_lis_Xplorer2[0:5]


# All miotCarta genes ---------------------------------------------------------
mitoCarta_list =[]    #1158
for char2 in line_mito:   # MitoCarta
    line_info2 = char2.strip().split("\t")
    GeneName2 = line_info2[1].upper()
    mitoCarta_list.append(GeneName2)
    
len(mitoCarta_list) # 1158    
mitoCarta_list[0:5]



matches = [x for x in gene_lis_Xplorer2 if x in mitoCarta_list]
len(matches) # 871
matches[1:5]


diff = list(set(gene_lis_Xplorer2) - set(mitoCarta_list))
len(diff)   #358
diff[0:5]


test3=[]   # 337
for char1 in line_Xplorer:    # mitoXplorer
    line_info1 = char1.strip().split("\t")
    GeneSymbol = line_info1[0].upper()
    Process = line_info1[2]
    Function = line_info1[3]
    gene_lis_Xplorer2.append(GeneSymbol)
    if GeneSymbol in diff:
        test3.append([GeneSymbol, Function, Process,  "!! mitoXplorer gene ONLY !!!" ])
        result.write(str(GeneSymbol) + "\t"+ str(Function)+ "\t" + str(Process) + "\t"+ "!! mitoXplorer gene ONLY !!!" +  "\n")
    else:
        pass



###################################################################################################################################
# 2. ADD PROCESSES COLUMN
################################################################################################################################### 

# extract MitoCarta genes and no Mitocarat l1 and l2
# get no match 
test =[]                    # 885
test2 =[]                   # 273 
test3 = []                  #
len(test)


for char2 in line_mito:   # MitoCarta
    mito_carata_genes = []
    line_info2 = char2.strip().split("\t")
    #print line_info2
    GeneName2 = line_info2[1].upper()
    Descrip = line_info2[2]
    Synon = line_info2[3]
    
    gene_lis_Xplorer = []    
    for char1 in line_Xplorer:    # mitoXplorer
        line_info1 = char1.strip().split("\t")
        GeneSymbol = line_info1[0].upper()
        GeneID = line_info1[1]
        Process = line_info1[2]
        Function = line_info1[3]
        Chr = line_info1[4] 
        gene_lis_Xplorer.append(GeneSymbol)

        if GeneName2==GeneSymbol:
            test.append([GeneSymbol, Function, Process])   # 885 matches when gene name mito carta==gene name mitoXplorer
            result.write(str(GeneSymbol) + "\t" + str(Function) + "\t" + str(Process) + "\n") 
    
    if GeneName2 not in gene_lis_Xplorer:
        test2.append([GeneName2, Descrip, "NO MATCH" ])
        result.write(str(GeneName2) + "\t"+ str(Descrip)+ "\t" + "NO MATCH"+ "\t" + "!!!!NO MATCH!!!" +  "\n") 
    else:
        pass 
      
result.close()        



###################################################################################################################################
# 3. SUMMARY
################################################################################################################################### 

#•	885 matching genes between MitoCarta and mitoXplorer datasets
#•	273 genes that do not have processes/gene functionality  defined  
#•	337 genes that are not in MitoCarta dataset 































