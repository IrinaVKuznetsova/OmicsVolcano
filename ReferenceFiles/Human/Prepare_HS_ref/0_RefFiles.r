# 28 March 2020


# Rask: REF.FILES


# I.
# oxpho_file = read.table("//uniwa.uwa.edu.au/userhome/staff8/00090658/Desktop/2019/0_mito_db/OXPHO_proteinEntries.txt",
oxpho_file = read.table("C:/Users/Murzilanka Circos/Desktop/2020/0_mito_db/OXPHO_proteinEntries.txt",
                        header = T,
                        sep    = "\t",
                        fill   = T,
                        quote  = "")   # dim = 183  x 6 | yourlist Protein.Entry  Entry.name Protein.name Gene.names Organism
dim(oxpho_file) # dim = 183
head(oxpho_file)

oxpho_fun = rep("OXPHOs", nrow(oxpho_file))  
length(oxpho_fun) # 183
oxpho_file["Process"] = oxpho_fun
oxpho_final = oxpho_file[, c(1, 4, 7)] 
colnames(oxpho_final) = c("GeneName", "Description", "Process")
head(oxpho_final)
dim(oxpho_final)  #183   3
write.table(oxpho_final, file="C:/Users/Murzilanka Circos/Desktop/2020/0_mito_db/OXPHO_processes19March20.txt", sep="\t", quote = F)


# II.
# ribos_LSU_file = read.table("//uniwa.uwa.edu.au/userhome/staff8/00090658/Desktop/2019/0_mito_db/LSU_portienEntries.txt",
ribos_LSU_file = read.table("C:/Users/Murzilanka Circos/Desktop/2020/0_mito_db/LSU_portienEntries.txt",
                            header = T,
                            sep    = "\t",
                            fill   = T,
                            quote  = "")   # dim = 52 x 6 | yourlist  Entry  Entry.name Protein.names Gene.names Organism
dim(ribos_LSU_file) # dim = 52 6

# ribos_SSU_file = read.table("//uniwa.uwa.edu.au/userhome/staff8/00090658/Desktop/2019/0_mito_db/SSU_portienEntries.txt",
ribos_SSU_file = read.table("C:/Users/Murzilanka Circos/Desktop/2020/0_mito_db/SSU_portienEntries.txt",
                            header = T,
                            sep    = "\t",
                            fill   = T,
                            quote  = "")   # dim = 30 x  6 | yourlist  Entry  Entry.name Protein.names Gene.names Organism
dim(ribos_SSU_file) # dim = 30 6

ribos_file = rbind(ribos_LSU_file, ribos_SSU_file) # dim = 82 x 6
dim(ribos_file) # dim = 82
head(ribos_file)

ribos_fun = rep("Ribosomal", nrow(ribos_file))  
length(ribos_fun) # 82
ribos_file["Process"] = ribos_fun
ribos_final = ribos_file[, c(1, 4, 7)] 
colnames(ribos_final) = c("GeneName", "Description", "Process")
head(ribos_final)
dim(ribos_final)  # 82  3
write.table(ribos_final, file="C:/Users/Murzilanka Circos/Desktop/2020/0_mito_db/Ribosom_processes19March20.txt", sep="\t", quote = F)


# III.
# mitocarta_mitoxplorer = read.table("//uniwa.uwa.edu.au/userhome/staff8/00090658/Desktop/0_Shiny_db/FUll_MitoCarta_mitoXplorer_25feb.txt",
full_file = read.table("C:/Users/Murzilanka Circos/Desktop/2020/0_mito_db/MitoCarta_MitoXplorer_AF_5March2020.txt",
                       header = T,
                       sep    = "\t",
                       fill   = T, 
                       quote  = "")  
head(full_file)


# IV COMBINE rbind
full_file0 = rbind(mitocarta_mitoxplorer, ribos_final, oxpho_final)
full_file = full_file0[ order(full_file0$Process), ] 
dim(full_file)    # 1760    3

# 82+183+1495





#   
# d=data.frame( "GeneName" = "DNAJA1",
#               "Description" = "The protein encoded by this gene is a member of the DnaJ family, whose members act as cochaperones of heat shock protein 70. Heat shock proteins facilitate protein folding, trafficking, prevention of aggregation, and proteolytic degradation. Members of this family are characterized by a highly conserved N-terminal J domain, a glycine/phenylalanine-rich region, four CxxCxGxG zinc finger repeats, and a C-terminal substrate-binding domain. The J domain mediates the interaction with heat shock protein 70 to recruit substrates and regulate ATP hydrolysis activity. Mice deficient for this gene display reduced levels of activation&#8208;induced deaminase, an enzyme that deaminates deoxycytidine at the immunoglobulin genes during immune responses. In addition, mice lacking this gene exhibit severe defects in spermatogenesis. Several pseudogenes of this gene are found on other chromosomes. Alternative splicing results in multiple transcript variants.",
#               "Process" = "Protein Stability & Degradation")
# head(d)
# dim(d)
# 
# write.table(d, file="one.txt", sep="\t", quote = F, row.names = F)
# 
# datad = read.table("//uniwa.uwa.edu.au/userhome/staff8/00090658/Desktop/0_Shiny_db/one.txt",
#                    # full_file = read.table("C:/Users/Murzilanka Circos/Desktop/2020/0_mito_db/MitoCarta_MitoXplorer_AF_5March2020.txt",
#                    header = T,
#                    sep    = "\t",
#                    fill   = T, 
#                    quote  = "") 
# 
# dataa = rbind(mitocarta_mitoxplorer, d)              
# dim(dataa)
# head(dataa)
# 
# 
# 
# write.table(d, file="FUll_MitoCarta_mitoXplorer_25feb.txt", sep="\t", quote = F)
# 
# 
# ############  
