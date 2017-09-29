#
# title     : plotAIESSamples.R
# purpose   : R script to create an illustration of sampling the bivariate
#           : logistics density using affine-invariant ensemble sampler.
#           : The final samples are plotted.
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
otpfullnames <- c("./figures/plotAIESWalkerSamples_1.pdf",
                  "./figures/plotAIESWalkerSamples_2.pdf",
                  "./figures/plotAIESWalkerSamples_3.pdf")

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

x <- seq(-25, 25, by = 0.1)
y <- seq(-25, 25, by = 0.1)
marginal_dens_1 <- univ_log(x, mu[1], sig[1])
marginal_dens_2 <- univ_log(y, mu[2], sig[2])
joint_dens <- apply(expand.grid(x, y), 1, biv_log,
                    mu1 = mu[1], mu2 = mu[2], sig1 = sig[1], sig2 = sig[2])

# Make the plots, Joint samples -----------------------------------------------
pdf(otpfullnames[1], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

plot(0, 0, type = "n",
     xlim = ens_rng[[1]], ylim = ens_rng[[2]],
     axes = FALSE,
     ylab = "", xlab = "",
     xaxt = "n", yaxt = "n")

# Put the points
points(ens[1,,101:500], ens[2,,101:500],
       xlim = ens_rng[[1]], ylim = ens_rng[[2]],
       col = rgb(0, 0, 0, 0.05), pch = 4)

# Put Contour
contour(x, y, matrix(joint_dens, nrow=length(x)),
        axes = F,
        col = "black",
        lwd = 1.5,
        add = T,
        drawlabels = F,
        nlevels = 6)

# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, lwd = 1.5,
     at = c(0, ens_rng[[1]][1], ens_rng[[1]][2]),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len, cex.axis = cex_axis)
title(xlab = expression(x[1]),
      mgp = c(cex_ttl_shift + 0.5, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(0, ens_rng[[2]][1], ens_rng[[2]][2]),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len,
     cex.axis = cex_axis)
title(ylab = expression(x[2]),
      mgp = c(cex_ttl_shift, 0, 0),
      cex.lab = cex_lab)

# Save the plot
dev.off()
embed_fonts(otpfullnames[1], outfile = otpfullnames[1])

# Make the plots, Marginal of x1 ----------------------------------------------
pdf(otpfullnames[2], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

plot(0, 0, type = "n",
     xlim = ens_rng[[1]], ylim = c(0, 10000),
     axes = FALSE,
     ylab = "", xlab = "",
     xaxt = "n", yaxt = "n")

rest <- hist(c(ens[1,,101:500]), freq = T, add = T, breaks = 30)

# Plot the analytical marginal
lines(x,
      marginal_dens_1 / max(marginal_dens_1) * max(rest$counts), lwd = 1.0)

# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, lwd = 1.5,
     at = c(0, ens_rng[[1]]),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len, cex.axis = cex_axis)
title(xlab = expression(x[1]),
      mgp = c(cex_ttl_shift + 0.5, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(0, 10000),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len,
     cex.axis = cex_axis)
title(ylab = "Frequency [-]",
      mgp = c(cex_ttl_shift, 0, 0),
      cex.lab = cex_lab)

# Save the plot
dev.off()
embed_fonts(otpfullnames[2], outfile = otpfullnames[2])


# Make the plots, Marginal of x2 ----------------------------------------------
pdf(otpfullnames[3], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

plot(0, 0, type = "n",
     xlim = ens_rng[[2]], ylim = c(0, 10000),
     axes = FALSE,
     ylab = "", xlab = "",
     xaxt = "n", yaxt = "n")

rest <- hist(c(ens[2,,101:500]), freq = T, add = T, breaks = 30)

# Plot the analytical marginal
lines(y,
      marginal_dens_2 / max(marginal_dens_2) * max(rest$counts), lwd = 1.0)

# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, lwd = 1.5,
     at = c(0, ens_rng[[2]]),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len, cex.axis = cex_axis)
title(xlab = expression(x[2]),
      mgp = c(cex_ttl_shift + 0.5, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(0, 10000),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len,
     cex.axis = cex_axis)
title(ylab = "Frequency [-]",
      mgp = c(cex_ttl_shift, 0, 0),
      cex.lab = cex_lab)

# Save the plot
dev.off()
embed_fonts(otpfullnames[3], outfile = otpfullnames[3])
