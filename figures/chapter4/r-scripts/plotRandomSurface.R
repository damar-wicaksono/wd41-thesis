#
# title     : plotRandomSurface.R
# purpose   : R script to create an illustration of realizations from 
#           : multidimensional GP using two different correlation kernel 
#           : functions
# author    : WD41, LRS/EPFL/PSI
# date      : May. 2017
#
# Set Random Number -----------------------------------------------------------
set.seed(2345790)

# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotRandomSurface_1.pdf",
                  "./figures/plotRandomSurface_2.pdf")
# Graphic Parameters
fig_size <- c(6.5, 6.5)             # width, height
margin <- c(4, 5, 2.2, 1.5) + 0.1   # canvas margin (bot, left, top, right)
cex_axis <- 1.5     # Axis marker size
cex_lab  <- 3.0     # Axis label size

# Define Custom Function ------------------------------------------------------

#' Construct the Variance-Covariance Matrix using Gaussian Kernel
covGauss2D <- function(xx, yy, thetas, sigma)
{
    xy <- expand.grid(x = xx, y = yy)   # Create a cartesian product
    n_rows <- nrow(xy)
    cc <- matrix(0, n_rows, n_rows)
    for (i in 1:n_rows) 
    {
        for (j in i:n_rows) {
            cc[i,j] <- sigma * 
                corrGauss1D(xy$x[i], xy$x[j], thetas[1]) * 
                corrGauss1D(xy$y[i], xy$y[j], thetas[2])
        }
    }
    cc[lower.tri(cc)] <- t(cc)[lower.tri(cc)]
    return(cc)
}

#' Compute Gaussian correlation function between two point in 1D space
corrGauss1D <- function(x1, x2, theta)
{
    corr_gauss <- exp(sum(-0.5 * (x1 - x2)^2 / theta^2))
    
    return(corr_gauss)
}

# Define a particular case, random surface drawn from gaussian kernel ---------
D <- 30                 # Length of the grid
variance <- 9           # Common variance
thetas <- c(0.5, 2.0)   # Characteristic length scale
mu <- matrix(rep(0, D*D), nrow = D*D)               # Mean vector
xx <- matrix(seq(-3, 3, length.out = D), nrow = D)  # Arbitrary x-variates 
yy <- matrix(seq(-3, 3, length.out = D), nrow = D)  # Arbitrary y-variates
cc <- covGauss2D(xx, yy, thetas, sigma = variance)  # Variance-Covariance matrix
diag(cc) <- diag(cc) + 1e-8 # regularizing term

# Generate 1 unconditional realizations from it
n <- 1
zz <- matrix(ncol = D*D, nrow = n)
ll <- t(chol(cc))
for (i in 1:n)
{
    zz[i, ] <- mu + ll %*% c(as.matrix(rnorm(D*D), nrow = D*D))
}

# Define another case, random surface drawn from Matern 5/2 -------------------

# Use DiceKriging for this one
km_model <- km(~0, 
               design = data.frame(x = xx, y = yy), 
               response = rep(0, D), 
               covtype = "matern5_2", 
               coef.trend = 0,
               coef.cov = c(1.5, 0.5), 
               coef.var = variance, 
               nugget = 1e-4)

y_sim <- simulate(km_model, nsim = 1, newdata = expand.grid(x = xx, y = yy))

# Make the plot ---------------------------------------------------------------
# 1st Random Surface, Gaussian Correlation Function
pdf(otpfullnames[1], family = "CM Roman", 
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1,1), mar = margin, las = 1,
    oma = c(0, 0, 0, 0), bty = "n",
    cex.axis = cex_axis,
    cex.lab = cex_lab)

persp3D(x = xx[,1], y = yy[,1], z = matrix(zz[1,], D, D), 
        col = ramp.col(c("white", "black")), 
        border = "black", ticktype = "simple",  clim = c(-9,9), colkey = FALSE)

dev.off()
embed_fonts(otpfullnames[1], outfile = otpfullnames[1])

# 2nd Random Surface, Gaussian Correlation Function
pdf(otpfullnames[2], family = "CM Roman", 
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1,1), mar = margin, las = 1,
    oma = c(0, 0, 0, 0), bty = "n",
    cex.axis = cex_axis,
    cex.lab = cex_lab)

persp3D(x = xx[,1], y = yy[,1], z = matrix(y_sim[1,], D, D), 
        col = ramp.col(c("white", "black")), 
        border = "black", ticktype="simple", clim = c(-9,9), colkey = FALSE)
dev.off()
embed_fonts(otpfullnames[2], outfile = otpfullnames[2])
