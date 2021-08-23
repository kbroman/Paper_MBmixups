# calculate genotype probabilities

library(qtl2)

# data directory
dir <- "../../Data/"

# load data
do <- read_cross2(file.path(dir, "attieDO_v1.zip"))

gmap <- insert_pseudomarkers(do$gmap, step=0.2, stepwidth="max")
pmap <- interp_map(gmap, do$gmap, do$pmap)
saveRDS(gmap, file="attieDO_gmap.rds")
saveRDS(pmap, file="attieDO_pmap.rds")

for(chr in 1:19) {
    cat(chr, "\n")
    print(system.time(pr <- calc_genoprob(do[,chr], gmap[chr], error_prob=0.002, cores=0)))
    saveRDS(pr, file=paste0("attieDO_probs", chr, ".rds"))
}
