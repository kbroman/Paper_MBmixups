# count reads per MB sample per chromosome

readcounts_dir <- "../Readcounts"

files <- list.files(readcounts_dir, pattern=".rds$")

tmp <- strsplit(sapply(strsplit(files, "sample"), "[", 2), "_")
sample <- sapply(tmp, "[", 1)
chr <- sapply(tmp, "[", 2)

readcounts <- matrix(nrow=length(unique(sample)),
                     ncol=19)
dimnames(readcounts) <- list(unique(sample), 1:19)

for(i in seq_along(files)) {
    if(i == round(i, -2)) cat(i, "of", length(files), "\n")
    
    x <- readRDS(file.path(readcounts_dir, files[i]))
    readcounts[sample[i], chr[i]] <- sum(x$count1 + x$count2)
}

saveRDS(readcounts, "total_reads.rds")
