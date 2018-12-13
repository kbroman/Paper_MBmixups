# figure 4: details for selected mixtures

library(lineup2)
library(broman)
options(scipen=10)

mix <- readRDS("mixture_results.rds")

plot_mix <-
    function(ind, dat=mix, color="lightblue",
             xlab="Proportion contaminant", ylab=NULL, yat=NULL,
             xd=0.02, xlim=c(0, 1), ylim=NULL, textright=TRUE, ...)
{
    z <- sapply(dat, function(a) max(a[,"lrt_p0"], na.rm=TRUE))/1e6
    if(is.null(ylim)) ylim <- c(0, max(z)*1.05)
    if(is.null(ylab)) ylab <- expression(paste("LRT statistic (/", 10^6, ")"))
    if(is.null(yat)) yat <- seq(0, max(ylim), by=2)

    dat <- dat[[ind]]
    dat <- dat[rownames(dat) != ind,]
    dat[,"lrt_p0"] <- dat[,"lrt_p0"]/1e6

    grayplot(dat[,"p"], dat[,"lrt_p0"], main=ind,
             xlim=xlim, ylim=ylim, xaxs="i", yaxs="i",
             yat=yat, pch=21, bg=color, xlab=xlab, ylab=ylab, ...)

    adj <- 0
    if(!textright) {
        xd <- -xd
        adj <- 1
    }

    lab <- rownames(dat)[dat[,"lrt_p0"] == max(dat[,"lrt_p0"])]
    text(dat[lab,"p"]+xd, dat[lab,"lrt_p0"], lab, adj=c(adj, 0.5))

}

pdf("../Figs/fig4.pdf", width=6.5, height=6.5, pointsize=12)
par(mfrow=c(3,2), mar=c(3.1,2.8,2.1,1.1))
ind <- paste0("DO-",  c(360, 370, 346, 358, 362, 329))
for(i in seq_along(ind)) {
    plot_mix(ind[i], mgp.x=c(1.4,0.3,0), mgp.y=c(1.3,0.3,0),
             textright=(i > 2))

    u <- par("usr")
    text(u[1]-diff(u[1:2])*0.10,
         u[4]+diff(u[3:4])*0.09,
         LETTERS[i], xpd=TRUE, font=2, cex=1.3)
}
dev.off()
