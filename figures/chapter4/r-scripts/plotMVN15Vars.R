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

# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotMVN1Vars_1.pdf",
                  "./figures/plotMVN2Vars_2.pdf",
                  "./figures/plotMVN3Vars_3.pdf")
# Graphic Parameters
fig_size <- c(5, 5)                 # width, height
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
theta <- 0.75       # Correlation length
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

# Plot 1: Unconditional Marginal ----------------------------------------------
pdf(otpfullnames[1], family = "CM Roman", 
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1,1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")
plot(0, 0, xlim = c(1, 3), ylim = c(-3,3), 
     xlab = "", xaxt = "n",
     ylab = "", yaxt = "n")
points(xx, mu)

# Plot 2: Observed Variable ---------------------------------------------------

# Plot 3: Conditional Marginal ------------------------------------------------