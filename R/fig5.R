# figure 5: expand lower-left of figure 3, on LRT statistic vs mixture proportion

library(lineup2)
library(broman)
options(scipen=10)

mix <- readRDS("mixture_results.rds")

mixsum <- do.call("rbind",
                  lapply(mix, function(a) {
                      mx <- which.max(a[,"lrt_p0"])
                      data.frame(id=rownames(a)[mx],
                                 p =a[mx,"p"],
                                 e =a[mx,"e"],
                                 lrt_p0 = a[mx, "lrt_p0"],
                                 stringsAsFactors=FALSE)
                      }))


z <- t(sapply(mix, function(a) {
    w <- which(!is.na(a[,"lrt_p0"]) & a[,"lrt_p0"] == max(a[,"lrt_p0"], na.rm=TRUE))
    a[w, c("p", "lrt_p0")] }))
z[,2] <- z[,2]/1e6


pdf("../Figs/fig5.pdf", width=6.5, height=4, pointsize=10)
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
                           336, 327, 41, 358, 111, 191, 324))
color[mixture] <- the_colors[4]
lowreads <- paste0("DO-", c(174, 385))
color[lowreads] <- the_colors[2]
all_mix <- paste0("DO-", c(24,101,84,61,72,        415,82,100,220,87,
                           163,146,111,218,324,    142,165,191,205,358,
                           343,354,359,362,344,    329,346,41,385,336,
                           327,340))
subtle <- all_mix[!(all_mix %in% mixture)]
color[all_mix] <- the_colors[4]

par(mar=c(2.6,3.0,1.1,0.9))
sub <- mixsum[mixsum$lrt_p0 < 2.3e5,]
color <- color[mixsum$lrt_p0 < 2.3e5]
grayplot(sub$p, sub$lrt_p0/1e5,
         xlab="Proportion contaminant", ylab=expression(paste("LRT statistic (/", 10^5, ")")),
         yaxs="i", xaxs="i", xlim=c(0, 1), ylim=c(0, max(sub$lrt_p0)/1e5*1.05),
         xat=seq(0, 1, by=0.1), mgp.x=c(1.4,0.3,0), mgp.y=c(1.6,0.3,0), bg=color)


for(i in (1:nrow(sub))[(sub$lrt_p0 > 1.2e4) |
                       (sub$lrt_p0 > 5e3 & sub$p > 0.05)]) {
    if(rownames(sub)[i] %in% paste0("DO-", c(61, 82, 87, 163))) { # move label for these
        labshiftx <- c("DO-61"=0.05, "DO-82"=0.05, "DO-87"=0.05, "DO-163"=0.05)
        labshifty <- c("DO-61"=0.27, "DO-82"=0.27, "DO-87"=0.27, "DO-163"=0.27)
        segshiftx <- c("DO-61"=0.048, "DO-82"=0.048, "DO-87"=0.048, "DO-163"=0.048)
        segshifty <- c("DO-61"=0.25, "DO-82"=0.25, "DO-87"=0.25, "DO-163"=0.25)

        ind <- rownames(sub)[i]
        segments(sub$p[i], sub$lrt_p0[i]/1e5, sub$p[i]+segshiftx[ind], sub$lrt_p0[i]/1e5 + segshifty[ind])
        text(sub$p[i]+labshiftx[ind], sub$lrt_p0[i]/1e5 + labshifty[ind], ind, adj=c(0, 0.5))
        points(sub$p[i], sub$lrt_p0[i]/1e5, pch=21, bg=color[ind])
    } else {
        text(sub$p[i]+0.008, sub$lrt_p0[i]/1e5, rownames(sub)[i], adj=c(0, 0.5))
    }
}
for(i in (1:nrow(sub))[sub$lrt_p0 < 5e3 & sub$p > 0.3]) {
    text(sub$p[i]+0.008, sub$lrt_p0[i]/1e5+0.04, rownames(sub)[i], adj=c(0, 0.5))
}
for(i in which(rownames(sub) == "DO-142")) {
    text(sub$p[i]+0.008, sub$lrt_p0[i]/1e5+0.01, rownames(sub)[i], adj=c(0, 0.5))
}

legend("topright", pch=21, pt.bg=the_colors[-5],
       c("okay", "low reads", "bad DNA", "mixture", "sample mix-up")[-5], bg="gray92")


dev.off()
