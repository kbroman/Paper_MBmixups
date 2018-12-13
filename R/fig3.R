# figure 3: LRT statistic vs mixture proportion

library(lineup2)
library(broman)
options(scipen=10)

mix <- readRDS("mixture_results.rds")

z <- t(sapply(mix, function(a) {
    w <- which(!is.na(a[,"lrt_p0"]) & a[,"lrt_p0"] == max(a[,"lrt_p0"], na.rm=TRUE))
    a[w, c("p", "lrt_p0")] }))
z[,2] <- z[,2]/1e6


pdf("../Figs/fig3.pdf", width=6.5, height=4, pointsize=10)
par(mar=c(2.6,2.8,1.1,1.1))

the_colors <- c("lightblue",
                "#8a7aed",  # slate blue
                "#ff909b", # pink
                brocolors("web")["green"],
                "#a10db9") # purple

# color points in categories
#   lightblue = looks good
#   violetred = bad DNA
#   purple = mix-up
#   green = mixture
color <- setNames(rep(the_colors[1], nrow(z)), rownames(z))
mixups <- paste0("DO-", c(360, 370, 53, 54, 83, 85, 88))
color[mixups] <- the_colors[5]
bad_dna <- paste0("DO-", c(397, 357))
color[bad_dna] <- the_colors[3]
mixture <- paste0("DO-", c(329, 340, 343, 344, 346, 354, 359, 362,
                           336, 327, 41, 385, 358, 111, 191, 324))
color[mixture] <- the_colors[4]
lowreads <- paste0("DO-", c(174, 385))
color[lowreads] <- the_colors[2]

grayplot(z[,1], z[,2], bg=color,
         xlab="Proportion contaminant", ylab=expression(paste("LRT statistic (/", 10^6, ")")),
         xlim=c(0, 1), xaxs="i", yaxs="i",
         yat = seq(0, max(z[,2]), by=2), ylim=c(-2500/1e6, max(z[,2])*1.05),
         mgp.x=c(1.4,0.3,0), mgp.y=c(1.3,0.3,0))

annot <- rownames(z)[z[,2] > 500000/1e6]

special <- paste0("DO-", c(362, 83, 85, 88, 191, 111, 324))
left <- annot[!(annot %in% special)]

text_cex <- 0.75

xd <- 0.008
text(z[left,1] - xd, z[left,2], left, adj=1, cex=text_cex)

# locations for special points
line_offset <- rbind("DO-83"  = c(-0.015, -1e5),
                     "DO-88"  = c(-0.015, +8e4),
                     "DO-362" = c(-0.015, +2.5e5),
                     "DO-174" = c(-0.015, +2e5),
                     "DO-85" =  c(-0.015, +3e5),
                     "DO-397" = c(-0.015, +8e4),
                     "DO-111" = c(-0.015, +20e4),
                     "DO-191" = c(-0.015, +15e4),
                     "DO-324" = c(+0.015, +40e4),
                     "DO-385" = c(-0.015, +2e5))
text_offset <- rbind("DO-83"  = c(-0.018, -2e5),
                     "DO-88"  = c(-0.018, +9e4),
                     "DO-362" = c(-0.018, +3e5),
                     "DO-85" = c(-0.018,  +3.5e5),
                     "DO-174" = c(-0.018, +2.5e5),
                     "DO-397" = c(-0.018, +9e4),
                     "DO-111" = c(-0.015, +25e4),
                     "DO-191" = c(-0.015, +20e4),
                     "DO-324" = c(+0.015, +50e4),
                     "DO-385" = c(-0.018, +2.5e5))
text_adj <- rbind("DO-83" =c(1, 0.5),
                  "DO-88" =c(1, 0.5),
                  "DO-362"=c(1, 0.5),
                  "DO-174"=c(1, 0.5),
                  "DO-85" =c(1, 0.5),
                  "DO-397"=c(1, 0.5),
                  "DO-111"=c(1, 0.5),
                  "DO-191"=c(1, 0.5),
                  "DO-324"=c(0, 0.5),
                  "DO-385"=c(1, 0.5))
line_offset[,2] <- line_offset[,2]/1e6
text_offset[,2] <- text_offset[,2]/1e6

for(i in 1:nrow(line_offset)) {
    n <- rownames(line_offset)[i]
    segments(z[n,1], z[n,2], z[n,1] + line_offset[n,1], z[n,2] + line_offset[n,2])
    points(z[n,1], z[n,2], pch=21, bg=color[n])
    text(z[n,1] + text_offset[n,1], z[n,2] + text_offset[n,2], n, adj=text_adj[n,], cex=text_cex)
}

legend("topleft", pch=21, pt.bg=the_colors,
       c("okay", "low reads", "bad DNA", "mixture", "sample mix-up"), bg="gray92")

dev.off()
