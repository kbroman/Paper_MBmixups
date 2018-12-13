library(lineup2)

######################################################################
# single samples

samp <- readRDS("sample_results_allchr.rds")

# calculate proportion of mismatches at homozygous loci
f <- function(a) {
    x <- apply(a, 1, function(b) (b[1,2] + b[3,1]) / sum(b[1,] + b[3,]))
    x[rownames(samp[[1]])] }

samp_p <- t(sapply(samp, f))
saveRDS(samp_p, file="single_results.rds")

# plot of best vs self-self distances
grayplot(get_self(samp_p), get_best(samp_p),
         xlab="Self-self distance", ylab="Best distance",
         xlim=c(0, 0.213), ylim=c(0, 0.213), xaxs="i", yaxs="i")

x <- samp_p["DO-343",]
grayplot(x, ylim=c(0, 0.33), yaxs="i", xaxs="i",
         ylab="Distance from DO-343")
adj <- c(1, 0)
xpad <- -5*(2*adj-1)
o <- order(x)
for(i in 1:2) {
    text(o[i]+xpad[i], x[o[i]], names(x)[o[i]], adj=c(adj[i], 0.5))
}

x <- samp_p["DO-342",]
grayplot(x, ylim=c(0, 0.33), yaxs="i", xaxs="i",
         ylab="Distance from DO-342")
adj <- c(1, 0)
xpad <- -5*(2*adj-1)
o <- order(x)
for(i in 1:2) {
    text(o[i]+xpad[i], x[o[i]], names(x)[o[i]], adj=c(adj[i], 0.5))
}

x <- samp_p["DO-327",]
grayplot(x, ylim=c(0, 0.33), yaxs="i", xaxs="i",
         ylab="Distance from DO-327")
adj <- c(0, 0)
xpad <- -5*(2*adj-1)
o <- order(x)
for(i in seq_along(adj)) {
    text(o[i]+xpad[i], x[o[i]], names(x)[o[i]], adj=c(adj[i], 0.5))
}

######################################################################
# mixtures

# MLEs for all sample pairs

library(mbmixture) # github.com/kbroman/mbmixture

pair <- readRDS("pair_results_allchr.rds")

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



grayplot(result[[1]][,1], result[[1]][,4],
         xlab=expression(hat(p)), ylab="LRT for p=0")

mix <- paste0("DO-", c(327, 329, 336, 340, 343, 344, 346, 354, 358, 359, 360, 362, 370, 41, 53, 54, 83, 85, 88))

# 327: mixture with 326 ( 7.4%)
# 329: mixture with 328 (27%)
# 336: mixture with 349 ( 9.3%)
# 340: mixture with 339 ( 4.5%) ... but 340 genotypes are in bad shape
# 343: mixture with 342 (51%)
# 344: mixture with 343 (31%)
# 346: mixture with 331 (26%)
# 354: mixture with 353 (45%)
# 358: mixture with 344 (58%)
# 359: mixture with 345 (33%)
# 362: mixture with 361 (34%)
#  41: mixture with 32  (20%)


# 91,71 just look odd (note, they have the *highest* total read count)
# 324 is maybe a mixture with 336?

maxlrt <- t(sapply(result, function(a) { a[which.max(a[,4]), c(1,4)] }))
maxlrt[order(maxlrt[,2]),]
# look for lrt > 50000

# mix-ups: 360,370,  83,85,88, 53,54
# mix-ups: 327
#          329
#          354
#          344
#          346
#           41
#          336
#          343
#          340
#          358
#          362
#          359
#          357 (bad dna)
#          324
#          397 (bad dna)
#          111
#          191
# 165 (w/ 139)

# 82 (w/22)
# 61 (w/60)
