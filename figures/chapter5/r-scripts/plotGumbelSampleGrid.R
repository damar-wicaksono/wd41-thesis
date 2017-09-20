#
# title     : plotGumbelSampleGrid.R
# purpose   : R script to create an illustration of sampling a distribution
#           : using the discretized grid approach.
#           : The density is a bivariate logistic distribution.
# author    : WD41, LRS/EPFL/PSI
# date      : Sept. 2017
#
# Bivariate logistics distribution by Gumbel

biv_log <- function(xx, mu1, mu2, sig1, sig2)
{
  dens <- (exp(-1 * (xx[1] - mu1) / sig1) * exp(-1 * (xx[2] - mu2) / sig2)) /
    (1 + exp(-1 * (xx[1] - mu1) / sig1) + exp(-1 * (xx[2] - mu2) / sig2))^3
  return(dens)
}

x <- seq(-5, 15, .1)
y <- seq(-5, 15, .1)

dens <- apply(expand.grid(x, y), 1, biv_log, mu1 = 5, mu2 = 3, sig1 = 2, sig2 = 2.1)

# Generate sample by uniform grid ---------------------------------------------
x <- seq(-5, 15, 1.0)
y <- seq(-5, 15, 1.0)

dens <- apply(expand.grid(x, y), 1, biv_log, mu1 = 5, mu2 = 3, sig1 = 2, sig2 = 2.1)

xy_samples <- sample(seq(1, length(dens)), size = 10000, prob = dens/sum(dens), replace = T)
xy_grid <- expand.grid(x, y)

# Making the contour plot -----------------------------------------------------
contour(x, y, matrix(dens, nrow=length(x)), axes = F,
        ylim = c(-5, 15),
        col="black",
        lwd=2.5,
        drawlabels=F,
        nlevels=6)

axis(side = 1, at = c(-5, 0, 5, 10, 15), mgp = c(3, .75, 0), tcl = -0.35, cex.axis = 1.5) # x-axis
axis(side = 2, at = c(-5, 0, 5, 10, 15), mgp = c(3, .75, 0), tcl = -0.35, cex.axis = 1.5) # x-axis

for (i in 1:length(x))
{
  lines(c(x[i], x[i]), c(y[1], y[length(y)]), lwd = 0.001)
  lines(c(x[1], x[length(x)]), c(y[i], y[i]), lwd = 0.001)
}

lines(c(x[2], x[2]), c(y[1], y[length(y)]), lwd = 0.01)


plot(xy_grid[xy_samples,], pch = 4, col = rgb(0, 0, 0, 0.5))

hist(xy_grid[xy_samples,1])
hist(xy_grid[xy_samples,2])

axis(side = 1, at = c(0.75),  mgp = c(3, .75, 0), tcl = -0.35, cex.axis = 1.0) # x-axis
axis(side = 2, at = c(-2, -1, 0, 1, 2),  mgp = c(3, .75, 0), tcl = -0.35, cex.axis = 1.5) # y-axis
axis(side = 2, at = c(0.35),  mgp = c(3, .75, 0), tcl = -0.35, cex.axis = 1.0) # y-axis
title(xlab = expression(z[1]), mgp = c(2.5,0,0), cex.lab = 2.0)
title(ylab = expression(z[2]), line = 2.0, cex.lab = 2.0)
