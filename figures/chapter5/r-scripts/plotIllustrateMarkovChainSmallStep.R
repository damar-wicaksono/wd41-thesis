#
# title     : plotIllustrateMarkovChainSmallStep.R
# purpose   : R script to
# author    : WD41, LRS/EPFL/PSI
# date      : Sept. 2017
#
# Custom functions ------------------------------------------------------------
# Bivariate logistics distribution by Gumbel
biv_log <- function(xx, mu1, mu2, sig1, sig2)
{
  dens <- (exp(-1 * (xx[1] - mu1) / sig1) * exp(-1 * (xx[2] - mu2) / sig2)) /
    (1 + exp(-1 * (xx[1] - mu1) / sig1) + exp(-1 * (xx[2] - mu2) / sig2))^3

  return(dens)
}

# Marginal, unnormalized logistic
univ_log <- function(x, mu, sig)
{
  return(exp(-1 * (x - mu) / sig) / (1 + exp(-1*(x-mu)/sig))^2)
}

# Bivariate normal proposal
proposal_sample <- function(n, loc, scl)
{
  samples <- matrix(0, ncol = 2, nrow = n)
  ll <- t(chol(scl))
  for (i in 1:n)
  {
    xx <- matrix(rnorm(2, 0, 1), nrow = 2)
    samples[i,] <- loc + ll %*% xx
  }
  return(samples)
}

# Markov Chain Algorithm
mcmc_sample <- function(n_iter, init_param, scl)
{
  xx <- matrix(0, nrow = n_iter, ncol = 2)
  # Initialization
  xx[1, ] <- init_param

  # Iterate
  for (i in 2:n_iter)
  {
    # Sample from proposal
    xx_cand <- proposal_sample(1, c(xx[i-1,1], xx[i-1,2]), scl)

    # Compute the acceptance probability
    acc_prob <- biv_log(xx_cand, mu1, mu2, sig1, sig2) / biv_log(xx[i-1,], mu1, mu2, sig1, sig2)

    # Accept or reject proposal
    if (runif(1) < acc_prob)
    {
      xx[i,] <- xx_cand
    } else
    {
      xx[i,] <- xx[i-1,]
    }
  }

  # Return samples
  return(xx)
}

# Global variables ------------------------------------------------------------
set.seed(23450)
otpfullnames <- c("./figures/plotIllustrateMarkovChainSmallStep_1.pdf",
                  "./figures/plotIllustrateMarkovChainSmallStep_2.pdf")

# Graphic Parameters
fig_size <- c(6.5, 6.5)                 # width, height
margin <- c(5.25, 6.25, 2.2, 1) + 0.1   # canvas margin (bot, left, top, right)
cex_axis <- 2.0     # Axis marker size
cex_lab  <- 2.25    # Axis label size
cex_main <- 3.0     # Main title size
cex_ann  <- 2.0     # Annotation text
tck_len  <- -0.35   # Tick length
leg_cex <- 2.0      # Legend size
cex_lab_shift <- 1.25   # Shift of the axis label from the axis
cex_ttl_shift <- 3.25   # Shift of the axis title from the axis

# Set up illustrative case ----------------------------------------------------
n_samples <- 50000
corr_matrix_prop <- matrix(c(1, 0, 0, 1), nrow = 2)
scl <- 0.01 # Very small step
mcmc <- mcmc_sample(n_samples, c(-1.0, -10.0), scl * corr_matrix_prop)

x <- seq(-25, 25, length.out = delta + 1)
y <- seq(-25, 25, length.out = delta + 1)

mu1 <- 5
sig1 <- 1.25
mu2 <- 2
sig2 <- 3

# Make the plot 1, Trace plot of x1 -------------------------------------------
pdf(otpfullnames[1], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

plot(0, 0, type = "n",
     xlim = c(0, 50000), ylim = c(-25, 25),
     axes = FALSE,
     ylab = "", xlab = "",
     xaxt = "n", yaxt = "n")

# Put the markov chain
lines(mcmc[,2])

# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, lwd = 1.5,
     at = seq(0, 50000, by = 10000),
     labels = c("0", "1", "2", "3", "4", "5"),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len, cex.axis = cex_axis)
title(xlab = expression(paste("Number of iterations (in ", 10^4, ")")),
      mgp = c(cex_ttl_shift + 0.5, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(-25, 0, 25),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len,
     cex.axis = cex_axis)
title(ylab = expression(x[2]), mgp = c(cex_ttl_shift, 0, 0), cex.lab = cex_lab)

# Save the plot
dev.off()
embed_fonts(otpfullnames[1], outfile = otpfullnames[1])

# Make the plot 2, Markov Chain of x1 -----------------------------------------
pdf(otpfullnames[2], family = "CM Roman",
    width = fig_size[2], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

plot(0, 0, type = "n",
     xlim = c(-25, 25), ylim = c(0, 10000),
     axes = FALSE,
     ylab = "", xlab = "",
     xaxt = "n", yaxt = "n")

# Put the histogram of the marginal
rest <- hist(mcmc[,2], freq = T, add = T, breaks = 30)

# Plot the analytical marginal
x <- seq(-25, 25, 0.1)
y <- univ_log(x, mu2, sig2)
lines(x, y / max(y) * max(rest$counts), lwd = 1.5)

# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, lwd = 1.5,
     at = c(-25, 0, 25),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len, cex.axis = cex_axis)
title(xlab = expression(x[2]),
      mgp = c(cex_ttl_shift, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(0, 10000),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len,
     cex.axis = cex_axis)
title(ylab = "Frequency [-]", mgp = c(cex_ttl_shift, 0, 0), cex.lab = cex_lab)

# Save the plot
dev.off()
embed_fonts(otpfullnames[2], outfile = otpfullnames[2])
