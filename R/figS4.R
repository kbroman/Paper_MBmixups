# figure S4: details for subtle mixtures

library(lineup2)
library(broman)
options(scipen=10)

mix <- readRDS("mixture_results.rds")

mixture <- paste0("DO-", c(329, 340, 343, 344, 346, 354, 359, 362,
                           336, 327, 41, 358, 111, 191, 324))
all_mix <- paste0("DO-", c(24,101,84,61,72,        415,82,100,220,87,
                           163,146,111,218,324,    142,165,191,205,358,
                           343,354,359,362,344,    329,346,41,385,336,
                           327,340))
subtle <- all_mix[!(all_mix %in% mixture)]
theind <- c(subtle, "DO-179", "DO-151", "DO-159")
o <- order(sapply(mix[theind], function(a) max(a[,"lrt_p0"], na.rm=TRUE)), decreasing=TRUE)
theind <- theind[o]


plot_mix <-
    function(ind, dat=mix[theind], color="lightblue",
             xlab="Proportion contaminant", ylab=NULL, yat=NULL,
             xd=NULL, xlim=NULL, ylim=NULL, textright=TRUE, ...)
{
    z <- sapply(dat, function(a) max(a[,"lrt_p0"], na.rm=TRUE))/1e4
    if(is.null(ylim)) ylim <- c(0, max(z)*1.05)
    x <- max(dat[[ind]][,"p"], na.rm=TRUE)
    if(is.null(xlim)) xlim <- c(0, max(x)*1.05)
    if(is.null(ylab)) ylab <- expression(paste("LRT statistic (/", 10^4, ")"))
    if(is.null(yat)) yat <- seq(0, max(ylim), by=2)

    dat <- dat[[ind]]
    dat <- dat[rownames(dat) != ind,]
    dat[,"lrt_p0"] <- dat[,"lrt_p0"]/1e4

    grayplot(dat[,"p"], dat[,"lrt_p0"], main=ind,
             xlim=xlim, ylim=ylim, xaxs="i", yaxs="i",
             yat=yat, pch=21, bg=color, xlab=xlab, ylab=ylab, ...)

    if(is.null(xd)) xd <- diff(par("usr")[1:2])*0.03

    adj <- 0
    if(!textright) {
        xd <- -xd
        adj <- 1
    }

    lab <- rownames(dat)[dat[,"lrt_p0"] == max(dat[,"lrt_p0"])]
    if(!(ind %in% c("DO-179", "DO-151", "DO-159"))) { # <- skip these
        text(dat[lab,"p"]+xd, dat[lab,"lrt_p0"], lab, adj=c(adj, 0.5))
    }
}

pdf("../Figs/figS4.pdf", width=8, height=11.25, pointsize=12)
par(mfrow=c(5,4), mar=c(3.1,2.8,2.1,1.1))

for(i in seq_along(theind)) {
    if(i <= 8) {
        plot_mix(theind[i], mgp.x=c(1.4,0.3,0), mgp.y=c(1.3,0.3,0),
                 textright=FALSE)
    } else {
        plot_mix(theind[i], mgp.x=c(1.4,0.3,0), mgp.y=c(1.3,0.3,0),
                 textright=FALSE,
                 ylim=c(0, 1.05), yat=seq(0, 1, by=0.2))
    }

    u <- par("usr")
    text(u[1]-diff(u[1:2])*0.10,
         u[4]+diff(u[3:4])*0.09,
         LETTERS[i], xpd=TRUE, font=2, cex=1.3)
}
dev.off()
