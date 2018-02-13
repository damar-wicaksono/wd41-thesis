#
# title     : plotBayesianPerspective.R
# purpose   : R script to create an illustration of realizations taken from a 
#           : Gaussian process, both for conditional and unconditional
# author    : WD41, LRS/EPFL/PSI
# date      : May 2017
#
# Load required libraries -----------------------------------------------------
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
set.seed(11245012)
otpfullnames <- c("./figures/plotBayesianPerspective_1.pdf",
                  "./figures/plotBayesianPerspective_2.pdf",
                  "./figures/plotBayesianPerspective_3.pdf")

# Graphic Parameters
fig_size <- c(6.5, 6.5)             # width, height
margin <- c(4, 5, 2.2, 1) + 0.1     # canvas margin (bot, left, top, right)
cex_axis <- 2.5     # Axis marker size
cex_lab  <- 3.0     # Axis label size
cex_main <- 3.0     # Main title size
cex_ann  <- 2.0     # Annotation text
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
index_pred <- c(6, 10)                          # Index of prediction locations
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

# Upper bound (2 * standard deviation)
yy_high_star <- rep(NA, D)
yy_high_star[index_int] <- mu_star + 3 * std_dev_star
yy_high_star[index_obs] <- yy_obs

# Lower bound (2 * standard deviation)
yy_low_star <- rep(NA, D)
yy_low_star[index_int] <- mu_star - 3 * std_dev_star
yy_low_star[index_obs] <- yy_obs

# Mean
mu <- rep(NA, D)
mu[index_int] <- mu_star
mu[index_obs] <- yy_obs

# Prediction
mu_pred <- mu_star[index_int == index_pred[1] | index_int == index_pred[2]]
std_dev_pred <- std_dev_star[index_int == index_pred[1] | index_int == index_pred[2]]

# Make the plots --------------------------------------------------------------
pdf(otpfullnames[1], family = "CM Roman", width = fig_size[1], height = fig_size[2])
par(mfrow = c(1,1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

# Plot of the unconditional realizations (left)
plot(0, 0, type = "n", 
     xlim = c(-2, 2), ylim = c(-3 * sqrt(variance), 3 * sqrt(variance)),
     ylab = "", xlab = "", xaxt="n", yaxt="n")
for (i in 1:n)
{
    lines(xx, yy[i,])
}
lines(xx, replicate(length(xx), 0), lwd = 1.5, lty = 2)
# Uncertainty region
y_high <- rep(3 * sqrt(variance), length(xx)) 
y_low <- rep(-3 * sqrt(variance), length(xx)) 
polygon(c(xx, rev(xx)), c(y_high, rev(y_low)),
        col = rgb(0, 0, 0,0.1), border = NA)
abline(h = -3*sqrt(variance))
abline(h = 3*sqrt(variance))

# Set Axis, Ticks and Labels
# x-axis
title(xlab = expression(x), mgp = c(1.5, 0, 0), cex.lab = cex_lab)
# y-axis
title(ylab = expression(y), mgp = c(1.5, 0, 0), cex.lab = cex_lab)

dev.off()
embed_fonts(otpfullnames[1], outfile = otpfullnames[1])

# Plot the observed data (center)
pdf(otpfullnames[2], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1,1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

plot(0, 0, type = "n", 
     xlim = c(-2, 2), ylim = c(-3 * sqrt(variance), 3 * sqrt(variance)),
     ylab = "", xlab = "",
     xaxt = "n", yaxt = "n")
# Plot the points
points(xx[index_obs], yy_obs, pch = 4, cex = 3, lwd = 1)
# Set Axis, Ticks and Labels
# x-axis
title(xlab = expression(x), mgp = c(1.5, 0, 0), cex.lab = cex_lab)
# y-axis
title(ylab = expression(y), mgp = c(1.5, 0, 0), cex.lab = cex_lab)
# Save the plot
dev.off()
embed_fonts(otpfullnames[2], outfile = otpfullnames[2])

# Plot of the conditional realizations (right)
pdf(otpfullnames[3], family = "CM Roman", width = fig_size[1], height = fig_size[2])
par(mfrow = c(1,1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

plot(0, 0, type = "n", 
     xlim = c(-2, 2), ylim = c(-3 * sqrt(variance), 3 * sqrt(variance)),
     ylab = "", xlab = "",
     xaxt = "n", yaxt = "n")
# Bounding region of 3 Standard Deviation
lines(xx, yy_high_star, lwd = 1.5)
lines(xx, yy_low_star, lwd = 1.5)
lines(xx, mu, lwd = 1.5, lty = 2)
# Observed Data
points(xx[index_obs], yy_obs, pch = 4, cex = 3, lwd = 1)
points(x = xx[index_pred], y = mu_pred,
       pch = 21, cex = 2., bg = "black", col = "black")
# Uncertainty Region
polygon(c(xx, rev(xx)), c(yy_high_star, rev(yy_low_star)),
        col = rgb(0, 0, 0,0.1), border = NA)
# Set Axis, Ticks and Labels
# x-axis
title(xlab = expression(x), mgp = c(1.5, 0, 0), cex.lab = cex_lab)
# y-axis
title(ylab = expression(y), mgp = c(1.5, 0, 0), cex.lab = cex_lab)
# Save the plot
dev.off()
embed_fonts(otpfullnames[3], outfile = otpfullnames[3])
