#
# title     : plotIllustrateMarkovChainIteration.R
# purpose   : R script to
# author    : WD41, LRS/EPFL/PSI
# date      : Sept. 2017
#
library(mvtnorm)

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
  xx_candidates <- matrix(0, ncol = 2)
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
    xx_candidates <- rbind(xx_candidates, xx_cand)
  }

  # Return samples
  return(list(mcmc_samples = xx, candidates = xx_candidates))
}

# Global variables ------------------------------------------------------------
set.seed(23450)
otpfullnames <- c("./figures/plotIllustrateMarkovChainIteration_1.pdf",
                  "./figures/plotIllustrateMarkovChainIteration_2.pdf",
                  "./figures/plotIllustrateMarkovChainIteration_3.pdf")

# Graphic Parameters
fig_size <- c(6.5, 6.5)                 # width, height
margin <- c(5.25, 6.25, 2.2, 1) + 0.1   # canvas margin (bot, left, top, right)
cex_axis <- 2.5     # Axis marker size
cex_lab  <- 3.0     # Axis label size
cex_main <- 3.0     # Main title size
cex_ann  <- 2.0     # Annotation text
tck_len  <- -0.35   # Tick length
leg_cex <- 2.0      # Legend size
cex_lab_shift <- 1.25   # Shift of the axis label from the axis
cex_ttl_shift <- 3.25   # Shift of the axis title from the axis

# Set up illustrative case ----------------------------------------------------
n_samples <- 100
init_param <- c(0.0, 0.0)
corr_matrix_prop <- matrix(c(1, 0, 0, 1), nrow = 2)
mcmc <- mcmc_sample(n_samples, init_param, 2 * corr_matrix_prop)

mu1 <- 5
sig1 <- 1.25
mu2 <- 2
sig2 <- 3

delta <- 50

x <- seq(-25, 25, length.out = delta + 1)
y <- seq(-25, 25, length.out = delta + 1)

contour(x, y, matrix(joint_dens, nrow=length(x)),
        axes = F,
        col = "black",
        lwd = 1.5,
        add = T,
        drawlabels = F,
        nlevels = 6)

joint_dens_biv_log <- apply(expand.grid(x, y), 1, biv_log,
                      mu1 = mu1, mu2 = mu2, sig1 = sig1, sig2 = sig2)

# Make the plot 1, Symmetric proposal 1 ---------------------------------------
for (i in 1:3)
{
  pdf(otpfullnames[i], family = "CM Roman",
      width = fig_size[1], height = fig_size[2])
  par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

  plot(0, 0, type = "n",
       xlim = c(-5, 20), ylim = c(-25, 25),
       axes = FALSE,
       ylab = "", xlab = "",
       xaxt = "n", yaxt = "n")

  contour(x, y, matrix(joint_dens_biv_log, nrow = length(x)),
          axes = F,
          col = "black",
          lwd = 1.0,
          add = T,
          drawlabels = F,
          nlevels = 6)

  # Compute the density of the proposal
  joint_dens_biv_norm <- apply(expand.grid(x, y), 1, dmvnorm,
                               mean = mcmc$mcmc_samples[i,],
                               sigma = 2 * corr_matrix_prop)
  points(mcmc$mcmc_samples[i,1], mcmc$mcmc_samples[i,2], pch = 4, lwd = 2)
  points(mcmc$candidates[i+1,1], mcmc$candidates[i+1,2], pch = 16)

  contour(x, y, matrix(joint_dens_biv_norm, nrow = length(x)),
          axes = F,
          col = rgb(0., 0., 0., 0.75),
          lwd = 1.0,
          lty = 2,
          add = T,
          drawlabels = F,
          nlevels = 6)

  # Set Axis, Ticks and Labels
  # x-axis
  axis(side = 1, lwd = 1.5,
       at = c(-5, 0, 5, 10, 15, 20),
       mgp = c(3, cex_lab_shift, 0),
       tcl = tck_len, cex.axis = cex_axis)
  title(xlab = expression(x[1]),
        mgp = c(cex_ttl_shift, 0, 0), cex.lab = cex_lab)
  # y-axis
  axis(side = 2, lwd = 1.5,
       at = c(-25, 0, 25),
       mgp = c(3, cex_lab_shift, 0),
       tcl = tck_len,
       cex.axis = cex_axis)
  title(ylab = expression(x[2]), mgp = c(cex_ttl_shift, 0, 0), cex.lab = cex_lab)

  legend(5, -15, c("current value", "candidate"), pch = c(4, 16),
         bty = "n",
         cex = leg_cex)

  # Save the plot
  dev.off()
  embed_fonts(otpfullnames[i], outfile = otpfullnames[i])

}
