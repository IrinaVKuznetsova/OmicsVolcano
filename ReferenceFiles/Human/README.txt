2 April 2020

Ribosomal infomation taken from The ben group
MitoCarta 2.0 
MitoXplorere 


30 March 2020


PART I ****************************************************
1. Download MitoCarta and Interactome Human files from dbs
2. Use 0_extract_proteinIDs_fromMitoCarta.py to formatted     # Python scripts are from G:\2019\0_mito_db
3. Use 1_Combine_mitoXplorer_MitoCarta_genes.py to COMBINE MitoCarta and MitoXplorer

initial MitoCarta = 1158
initial mitoXplorer = 1229

combined = 1516
358 genes unique to MitoXplorer
287 unique only to MitoCarta
871 in both datasets 

validation:
358+871 = 1229
287+871 = 1158


PART II ****************************************************
Ribosomal 

mammalian mitoribosome info taken from: https://bangroup.ethz.ch/
retrived from UniProt UP000005640
UniProt release 2020_01

[cite]
The UniProt Consortium
UniProt: a worldwide hub of protein knowledge
Nucleic Acids Res. 47: D506-515 (2019)


### copied from MTIF3 file ******************************************************************
# # 14 January 2019
0) Info downloaded from MIG (Gene Ontology Browser ) | http://www.informatics.jax.org/vocab/gene_ontology 
or direct link to GO ontology www.informatics.jax.org/go/term/GO:0006119
file name ="0_GO_term_summary_20181219_204331"
N=298 total number of gene names

1) Get Gene ids from "Symbol", "O" & "T" columns, and remove duplicates | Excel- Data- Data tools- Remove duplicates
file name ="1_UniqueGeneNames"
N=185 unique gene names

2) Retrieve protein IDs for these genes
https://www.uniprot.org/uploadlists/ | From "gene names" - To "UniProtKB" - mus musculus

Reviewed- 182 UniProtKB IDs in the table; 181-unique; O88430 & P48410 duplicated from Abcd1 gene, 
Abcd1	O88430 is removed from the file as this is a protein entry that is related to Ccl22 gene.
 
Unreviewed 463
Protein names 

With R script "0_CompareGeneList_to_Retrieved.r" find missing genes, retrievd them from UniPot again, add manually to a 
file = "2_Final_OXPHO_Retrieved"
### copied from MTIF3 file ******************************************************************


PART III ****************************************************
MIG-mouse Gene Ontology Browser  regulation of oxidative phosphorylation

GO:0006119  Term:	oxidative phosphorylation