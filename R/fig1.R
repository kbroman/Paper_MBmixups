# figure 1: best vs self distance for single samples

library(lineup2)
library(broman)

samp_p <- readRDS("single_results.rds")

# plot of best vs self-self distances
pdf("../Figs/fig1.pdf", width=6.5, height=4, pointsize=10)
par(mar=c(2.6,3.6,1.1,1.1))
self <- get_self(samp_p)
best <- get_best(samp_p)

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
color <- setNames(rep(the_colors[1], length(self)), names(self))
mixups <- paste0("DO-", c(360, 370, 53, 54, 83, 85, 88))
color[mixups] <- the_colors[5]
bad_dna <- paste0("DO-", c(397, 357))
color[bad_dna] <- the_colors[3]
mixture <- paste0("DO-", c(329, 340, 343, 344, 346, 354, 359, 362,
                           336, 327, 41, 385, 358, 111, 191, 324))
color[mixture] <- the_colors[4]
lowreads <- paste0("DO-", c(174, 385))
color[lowreads] <- the_colors[2]

grayplot(self, best, bg=color,
         xlab="Proportion discordant with self", ylab="Minimum proportion discordant",
         yat=c(0, 0.05, 0.10, 0.15),
         ylim=c(0, 0.15), xlim=c(0, 0.23), xaxs="i", yaxs="i",
         mgp.x=c(1.4,0.3,0), mgp.y=c(2.1,0.3,0))

points(self[mixture], best[mixture], bg=color[mixture], pch=21)

annot <- names(self)[!is.na(self) & self > 0.05]

left <- paste0("DO-", c(205, 174, 397, 385, 336, 142, 186, 191))
special <- paste0("DO-", c(343, 359, 362, 370, 360, 88, 53, 83, 54, 327, 85))
right <- annot[!(annot %in% c(left, special))]

text_cex <- 0.75

xd <- 0.002
text(self[left] - xd, best[left], left, adj=1, cex=text_cex)
text(self[right] + xd, best[right], right, adj=0, cex=text_cex)

# locations for special points
line_offset <- rbind("DO-343" = c(-0.005, -0.005),
                     "DO-359" = c(-0.005,  0.003),
                     "DO-362" = c(-0.001,  0.008),
                     "DO-53"  = c( 0.003, -0.002),
                     "DO-54"  = c( 0.003,  0.0025),
                     "DO-83"  = c( 0.008,  0.007),
                     "DO-88"  = c( 0.014,  0.014),
                     "DO-370" = c(-0.004, -0.001),
                     "DO-85"  = c(-0.004,  0.001),
                     "DO-360" = c(-0.004,  0.007),
                     "DO-111" = c(-0.004,  0.003),
                     "DO-324" = c( 0.004, -0.003),
                     "DO-327" = c( 0.003,  0.005))
text_offset <- rbind("DO-343" = c(-0.005, -0.005),
                     "DO-359" = c(-0.006,  0.002),
                     "DO-362" = c(-0.007,  0.009),
                     "DO-53"  = c( 0.003, -0.002),
                     "DO-54"  = c( 0.003,  0.003),
                     "DO-83"  = c( 0.008,  0.008),
                     "DO-88"  = c( 0.014,  0.014),
                     "DO-370" = c(-0.005, -0.0017),
                     "DO-85"  = c(-0.005,  0.0017),
                     "DO-360" = c(-0.004,  0.0075),
                     "DO-111" = c(-0.004,  0.003),
                     "DO-324" = c( 0.004, -0.003),
                     "DO-327" = c( 0.003,  0.005))
text_adj <- rbind("DO-343"=c(1,  1),
                  "DO-359"=c(1,  0),
                  "DO-362"=c(0.5,0),
                  "DO-53" =c(0,0.5),
                  "DO-54" =c(0,0.5),
                  "DO-83" =c(0,0.5),
                  "DO-88" =c(0,0.5),
                  "DO-370"=c(1,0.5),
                  "DO-85" =c(1,0.5),
                  "DO-360"=c(1,0),
                  "DO-111"=c(1,0.5),
                  "DO-324"=c(0,0.5),
                  "DO-327"=c(0,0))

for(i in 1:nrow(line_offset)) {
    n <- rownames(line_offset)[i]
    segments(self[n], best[n], self[n] + line_offset[n,1], best[n] + line_offset[n,2])
    points(self[n], best[n], pch=21, bg=color[n])
    text(self[n] + text_offset[n,1], best[n] + text_offset[n,2], n, adj=text_adj[n,], cex=text_cex)
}

legend("topleft", pch=21, pt.bg=the_colors,
       c("okay", "low reads", "bad DNA", "mixture", "sample mix-up"), bg="gray92")

dev.off()
