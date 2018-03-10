#
# title     : plotAIESWalker.R
# purpose   : R script to create an illustration of sampling the bivariate
#           : logistics density using affine-invariant ensemble sampler.
#           : The iteration of each walker is being plotted.
# author    : WD41, LRS/EPFL/PSI
# date      : Sept. 2017
#
# Custom Functions ------------------------------------------------------------
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

# Making my own AIES Sampler
# This is an implementation of AIES sampler to sample the bivariate logistics
aies_sampler <- function(ensemble)
{
  # Get the dimension of the ensemble
  # Number of iterations
  n_iter <- dim(ensemble)[3]
  # Number of parameters
  n_params <- dim(ensemble)[1]
  # Number of walkers
  n_walkers <- dim(ensemble)[2]
  # Outer Iterations
  for (i in 2:n_iter)
  {
    # Inner Iteration
    current_ens <- ensemble[,,i-1]
    for (j in 1:n_walkers)
    {
      # Select complementary walker
      cpl_idx <- sample(c(1:n_walkers)[-j], 1)
      cpl_walker <- current_ens[,cpl_idx]
      # Generate step size, from an exponential distribution with a = 2
      z <- runif(1, min = sqrt(0.5), max = sqrt(2))^2
      # Create a proposal step
      xx_cand <- cpl_walker + z * (current_ens[,j] - cpl_walker)
      # Compute acceptance probability
      acc_prob <- z^(n_params - 1) * biv_log1(xx_cand) / biv_log1(current_ens[,j])
      # Accept or reject
      if (runif(1) < acc_prob)
      {
        current_ens[,j] <- xx_cand
      }
    }
    # Update iteration
    ensemble[,,i] <- current_ens
  }
  return(ensemble)
}

# Global variables ------------------------------------------------------------
set.seed(11245012)
otpfullnames <- c("./figures/plotAIESWalkerRunningStats_1.pdf",
                  "./figures/plotAIESWalkerRunningStats_2.pdf",
                  "./figures/plotAIESWalkerEnsemble_1.pdf",
                  "./figures/plotAIESWalkerEnsemble_2.pdf")

# Graphic Parameters
fig_size <- c(6, 6)                 # width, height
margin <- c(5.25, 6.25, 2.2, 1) + 0.1   # canvas margin (bot, left, top, right)
cex_axis <- 2.5     # Axis marker size
cex_lab  <- 3.0     # Axis label size
cex_main <- 3.0     # Main title size
cex_ann  <- 2.0     # Annotation text
tck_len  <- -0.35   # Tick length
leg_cex <- 2.0      # Legend size
cex_lab_shift <- 1.25   # Shift of the axis label from the axis
cex_ttl_shift <- 3.25   # Shift of the axis title from the axis

# Set up the case -------------------------------------------------------------

mu <- c(5, 2)
sig <- c(1.25, 3)
biv_log1 <- function(xx) {biv_log(xx, mu[1], mu[2], sig[1], sig[2])}

n_iter <- 500
n_walker <- 100
ensemble <- array(NA, dim = c(2, n_walker, n_iter))
ensemble[,,1] <- runif(n_walker)
ens <- aies_sampler(ensemble)
ens_rng <- list(x1 = c(-10, 20), x2 = c(-25, 25))

# Make the plots, Running Stats of x1 and x2 ----------------------------------
for (i in 1:2)
{
  ens_stat <- matrix(0, nrow = n_iter, ncol = 2)
  for(j in 1:n_iter) ens_stat[j,1] <- mean(test_ens[i,,j]) # Running mean
  for(j in 1:n_iter) ens_stat[j,2] <- sd(test_ens[i,,j])   # Running std. dev.
  sd_true = sqrt(sig[i]^2 * pi^2 / 3)

  pdf(otpfullnames[i], family = "CM Roman",
      width = fig_size[1], height = fig_size[2])
  par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

  plot(0, 0, type = "n",
       xlim = c(0, n_iter), ylim = c(0, round(1.2 * max(mu[i], sd_true))),
       axes = FALSE,
       ylab = "", xlab = "",
       xaxt = "n", yaxt = "n")

  # Put the running mean
  lines(ens_stat[,1], type = "l")
  # Add the analytical mean
  abline(h = mu[i])
  # Put the running empirical standard deviation
  lines(ens_stat[,2], type = "l", lty = 2)
  # Add the analytical standard deviation
  abline(h = sd_true, lty = 2)

  # Set Axis, Ticks and Labels
  # x-axis
  axis(side = 1, lwd = 1.5,
       at = c(0, 0.5*n_iter, n_iter),
       mgp = c(3, cex_lab_shift, 0),
       tcl = tck_len, cex.axis = cex_axis)
  title(xlab = "Number of iterations",
        mgp = c(cex_ttl_shift + 0.5, 0, 0), cex.lab = cex_lab)
  # y-axis
  axis(side = 2, lwd = 1.5,
       at = c(0, round(mu[i], 1), round(sd_true,1),
              round(1.2 * max(mu[i], sd_true))),
       mgp = c(3, cex_lab_shift, 0),
       tcl = tck_len,
       cex.axis = cex_axis)
  title(ylab = parse(text = paste0("x[", i, "]")),
        mgp = c(cex_ttl_shift, 0, 0),
        cex.lab = cex_lab)

  # Save the plot
  dev.off()
  embed_fonts(otpfullnames[i], outfile = otpfullnames[i])
}

# Make the plots, Ensemble iteration of x1 and x2 -----------------------------
for (i in 1:2)
{
  pdf(otpfullnames[i+2], family = "CM Roman",
      width = fig_size[1], height = fig_size[2])
  par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

  plot(0, 0, type = "n",
       xlim = c(0, n_iter), ylim = ens_rng[[i]],
       axes = FALSE,
       ylab = "", xlab = "",
       xaxt = "n", yaxt = "n")

  # Put the walkers iteration
  for (j in 1:n_walker) lines(ens[i,j,], col = rgb(0, 0, 0, 0.1))

  # Set Axis, Ticks and Labels
  # x-axis
  axis(side = 1, lwd = 1.5,
       at = c(0, 0.5*n_iter, n_iter),
       mgp = c(3, cex_lab_shift, 0),
       tcl = tck_len, cex.axis = cex_axis)
  title(xlab = "Number of iterations",
        mgp = c(cex_ttl_shift + 0.5, 0, 0), cex.lab = cex_lab)
  # y-axis
  axis(side = 2, lwd = 1.5,
       at = ens_rng[[i]],
       mgp = c(3, cex_lab_shift, 0),
       tcl = tck_len,
       cex.axis = cex_axis)
  title(ylab = parse(text = paste0("x[", i, "]")),
        mgp = c(cex_ttl_shift - 1.0, 0, 0),
        cex.lab = cex_lab)

  # Save the plot
  dev.off()
  embed_fonts(otpfullnames[i+2], outfile = otpfullnames[i+2])
}
