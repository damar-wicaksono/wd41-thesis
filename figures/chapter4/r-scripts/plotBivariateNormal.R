#
# title     : plotBivariateNormal.R
# purpose   : R script to create an illustration of 3 important concepts in 
#           : the operation of probability distribution, namely joint, 
#           : marginal and conditional using bivariate normal distribution.
# author    : WD41, LRS/EPFL/PSI
# date      : May 2017
#
# Define custom functions -----------------------------------------------------

density_bivariate_normal <- function(xx, mu, covar) {
    dens_biv <- exp(-0.5 * t(xx - mu) %*% solve(covar) %*% (xx - mu)) / 
        sqrt(2 * pi * det(covar))
    return(dens_biv)
}

density_univariate_normal <- function(x, mu, sigma) {
    dens_univ <- exp(-0.5 * (x-mu)^2 / sigma) / sqrt(2 * pi * sigma)
    return(dens_univ)
}

density_conditional_normal <- function(x1, x2, j, mu, covar) {
    if(j == 1) 
    {
        i <- 2
    } else {
        i <- 1
    }
    mu_star <- mu[i,1] + (x2 - mu[j,1]) * covar[1,2] / covar[j,j]
    covar_star <- covar[j,j] - covar[1,2]^2/covar[i,i]
    return(density_univariate_normal(x, mu_star, covar_star))
}

# Define the illustrative case ------------------------------------------------

covar <- matrix(c(0.5, -0.265165, -0.265165, 0.25), nrow = 2)
mu <- matrix(c(0.0, 0.0), nrow = 2)
x <- seq(-2, 2, .1)
y <- seq(-2, 2, .1)
dens <- apply(expand.grid(x, y), 1, 
              density_bivariate_normal, mu=mu, covar=covar)

sqrt(0.5)*sqrt(0.25)*0.75
otpfullname <- c("./figures/plotBivariateNormal.pdf")
# Make the Joint contour plot -------------------------------------------------
pdf(otpfullname, family = "CM Roman", width = 6.33, height = 6.33)

par(mfrow = c(1,1), 
    mar = c(3.5,4.0,1,1) + 0.1, 
    las = 1, 
    oma = c(0,0,0,0))

contour(x, y, matrix(dens, nrow=length(x)), axes = F,
        col="black", 
        lwd=1.5, 
        drawlabels=F, 
        nlevels=5)
axis(side = 1, at = c(-2, -1, 0, 1, 2),  mgp = c(3, .75, 0), tcl = -0.35, cex.axis = 1.5) # x-axis
axis(side = 1, at = c(0.75),  mgp = c(3, .75, 0), tcl = -0.35, cex.axis = 1.0) # x-axis
axis(side = 2, at = c(-2, -1, 0, 1, 2),  mgp = c(3, .75, 0), tcl = -0.35, cex.axis = 1.5) # y-axis
axis(side = 2, at = c(0.35),  mgp = c(3, .75, 0), tcl = -0.35, cex.axis = 1.0) # y-axis
title(xlab = expression(z[1]), mgp = c(2.5,0,0), cex.lab = 2.0)
title(ylab = expression(z[2]), line = 2.0, cex.lab = 2.0) 

# Make the marginal plots -----------------------------------------------------
lines(density_univariate_normal(y, 0, 0.25) - max(x), y, 
      col = "black", 
      lwd = 1.5)
lines(x, density_univariate_normal(x, 0, 0.5) - max(y), 
      col = "black", 
      lwd = 1.5)

# Make the conditional plots --------------------------------------------------
# Condition on x
x1 <- 0.75
abline(v=x1, lty=2, lwd=1.5, col="black")
lines(density_conditional_normal(y, x1, 1, mu, covar) - max(x), y, 
      lty = 2, 
      lwd = 1.5, 
      col="black")

# Condition on y
y1 <- 0.35
abline(h=y1, lty=3, lwd=1.5, col="black")
lines(x, density_conditional_normal(x, y1, 2, mu, covar) - max(y), 
      lty = 3, 
      lwd = 1.5, 
      col="black")

# Save the plot ---------------------------------------------------------------
dev.off()
embed_fonts(otpfullname, outfile=otpfullname)
