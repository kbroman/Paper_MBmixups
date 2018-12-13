# figure S2: details for many more individual samples

library(lineup2)
library(broman)

samp_p <- readRDS("single_results.rds")

# re-order the columns
samp_p <- samp_p[,order(as.numeric(sub("^DO-", "", colnames(samp_p))))]

plot_ind <-
    function(ind, dist=samp_p, color=c("lightblue", "violetred"), n_label=2,
             xlab="Genomic DNA sample", ylab="Proportion concordant", xd=7,
             ylim=c(0, 0.3), yaxs="i",
             labelleft=NULL, yadj=NULL, ...)
{
    bg <- setNames(rep(color[1], ncol(dist)), colnames(dist))
    bg[paste0("DO-", c(340, 306, 397, 357, 308))] <- "#ff909b" # pink
    bg[ind] <- color[2]

    grayplot(seq_len(ncol(dist)), dist[ind,], main=ind,
             pch=21, bg=bg, xlab=xlab, ylab=ylab, ylim=ylim,
             yaxs=yaxs, ...)

    points(which(colnames(dist)==ind), dist[ind,ind], pch=21, bg=color[2])

    labels <- names(sort(dist[ind,])[1:n_label])
    if(is.null(yadj)) {
        yadj <- rep(0, length(labels))
        names(yadj) <- labels
        if(min(dist[ind,]) < 0.01) yadj[names(which.min(dist[ind,]))] <- 0.01-min(dist[ind,])
    }
    if(is.null(labelleft)) {
        labelleft <- rep(FALSE, length(labels))
        names(labelleft) <- labels
    }

    for(i in labels) {
        text(which(colnames(dist)==i)+xd*ifelse(labelleft[i], -1, 1),
             dist[ind,i] + yadj[i], i, adj=c(1*labelleft[i], 0.5))
    }

}

pdf("../Figs/figS2.pdf", width=12, height=15, pointsize=12)
par(mfrow=c(6,4), mar=c(3.1,3.4,2.1,1.1))
ind <- paste0("DO-",  c(83, 85, 88, 385,
                        53, 54, 174, 205,
                        360, 370, 358, 343,
                        354, 359, 362, 344,
                        329, 346, 41, 340,
                        336, 327))
n2show <- rep(2,length(ind))
for(i in seq_along(ind)) {
    plot_ind(ind[i], mgp.x=c(1.4,0.3,0), mgp.y=c(2.1,0.3,0), xd=13,
             n_label=1, ylim=c(-0.003, 0.30))

    u <- par("usr")
    text(u[1]-diff(u[1:2])*0.13,
         u[4]+diff(u[3:4])*0.09,
         LETTERS[i], xpd=TRUE, font=2, cex=1.3)
}
dev.off()
