#
# title     : plotInverseTransformSampling.R
# purpose   : R script to create an illustration of sampling an univariate
#           : distribution using the inverse transform sampling method.
#           : The figures appear in the Appendix associated with chapter 5,
#           : though it is also referred in Chapter 3.
#           : The density is a Gumbel distribution.
# author    : WD41, LRS/EPFL/PSI
# date      : Sept. 2017
#
# Custom function -------------------------------------------------------------
# Gumbel Distribution
gumbel_density <- function(x, loc, scl)
{
  z <- (x - loc) / scl
  return(1/scl * exp(-1 * (z + exp(-1 * z))))
}

gumbel_quantile <- function(x, loc, scl)
{
  return(loc - scl * log(log(1/x)))
}

gumbel_cdf <- function(x, loc, scl)
{
  return(exp(-1 * exp(-1 * (x-loc)/scl)))
}

# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotInverseTransformSampling_1.pdf",
                  "./figures/plotInverseTransformSampling_2.pdf")

# Graphic Parameters
fig_size <- c(6, 6)                 # width, height
margin <- c(5.25, 6.25, 2.2, 1) + 0.1   # canvas margin (bot, left, top, right)
cex_axis <- 2.5     # Axis marker size
cex_lab  <- 2.5     # Axis label size
cex_main <- 3.0     # Main title size
cex_ann  <- 2.0     # Annotation text
tck_len  <- -0.35   # Tick length
leg_cex <- 2.0      # Legend size
cex_lab_shift <- 1.25   # Shift of the axis label from the axis
cex_ttl_shift <- 3.25   # Shift of the axis title from the axis


# Setup the case --------------------------------------------------------------
set.seed(39432)
n_samples <- 1000
x <- runif(n_samples)
loc <- 0
scl <- 10
y_select <- sample(x, 20, replace = F)
x_select <- gumbel_quantile(y_select, loc = loc, scl = scl)

# Make Plot 1, Quantile Sampling ------------
pdf(otpfullnames[1], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

plot(0, 0, type = "n",
     xlim = c(-20, 50), ylim = c(0, 1),
     axes = FALSE,
     ylab = "", xlab = "",
     xaxt = "n", yaxt = "n")

lines(seq(-20, 50, by = 0.1), gumbel_cdf(seq(-20, 50, by = 0.1), 0, 10),
      ylim = c(0, 1.))

# Put the lines between axis
for (x_loc in x_select)
{
  lines(c(x_loc, x_loc), c(0, gumbel_cdf(x_loc, loc, scl)),
        lwd = 0.5,
        col = rgb(0, 0, 0, 0.5))
  lines(c(-20, x_loc),
        c(gumbel_cdf(x_loc, loc, scl), gumbel_cdf(x_loc, loc, scl)),
        lwd = 0.5, col = rgb(0, 0, 0, 0.5))
}

# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, lwd = 1.5,
     at = c(-20, 0, 50),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len, cex.axis = cex_axis)
axis(side = 1, lwd = 0.5,
     col = rgb(0, 0, 0, 0.5),
     at = x_select,
     tcl = tck_len,
     labels = FALSE)
title(xlab = expression(F^-1 == x),
      mgp = c(cex_ttl_shift, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(0, 0.5, 1.0),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len,
     cex.axis = cex_axis)
axis(side = 2, lwd = 0.5,
     col = rgb(0, 0, 0, 0.5),
     at = y_select,
     tcl = tck_len,
     cex.axis = cex_axis,
     labels = FALSE)
title(ylab = expression(u),
      mgp = c(cex_ttl_shift + 0.75, 0, 0),
      cex.lab = cex_lab)

# Save the plot
dev.off()
embed_fonts(otpfullnames[1], outfile = otpfullnames[1])

# Make Plot 2 -------------
pdf(otpfullnames[2], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

plot(0, 0, type = "n",
     xlim = c(-20, 50), ylim = c(0, 200),
     axes = FALSE,
     ylab = "", xlab = "",
     xaxt = "n", yaxt = "n")

# Put the histogram
rest <- hist(gumbel_quantile(x, loc, scl), freq = T, add = T, breaks = 20)

# Plot the analytical marginal
lines(seq(-20, 50, by = 0.01),
      gumbel_density(seq(-20, 50, by = 0.01), loc, scl) / max(gumbel_density(seq(-20, 50, by = 0.01), loc, scl)) * max(rest$counts), lwd = 1.0)

# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, lwd = 1.5,
     at = c(-20, 0, 50),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len, cex.axis = cex_axis)
title(xlab = expression(x),
      mgp = c(cex_ttl_shift, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(0, 200),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len,
     cex.axis = cex_axis)
title(ylab = "Frequency [-]",
      mgp = c(cex_ttl_shift - 0.35, 0, 0),
      cex.lab = cex_lab)

# Save the plot
dev.off()
embed_fonts(otpfullnames[2], outfile = otpfullnames[2])