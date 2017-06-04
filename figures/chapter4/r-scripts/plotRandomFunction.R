#
# title     : plotRandomFunction.R
# purpose   : R script to create an illustration of the effect of using 
#           : different mean function, unconditional
# author    : WD41, LRS/EPFL/PSI
# date      : June 2017
#
# Set Random Number -----------------------------------------------------------
set.seed(234513790)

source("./r-scripts/calcMuStar.R")
source("./r-scripts/calcCovarStar.R")
source("./r-scripts/calcStdDevStar.R")

cov_gauss <- function(xx, thetas, sigma)
{
    n_rows <- nrow(xx)
    n_cols <- ncol(xx)
    ss <- matrix(0, n_rows, n_rows)
    for (i in 1:n_rows) 
    {
        for (j in i:n_rows) {
            ss[i,j] <- comp_gauss_cov(xx[i,], xx[j,], thetas, sigma)
        }
    }
    ss[lower.tri(ss)] <- t(ss)[lower.tri(ss)]
    return(ss)
}

comp_gauss_cov <- function(x1, x2, thetas, sigma)
{
    gauss_cov <- sigma * exp(sum(-0.5 * (x1 - x2)^2 / thetas^2))
    
    return(gauss_cov)
}

# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotRandomFunction_1.pdf",
                  "./figures/plotRandomFunction_2.pdf")
# Graphic Parameters
fig_size <- c(5, 5)                 # width, height
margin <- c(4, 5, 2.2, 1) + 0.1     # canvas margin (bot, left, top, right)
cex_axis <- 2.5     # Axis marker size
cex_lab  <- 3.0     # Axis label size
cex_main <- 3.0     # Main title size
tck_len  <- -0.35   # Tick length
cex_lab_shift <- 1.25   # Shift of the axis label from the axis

# Define the particular case --------------------------------------------------
D <- 21             # Number of variables
variance <- 10      # Common variance
thetas <- c(0.70)
mu <- matrix(rep(0, D), nrow = D)               # Mean vector
xx <- matrix(seq(-2, 2, length.out=D), nrow=D)  # Arbitrary input variates 
rr <- cov_gauss(xx, thetas, sigma = variance)   # Variance-Covariance matrix

# Generate 5 unconditional realizations
n <- 5
yy <- matrix(ncol=D, nrow=n)
ll <- t(chol(rr))
for (i in 1:n)
{
    yy[i, ] <- mu + ll %*% c(as.matrix(rnorm(D), nrow=D))
}

# Conditional Gaussian process
index_obs <- c(1, 5, 7, 13, 17, 20)             # Index of observed variables
xx_obs <- xx[index_obs]                         # Observed variables
yy_obs <- c(-0.75, 1.5, 2.75, 3.75, -1.3, -3.8) # Observed values
index_all <- seq(1, nrow(rr))                   # Index of all variables
index_int <- setdiff(index_all, index_obs)      # Index of non-observed vars.

mu_star <- calcMuStar(yy_obs, index_obs, mu, rr)    # Conditional mean
rr_star <- calcCovarStar(index_obs, rr)             # Conditional Covariance
std_dev_star <- calcStdDevStar(index_obs, rr)       # Conditional Std. Dev.

# Generate 5 conditional realizations
n <- 5
ll_star <- t(chol(rr_star))
yy_star <- matrix(ncol=D, nrow=n)
for (i in 1:n)
{
    yy_star[i, index_int] <- mu_star + ll_star %*% c(as.matrix(rnorm(D-length(index_obs)), nrow=D-length(index_obs)))
    yy_star[i, index_obs] <- yy_obs
}

# Mean
mu <- rep(NA, D)
mu[index_int] <- mu_star
mu[index_obs] <- yy_obs

# Upper bound (2 * standard deviation)
yy_high_star <- rep(NA, D)
yy_high_star[index_int] <- mu_star + 3 * std_dev_star
yy_high_star[index_obs] <- yy_obs

# Lower bound (2 * standard deviation)
yy_low_star <- rep(NA, D)
yy_low_star[index_int] <- mu_star - 3 * std_dev_star
yy_low_star[index_obs] <- yy_obs

# Make the plots --------------------------------------------------------------

# Plot of the unconditional realizations (left) ###############################
pdf(otpfullnames[1], family = "CM Roman", 
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1,1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

plot(0, 0, type = "n", 
     xlim = c(-2, 2), 
     ylim = c(-3*sqrt(variance), 3*sqrt(variance)),
     xlab = "", xaxt = "n",
     ylab = "", yaxt = "n")
for (i in 1:n) lines(xx, yy[i,])

y_high <- rep(3*sqrt(variance), length(xx)) 
y_low <- rep(-3*sqrt(variance), length(xx)) 
polygon(c(xx, rev(xx)), c(y_high, rev(y_low)),
        col = rgb(0, 0, 0,0.1), border = NA)
abline(h = -3*sqrt(variance))
abline(h = 3*sqrt(variance))
# Set Axis, Ticks and Labels
# x-axis
title(xlab = expression(x), mgp = c(1.5, 0, 0), cex.lab = cex_lab)
# y-axis
title(ylab = expression(y), mgp = c(1.5, 0, 0), cex.lab = cex_lab)

# Save the plot
dev.off()
embed_fonts(otpfullnames[1], outfile = otpfullnames[1])

# Plot of the conditional realizations (right) ################################
pdf(otpfullnames[2], family = "CM Roman", 
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1,1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")
plot(0, 0, type = "n", 
     xlim = c(-2, 2), 
     ylim = c(-3*sqrt(variance), 3*sqrt(variance)),
     xlab = "", xaxt = "n",
     ylab = "", yaxt = "n")
points(xx[index_obs], yy_obs, pch = 4, cex = 2, lwd = 2)  # Observed Data
for (i in 1:n) lines(xx, yy_star[i,], lwd = 0.5)          # Cond. Realizations
lines(xx, mu, lwd = 1.5, lty = 2)                         # Conditional Mean

# Uncertainty Region (+- 3 standard deviation)
polygon(c(xx, rev(xx)), c(yy_high_star, rev(yy_low_star)),
        col = rgb(0, 0, 0,0.1), border = NA)
lines(xx, yy_low_star, lwd = 1.0)           # Conditional Mean
lines(xx, yy_high_star, lwd = 1.0)          # Conditional Mean

# Set Axis, Ticks and Labels
# x-axis
title(xlab = expression(x), mgp = c(1.5, 0, 0), cex.lab = cex_lab)
# y-axis
title(ylab = expression(y), mgp = c(1.5, 0, 0), cex.lab = cex_lab)

# Save the plot
dev.off()
embed_fonts(otpfullnames[2], outfile = otpfullnames[2])