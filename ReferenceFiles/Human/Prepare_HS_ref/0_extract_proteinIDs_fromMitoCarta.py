# -*- coding: utf-8 -*-
"""
Created on Tue Oct  8 14:26:36 2019

@author: 00090658
"""



# Extract the protein IDs from mitocarta dataset

import os

os.chdir("C:/Users/Murzilanka Circos/Desktop/ShinyForArtur/00_RefFiles/Human")


# 1. FILE that contains protein IDs with gene names   *************************
file_genes = open("Human_MitoCarta2_0_28March2020.txt", "r")
file_write = open("IDs_Genenames_Human_MitoCarta_2.0.txt", "w")
l1= file_genes.readlines()[1:]


# 1.1 Iterate through file
file_write.write("MitoCarta Gene"+'\t'+"Protein ID"+"\n")
for char in l1:
    line_info = char.strip().split("\t")
    #print(line_info)
    synonyms = line_info[3].split(",")[-1]
   #print str(synonyms)
    gene = line_info[1]
    file_write.write(gene+"\t"+synonyms+"\n")
    
file_write.close()
  