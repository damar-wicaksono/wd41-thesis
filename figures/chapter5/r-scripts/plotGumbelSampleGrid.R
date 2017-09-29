#
# title     : plotGumbelSampleGrid.R
# purpose   : R script to create an illustration of sampling a distribution
#           : using the discretized grid approach.
#           : The density is a bivariate logistic distribution.
# author    : WD41, LRS/EPFL/PSI
# date      : Sept. 2017
#
# Custom function -------------------------------------------------------------
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

# Global variables ------------------------------------------------------------
set.seed(11245012)
otpfullnames <- c("./figures/plotGumbelSampleGrid_1.pdf",
                  "./figures/plotGumbelSampleGrid_2.pdf",
                  "./figures/plotGumbelSampleGrid_3.pdf")

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

n_samples <- 5000 # Number of samples
# Define the particular case --------------------------------------------------
delta <- 50

x <- seq(-25, 25, length.out = delta + 1)
y <- seq(-25, 25, length.out = delta + 1)

mu1 <- 5
sig1 <- 1.25
mu2 <- 2
sig2 <- 3

marginal_dens_1 <- univ_log(x, mu1, sig1)
marginal_dens_2 <- univ_log(y, mu2, sig2)
joint_dens <- apply(expand.grid(x, y), 1, biv_log,
                    mu1 = mu1, mu2 = mu2, sig1 = sig1, sig2 = sig2)

# Create legend expression because greek symbol involves
legend_labels <- c()
for(i in 1:2)
{
  legend_labels[i] <- paste0("x[", i, "]")
}
legend_expressions <- parse(text=legend_labels) # use parse for expression inp.


# Generate sample by uniform grid ---------------------------------------------

xy_samples <- sample(seq(1, length(joint_dens)),
                     size = n_samples, prob = joint_dens/sum(joint_dens),
                     replace = T)
xy_grid <- expand.grid(x, y)

# Make the plot, Joint Sample -------------------------------------------------
pdf(otpfullnames[1], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

plot(0, 0, type = "n",
     xlim = c(-5, 20), ylim = c(-25, 27),
     axes = FALSE,
     ylab = "", xlab = "",
     xaxt = "n", yaxt = "n")

# Create the grid
for (i in 1:length(x))
{
  lines(c(x[i], x[i]), c(y[1], y[length(y)]),
        lwd = 0.2, col = rgb(0, 0, 0, 0.45))
  lines(c(x[1], x[length(x)]), c(y[i], y[i]),
        lwd = 0.2, col = rgb(0, 0, 0, 0.45))
}

# Put the points
points(xy_grid[xy_samples,], pch = 4, cex = 0.5, col = rgb(0, 0, 0, 0.1))

# Put the contour
contour(x, y, matrix(joint_dens, nrow=length(x)),
        axes = F, col = rgb(0, 0, 0, 0.65), lwd = 1.5,
        drawlabels = F,
        nlevels = 6,
        add = T)

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

# Save the plot
dev.off()
embed_fonts(otpfullnames[1], outfile = otpfullnames[1])

# Make the plot, Marginal Histogram 1 -----------------------------------------
pdf(otpfullnames[2], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

plot(0, 0, type = "n",
     xlim = c(-10, 20), ylim = c(0, 1000),
     axes = FALSE,
     ylab = "", xlab = "",
     xaxt = "n", yaxt = "n")

# Put the histogram
rest <- hist(xy_grid[xy_samples,1], freq = T, add = T, breaks = 30)

# Plot the analytical marginal
lines(x,
      marginal_dens_1 / max(marginal_dens_1) * max(rest$counts), lwd = 1.0)

# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, lwd = 1.5,
     at = c(-10, 0, 10, 20),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len, cex.axis = cex_axis)
title(xlab = expression(x[1]),
      mgp = c(cex_ttl_shift, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(0, 1000),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len,
     cex.axis = cex_axis)
title(ylab = "Frequency [-]",
      mgp = c(cex_ttl_shift - 0.35, 0, 0),
      cex.lab = cex_lab)

# Save the plot
dev.off()
embed_fonts(otpfullnames[2], outfile = otpfullnames[2])

# Make the plot, Marginal Histogram 2 -----------------------------------------
pdf(otpfullnames[3], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

plot(0, 0, type = "n",
     xlim = c(-25, 25), ylim = c(0, 1000),
     axes = FALSE,
     ylab = "", xlab = "",
     xaxt = "n", yaxt = "n")

# Put the histogram
rest <- hist(xy_grid[xy_samples,2], freq = T, add = T, breaks = 30)

# Plot the analytical marginal
lines(x,
      marginal_dens_2 / max(marginal_dens_2) * max(rest$counts), lwd = 1.0)

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
     at = c(0, 1000),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len,
     cex.axis = cex_axis)
title(ylab = "Frequency [-]",
      mgp = c(cex_ttl_shift - 0.35, 0, 0),
      cex.lab = cex_lab)

# Save the plot
dev.off()
embed_fonts(otpfullnames[3], outfile = otpfullnames[3])