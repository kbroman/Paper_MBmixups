######################################################################
# mixtures

# MLEs for all sample pairs

library(mbmixture) # github.com/kbroman/mbmixture
library(parallel)

pair <- readRDS("../Data/pair_results_allchr.rds")

n_cores <- detectCores()

analyze_one <- function(i) {
    res <- matrix(nrow=nrow(pair[[i]]), ncol=5)

    for(j in 1:nrow(pair[[i]])) {
        if(names(pair)[i] == rownames(pair[[i]])[j]) next
        res[j,] <- tmp <- mle_pe(pair[[i]][j,,,])
    }

    dimnames(res) <- list(rownames(pair[[i]]), names(tmp))
    res
}

result <- mclapply(seq_along(pair), analyze_one, mc.cores=n_cores)
names(result) <- names(pair)

saveRDS(result, file="mixture_results.rds")
