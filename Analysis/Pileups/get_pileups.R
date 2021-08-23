# run pileup for each chromosome on each of the paired and unpaired BAM files
broman::errors2pushbullet()


dir <- "/z/Proj/attie/aklobo/SortedIndexedBAM"
# typical paired reads file: "DO4_sample378_sorted.bam"
# typical unpaired reads file: "sample133_unpaired_sorted.bam"

library(tools)
library(Rsamtools)

files <- list.files(dir, pattern=".bam$")
# split list of files by sample ID
ids <- sapply(strsplit(files, "_"), function(a) grep("^sample", a, value=TRUE))
files_split <- split(files, ids)

# get SNP locations
snpdb <- "/z/Proj/attie/kbroman/AttieDO/DerivedData/ccfoundersnps.sqlite"
library(RSQLite)
db <- dbConnect(SQLite(), snpdb)
snp_pos <- vector("list", 19)
cat("Grabbing SNP locations:\n")
for(chr in 1:19) {
    cat(" --", chr, "\n")
    snp_pos[[chr]] <- dbGetQuery(db, paste0("select pos_Mbp from snps where chr=='", chr, "'"))[,1]*1e6
}
dbDisconnect(db)

samples <- names(files_split)

for(sample in samples[seq(SUB, length(samples), by=32)]) {

    for(chr in 1:19) {

        result <- vector("list", length(files_split[[sample]]))

        for(i in seq_along(files_split[[sample]])) {
            file <- files_split[[sample]][i]
            cat(file, " ", chr, "\n")

            bf <- BamFile(file.path(dir, file),
                          index=file.path(dir, paste0(file, ".bai")))

            chr_length <- as.data.frame(seqinfo(bf))[chr, "seqlengths"]
            param <- ScanBamParam(which=setNames( RangesList(IRanges(0L, chr_length)), chr) )

            result[[i]] <- pileup(bf, scanBamParam=param)
            result[[i]] <- result[[i]][result[[i]]$pos %in% snp_pos[[chr]],,drop=FALSE]
        }

        # drop cases with no reads
        result <- result[!sapply(result, is.null)]
        if(length(result)==0) result <- NULL
        else if(length(result)==1) result <- result[[1]]
        else result <- do.call("rbind", result)

        saveRDS(result, file=paste0(sample, "_", chr, "_pileup.rds"), compress=FALSE)
    }
}

broman::note("done with get_pileupsSUB.R")
