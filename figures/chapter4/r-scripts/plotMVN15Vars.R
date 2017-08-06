#
# title     : plotMVN15Vars.R
# purpose   : R script to create an illustration of marginal distributions of 
#           : 15-variate random variable, unconditional and conditional. 
# author    : WD41, LRS/EPFL/PSI
# date      : June 2017
#
# Load required libraries -----------------------------------------------------
source("./r-scripts/calcMuStar.R")
source("./r-scripts/calcCovarStar.R")
source("./r-scripts/calcStdDevStar.R")

# Gaussian covariance function
comp_gauss_cov <- function(x1, x2, thetas, sigma)
{
    gauss_cov <- sigma * exp(sum(-0.5 * (x1 - x2)^2 / thetas^2))
    
    return(gauss_cov)
}
# Gaussian covariance matrix
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

# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotMVN15Vars_1.pdf",
                  "./figures/plotMVN15Vars_2.pdf",
                  "./figures/plotMVN15Vars_3.pdf")
# Graphic Parameters
fig_size <- c(7, 7)                 # width, height
margin <- c(4, 5, 2.2, 1) + 0.1     # canvas margin (bot, left, top, right)
cex_axis <- 2.5     # Axis marker size
cex_lab  <- 3.0     # Axis label size
cex_main <- 3.0     # Main title size
tck_len  <- -0.35   # Tick length
cex_lab_shift <- 1.25   # Shift of the axis label from the axis
cex_lab_shift <- 1.25   # Shift of the axis label from the axis

# Define the illustrative case ------------------------------------------------
n <- 15             # Number of variables
variance <- 1.0     # Common variance
theta <- 0.36       # Correlation length
mu <- matrix(rep(0, n), nrow = n)               # Mean vector
xx <- matrix(seq(1, 3, length.out=n), nrow=n)   # Arbitrary input variates
rr <- cov_gauss(xx, c(theta), variance)         # Create covariance matrix

x_obs <- c(0.5, 0.7, 0.1, 0.3, 0.5, 0.9)    # Observed values
index_obs <- c(2, 4, 7, 9, 12, 14)          # Index of observed variables
index_all <- seq(1, nrow(rr))               # Index of all variables
index_int <- setdiff(index_all, index_obs)  # Index of non-observed variables

# Create Marginal Probability Dataframe ---------------------------------------
mvn_df_prior <- data.frame(x=seq(1, n), 
                           mu=rep(0, n), 
                           std_dev=rep(variance, n))

# Create Conditional Probability Dataframe ------------------------------------
mvn_df <- data.frame(x=index_obs, 
                     mu=x_obs, 
                     std_dev=rep(0, length(x_obs)), 
                     observed=rep("yes", length(x_obs)))
mvn_df <- rbind(mvn_df, data.frame(x=index_int, 
                                   mu=calcMuStar(x_obs, index_obs, mu, rr), 
                                   std_dev=calcStdDevStar(index_obs, rr), 
                                   observed=rep("no", length(index_int))))
mu_star  <- calcMuStar(x_obs, index_obs, mu, rr)
mu_star_upp <- mu_star + 3 * calcStdDevStar(index_obs, rr)
mu_star_low <- mu_star - 3 * calcStdDevStar(index_obs, rr)

# Create tick labels
x_ticks <- c()
for (i in 1:length(xx)) x_ticks <- c(x_ticks, paste("z[", i, "]", sep = ""))
y_ticks <- c("-3 * sigma", "-2 * sigma", "-1 * sigma", 0, 
             "1 * sigma", "2 * sigma", "3 * sigma")

# Plot 1: Unconditional Marginal ----------------------------------------------
pdf(otpfullnames[1], family = "CM Roman", 
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1,1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")
plot(0, 0, xlim = c(1, 3), ylim = c(-3,3), 
     xlab = "", xaxt = "n",
     ylab = "", yaxt = "n")
points(xx, mu, cex = 2)
for (i in 1:length(xx)) lines(c(xx[i], xx[i]), c(-3*sqrt(1), 3*sqrt(1)))
# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, lwd = 1.5,
     at = xx[c(1,3,5,7,9,11,13,15)],
     labels = parse(text=x_ticks[c(1,3,5,7,9,11,13,15)]),
     mgp = c(3, cex_lab_shift, 0), 
     tcl = tck_len, cex.axis = 0.75*cex_axis)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(-3*sqrt(1), -2*sqrt(1), -1*sqrt(1), 0, 1*sqrt(1), 2*sqrt(1), 3*sqrt(1)), 
     labels = parse(text = y_ticks),
     mgp = c(3, cex_lab_shift, 0), 
     tcl = tck_len, 
     cex.axis = 0.5 * cex_axis)

dev.off()
embed_fonts(otpfullnames[1], outfile = otpfullnames[1])
# Plot 2: Observed Variable ---------------------------------------------------
pdf(otpfullnames[2], family = "CM Roman", 
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1,1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")
plot(0, 0, xlim = c(1, 3), ylim = c(-3,3), 
     xlab = "", xaxt = "n",
     ylab = "", yaxt = "n")
points(xx[index_obs], x_obs, pch = 4, cex = 2)
# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, lwd = 1.5,
     at = xx[index_obs],
     labels = parse(text=x_ticks[index_obs]),
     mgp = c(3, cex_lab_shift, 0), 
     tcl = tck_len, cex.axis = 0.75*cex_axis)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(-3*sqrt(1), -2*sqrt(1), -1*sqrt(1), 0, 1*sqrt(1), 2*sqrt(1), 3*sqrt(1)), 
     labels = parse(text = y_ticks),
     mgp = c(3, cex_lab_shift, 0), 
     tcl = tck_len, 
     cex.axis = 0.5 * cex_axis)

dev.off()
embed_fonts(otpfullnames[2], outfile = otpfullnames[2])
# Plot 3: Conditional  ------------------------------------------------
pdf(otpfullnames[3], family = "CM Roman", 
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1,1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")
plot(0, 0, xlim = c(1, 3), ylim = c(-3,3), 
     xlab = "", xaxt = "n",
     ylab = "", yaxt = "n")
points(xx[index_int], calcMuStar(x_obs, index_obs, mu, rr), cex = 2)
for (i in 1:length(index_int)) lines(c(xx[index_int][i], xx[index_int][i]),
                                     c(mu_star_low[i], mu_star_upp[i]))
points(xx[index_obs], x_obs, pch = 4, cex = 2, col = rgb(0, 0, 0, 0.25))
# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, lwd = 1.5,
     at = xx[index_int],
     labels = parse(text=x_ticks[index_int]),
     mgp = c(3, cex_lab_shift, 0), 
     tcl = tck_len, cex.axis = 0.75*cex_axis)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(-3*sqrt(1), -2*sqrt(1), -1*sqrt(1), 0, 1*sqrt(1), 2*sqrt(1), 3*sqrt(1)), 
     labels = parse(text = y_ticks),
     mgp = c(3, cex_lab_shift, 0), 
     tcl = tck_len, 
     cex.axis = 0.5 * cex_axis)

dev.off()
embed_fonts(otpfullnames[3], outfile = otpfullnames[3])