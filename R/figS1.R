# fig S1: a reconstruction genome + diplotype probabilities for a single chromosome

library(qtl2)
library(qtl2fst)

file <- "fig_cache/do359_genome.RData"
if(file.exists(file)) {
    load(file)
} else {
    pr <- readRDS("~/Projects/AttieDOv2/DerivedData/Genoprobs_fst/attie_DO500_genoprobs_v5_index.rds")
    pr <- replace_path(pr, "~/Projects/AttieDOv2/DerivedData/Genoprobs_fst/attie_DO500_genoprobs_v5")
    pr <- pr["DO359", ]

    m <- maxmarg(pr, minprob=0.5, cores=0)
    do <- readRDS("~/Projects/AttieDOv2/RawData/Genotypes/Derived/attieDO_v0.rds")
    ph <- guess_phase(do, m, cores=0)
    pmap <- readRDS("~/Projects/AttieDOv2/DerivedData/grid_pmap.rds")

    pr <- fst_extract(pr[,"16"])
    save(pr, ph, pmap, file=file)
}

pdf("../Figs/figS1.pdf", width=6.5, height=7.8, pointsize=12)
par(mfrow=c(2,1), mar=c(3.1,4.1,2.1,0.6))
plot_onegeno(ph, pmap, mgp.x=c(1.8,0.3,0),
             ylab="Position (Mbp)")
u <- par("usr")
text(u[1]-diff(u[1:2])*0.115,
     u[4]+diff(u[3:4])*0.05,
     "A", font=2, xpd=TRUE)
legend(8.5, 154, names(CCcolors), pt.bg=CCcolors, pch=22, bg="gray90",
       ncol=4)

plot_genoprob(pr, pmap, chr="16", threshold=0.25,
              mgp.x=c(1.8,0.3,0), xlab="Chr 16 position (Mbp)", ylab="Diplotype")

u <- par("usr")
text(u[1]-diff(u[1:2])*0.115,
     u[4]+diff(u[3:4])*0.05,
     "B", font=2, xpd=TRUE)

dev.off()
