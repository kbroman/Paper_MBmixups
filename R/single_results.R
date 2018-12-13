# analysis of single samples

######################################################################
# single samples

samp <- readRDS("../Data/sample_results_allchr.rds")

# calculate proportion of mismatches at homozygous loci
f <- function(a) {
    x <- apply(a, 1, function(b) (b[1,2] + b[3,1]) / sum(b[1,] + b[3,]))
    x[rownames(samp[[1]])] }

samp_p <- t(sapply(samp, f))
saveRDS(samp_p, file="single_results.rds")
