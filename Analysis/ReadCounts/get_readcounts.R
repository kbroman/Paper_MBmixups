# reduce pileup files to simpler readcount tables
dir <- "../Pileups"
files <- list.files(dir, pattern=".rds$")
# split list of files by sample ID
file_id <- sapply(strsplit(files, "_"), "[", 1)
file_chr <- sapply(strsplit(files, "_"), "[", 2)

# get SNP locations
snpdb <- "/z/Proj/attie/kbroman/AttieDO/DerivedData/ccfoundersnps.sqlite"
library(RSQLite)
db <- dbConnect(SQLite(), snpdb)
snp_info <- vector("list", 19)
names(snp_info) <- as.character(1:19)
cat("Grabbing SNP locations:\n")
for(chr in 1:19) {
    cat(" --", chr, "\n")
    snp_info[[chr]] <- dbGetQuery(db, paste0("select pos_Mbp,alleles from snps where chr=='", chr, "'"))
    snp_info[[chr]]$pos <- round(snp_info[[chr]]$pos_Mbp*1e6)
    tmp <- strsplit(snp_info[[chr]]$alleles, "\\|")
    snp_info[[chr]]$allele1 <- sapply(tmp, "[", 1)
    snp_info[[chr]]$allele2 <- sapply(tmp, "[", 2)

    # drop complex SNPs
    snp_info[[chr]] <- snp_info[[chr]][snp_info[[chr]]$allele2 %in% c("A", "C", "G", "T"),]
}
dbDisconnect(db)

for(i in seq_along(files)) {
    file <- files[i]
    cat(file, "\n")
    outfile <- paste0(file_id[i], "_", file_chr[i], "_readcounts", ".rds")
    if(file.exists(outfile)) next

    pileup <- readRDS(file.path(dir, file))

    # drop rows not in snp_info
    si <- snp_info[[file_chr[[i]]]]
    pileup <- pileup[pileup$pos %in% si$pos,]

    if(nrow(pileup)==0) next

    result <- data.frame(pos=unique(pileup$pos),
                         allele1=NA,
                         allele2=NA,
                         count1=0,
                         count2=0)
    result$allele1 <- si$allele1[match(result$pos, si$pos)]
    result$allele2 <- si$allele2[match(result$pos, si$pos)]

    counts <- tapply(pileup$count, list(pileup$pos, pileup$nucleotide), sum)
    counts[is.na(counts)] <- 0

    m <- match(result$pos, rownames(counts))
    for(a in c("A", "C", "G", "T")) {
        result[result$allele1==a,"count1"] <- counts[m,][result$allele1==a,a]
        result[result$allele2==a,"count2"] <- counts[m,][result$allele2==a,a]
    }

    saveRDS(result, file=outfile, compress=FALSE)
}
