
#
#
# PLEASE COMMENT THIS LINE OUT IF THE BASE DIRECTORY CAN'T BE FOUND AND ADD THE
# BASIC DIRECTORY OF THE FILE, WHERE THE SOFTWARE PACKAGE IS LOCATED. DEFAULT
# VALUE FOR THIS ENTRY IS ./
CONST_BASE_DIRECTORY = './'


# DO NOT CHANGE!:

# LINK TO DEMONSTRATION / EXAMPLE FILE LOCATION ON THE SERVER
CONST_DEMO_FILE = "data/mm_input.txt"


# 
# # Standard configuration files / input files /tables etc.
# CONST_REFFILES_MM_RIBOS
# CONST_REFFILES_MM_PROCESS
# CONST_REFFILES_HS_RIBOS
# CONST_REFFILES_HS_PROCESS
# 
# 
# 
# #C:/Users/Murzilanka Circos/Desktop/ShinyForArtur/ReferenceFiles/Mouse/mm_Ribosomal_processes19March20.txt
# mm_ribos_file = read.table("./ReferenceFiles/Mouse/mm_Ribosomal_processes19March20.txt",
#                            header = T,
#                            sep    = "\t",
#                            fill   = T,
#                            quote  = "")   # dim = 82 x 3 | yourlist  Entry  Entry.name Protein.names Gene.names Organism
# 
# # mm_processes_file = read.table("//uniwa.uwa.edu.au/userhome/staff8/00090658/Desktop/0_Shiny_db/MitoCarta_MitoXplorer_AF_5March2020.txt",
# mm_processes_file = read.table("./ReferenceFiles/Mouse/mm_MitoCarta_MitoXplorer_AF_2April2020.txt",
#                                header = T,
#                                sep    = "\t",
#                                fill   = T, 
#                                quote  = "")   # dim = 1495  x 3 | GeneID Symbol Description Synonyms Maestro.score FDR Evidence Tissues
# 
# ##########################################################################################################
# # II Reference Files HUMAN
# ##########################################################################################################
# # hs_ribos_file = read.table("//uniwa.uwa.edu.au/userhome/staff8/00090658/Desktop/2019/0_mito_db/LSU_portienEntries.txt",
# hs_ribos_file = read.table("./ReferenceFiles/Human/hs_ribosomal_30March2020.txt",
#                            header = T,
#                            sep    = "\t",
#                            fill   = T,
#                            quote  = "")[, c(2,3,4)] # dim = 82  x 4
# 
# # hs_processes_file = read.table("//uniwa.uwa.edu.au/userhome/staff8/00090658/Desktop/0_Shiny_db/MitoCarta_MitoXplorer_AF_5March2020.txt",
# hs_processes_file = read.table("./ReferenceFiles/Human/hs_MitoCarta_MitoXplorer_AF_2April2020.txt",
#                                header = T,
#                                sep    = "\t",
#                                fill   = T, 
#                                quote  = "")[,c(1,2,3,4)]   # dim(1516    5)
# 
