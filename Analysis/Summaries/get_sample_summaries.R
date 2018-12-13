# get summaries for each MB sample against all DNA samples, one chr

snpcalls_dir <- "../SnpCalls"
readcounts_dir <- "../Readcounts"

chr <- SUB

# load the corresponding imputed SNPs for that chromosome
load(paste0(snpcalls_dir, "/imp_snp_", chr, "_modified.RData"))
snpinfo$pos_bp <- round(snpinfo$pos_Mbp * 1e6)

files <- list.files(readcounts_dir, pattern=paste0("_", chr, "_"))
samples <- sapply(strsplit(sapply(strsplit(files, "sample"), "[", 2), "_"), "[", 1)
mb_ids <- paste0("DO-", samples)

# check that all IDs with imp_snps data
stopifnot(all(mb_ids %in% rownames(imp_snps)))

sample_results <- pair_results <- vector("list", length(files))
names(sample_results) <- names(pair_results) <- mb_ids

for(indi in seq_along(files)) {
    cat("file", indi, "of", length(files), "\n") 
    file <- files[indi]
    sample <- samples[indi]
    mb_id <- mb_ids[indi]

    # read the read counts
    readcounts <- readRDS(file.path(readcounts_dir, file))

    # find the reads' SNP positions in the snpinfo table
    snpinfo_row <- match(readcounts$pos, snpinfo$pos_bp)

    # should all have been found
    stopifnot(!any(is.na(readcounts$pos)))

    # column in genotype file
    imp_snps_col <- snpinfo$gencol[snpinfo_row]

    # create object to contain the results for the single samples
    sample_results[[indi]] <- array(0, dim=c(nrow(imp_snps), 3, 2))
    dimnames(sample_results[[indi]]) <- list(rownames(imp_snps), c("AA", "AB", "BB"), c("A", "B"))

    for(i in 1:nrow(imp_snps)) {
        g <- imp_snps[i, imp_snps_col]
        for(j in 1:3) {
            sample_results[[indi]][i,j,1] <- sum(readcounts$count1[!is.na(g) & g==j])
            sample_results[[indi]][i,j,2] <- sum(readcounts$count2[!is.na(g) & g==j])
        }
    }

    # create object to contain the results for sample pairs
    pair_results[[indi]] <- array(0, dim=c(nrow(imp_snps), 3, 3, 2))
    dimnames(pair_results[[indi]]) <- list(rownames(imp_snps), c("AA", "AB", "BB"),
                                          c("AA", "AB", "BB"), c("A", "B"))

    g0 <- imp_snps[mb_id, imp_snps_col]
    for(i in 1:nrow(imp_snps)) {
        g <- imp_snps[i, imp_snps_col]
        for(j in 1:3) {
            for(k in 1:3) {
                pair_results[[indi]][i,j,k,1] <- sum(readcounts$count1[!is.na(g0) & g0==j & !is.na(g) & g==k])
                pair_results[[indi]][i,j,k,2] <- sum(readcounts$count2[!is.na(g0) & g0==j & !is.na(g) & g==k])
            }
        }
    }

} # loop over MB samples

saveRDS(sample_results, paste0("sample_results_chr", chr, ".rds"))
saveRDS(pair_results, paste0("pair_results_chr", chr, ".rds"))
