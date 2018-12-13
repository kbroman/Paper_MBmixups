# figure 2: details for selected individual samples

library(lineup2)
library(broman)

samp_p <- readRDS("single_results.rds")

# re-order the columns
samp_p <- samp_p[,order(as.numeric(sub("^DO-", "", colnames(samp_p))))]

plot_ind <-
    function(ind, dist=samp_p, color=c("lightblue", "violetred"), n_label=2,
             xlab="Genomic DNA sample", ylab="Proportion discordant", xd=7,
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
    if(is.null(yadj)) yadj <- rep(0, length(labels))
    if(is.null(labelleft)) labelleft <- rep(FALSE, length(labels))
    names(yadj) <- names(labelleft) <- labels

    for(i in labels) {
        text(which(colnames(dist)==i)+xd*ifelse(labelleft[i], -1, 1),
             dist[ind,i] + yadj[i], i, adj=c(1*labelleft[i], 0.5))
    }

}

pdf("../Figs/fig2.pdf", width=6.5, height=6.5, pointsize=12)
par(mfrow=c(3,2), mar=c(3.1,3.4,2.1,1.1))
n2show <- c(1,1,1,2,2,2)
ind <- paste0("DO-",  c(53, 54, 101, 358, 362, 329))
labelleft <- list(FALSE, FALSE, FALSE, c(FALSE, FALSE), c(FALSE, FALSE), c(FALSE, TRUE))
yadj <- list(0.01, 0.01, 0.01, c(0,0), c(0,0), c(0,0))
for(i in seq_along(ind)) {
    plot_ind(ind[i], mgp.x=c(1.4,0.3,0), mgp.y=c(2.1,0.3,0),
             n_label=n2show[i], labelleft=labelleft[[i]], yadj=yadj[[i]])

    u <- par("usr")
    text(u[1]-diff(u[1:2])*0.13,
         u[4]+diff(u[3:4])*0.09,
         LETTERS[i], xpd=TRUE, font=2, cex=1.3)
}
dev.off()
