# get SNP calls for one chromosome
chr <- "<insert autosome>"

# data related to the SNP arrays are in /z/Proj/attie/kbroman/AttieDO/
dir <- "/z/Proj/attie/kbroman/AttieDO"

#########
### Accessing the genotype probabilities
########
# genotype probabilities (as arrays n_ind x 36 x n_markers) are in .../CalcGenoProb/attieDO_probs*.rds
# where * = 1, 2, ..., 19, X

# read in chromosome 
pr <- readRDS( file.path(dir, paste0("CalcGenoProb/attieDO_probs", chr, ".rds")) )

# we also need the physical map of the markers in these probabilities
pmap <- readRDS( file.path(dir, "CalcGenoProb/attieDO_pmap.rds") )

#########
### Accessing the founder SNP genotypes 
########
# genotypes for *all* SNPs in the genome for the 8 founder lines are in an SQLite database
#    .../DerivedData/ccfoundersnps.sqlite
sql_file <- file.path(dir, "DerivedData/ccfoundersnps.sqlite")
library(RSQLite)
db <- dbConnect(SQLite(), sql_file) # connect to database

# now, to grab ALL of the SNPs on the chr
snpinfo <- dbGetQuery(db, paste0("SELECT * FROM snps WHERE chr=='", chr, "'"))

# the alleles column is like "A|G" where A is the major allele and G is the minor allele
# some "complex" SNPs will be like "A|G/C" where there are multiple possiblities for the minor allele
# let's drop those
complex <- grepl("/", snpinfo$alleles, fixed=TRUE)
snpinfo <- snpinfo[!complex,] 


#########
### Getting imputed SNP genotype probabilitiess for these SNPs for all mice
########
# we need the qtl2scan package
#     user guide at http://kbroman.org/qtl2/assets/vignettes/user_guide.html
library(qtl2scan)

# we first need to create indexes connecting the SNP locations to the physical map for the genotype probabilities
#    - this returns only a portion of the snps...within the region defined by markers in pmap
#    - also, uses an indexing system for focus on subset of snps with distinct patterns
# this adds some columns to the "snps" object
snpinfo <- index_snps(pmap, snpinfo)

#### THIS is the part that causes the huge increase in memory later
#    will need to skip this
#
## force the subsequent code to work with *all* snps
##snpinfo$index <- 1:nrow(snpinfo)

# Now convert the genotype probabilities to SNP probabilities
snp_pr <- genoprob_to_snpprob(pr, snpinfo)

# we can use maxmarg() in the qtl2geno package to get imputed SNP genotypes
# also drop the surrounding list business and just make it a matrix
library(qtl2geno)
imp_snps <- maxmarg(snp_pr)[[1]]

# pull out the alleles from the SNP table
alleles <- strsplit(snpinfo$alleles, "\\|")
snpinfo$allele1 <- sapply(alleles, "[", 1)
snpinfo$allele2 <- sapply(alleles, "[", 1)

# save as .RData file
save(imp_snps, snpinfo, file=paste0("imp_snp_", chr, ".RData"))
