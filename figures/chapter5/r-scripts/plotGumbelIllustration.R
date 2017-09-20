#
# title     : plotGumbelIllustration.R
# purpose   : R script to create an illustration of an unnormalized bivariate
#           : probability density function. The densities plot for both joint
#           : and marginal. The density is a bivariate logistic distribution.
# author    : WD41, LRS/EPFL/PSI
# date      : Sept. 2017
#
# Custom Function -------------------------------------------------------------

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
otpfullnames <- c("./figures/plotGumbelIllustration_1.pdf",
                  "./figures/plotGumbelIllustration_2.pdf")

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

# Define the particular case --------------------------------------------------
x <- seq(-25, 25, 0.1)
y <- seq(-25, 25, 0.1)

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


# Make the plots --------------------------------------------------------------
pdf(otpfullnames[1], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

# Contour plot of the joint density
contour(x, y, matrix(joint_dens, nrow=length(x)), axes = F,
        xlim = c(-5, 15),
        ylim = c(-25, 25),
        col="black",
        lwd=1.5,
        drawlabels=F,
        nlevels = 6)

# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, at = c(-5, 0, 5, 10, 15), mgp = c(3, cex_lab_shift, 0),
     tcl = -0.35, cex.axis = cex_axis)
title(xlab = expression(x[1]), mgp = c(cex_ttl_shift, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, at = c(-25, 0, 25), mgp = c(3, cex_lab_shift, 0), tcl = -0.35,
     cex.axis = cex_axis)
title(ylab = expression(x[2]), mgp = c(cex_ttl_shift, 0, 0), cex.lab = cex_lab)

# Save the plot
dev.off()
embed_fonts(otpfullnames[1], outfile = otpfullnames[1])

# Plot of the marginals
pdf(otpfullnames[2], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

plot(0, 0, type = "n",
     xlim = c(-25, 25), ylim = c(0, 0.25),
     axes = FALSE,
     ylab = "", xlab = "",
     xaxt = "n", yaxt = "n")
# Plot the points
lines(x, marginal_dens_1, lwd = 1)
lines(y, marginal_dens_2, lty = 2, lwd = 1)

# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, lwd = 1.5,
     at = c(-25, 0, 25),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len, cex.axis = cex_axis)
title(xlab = "x",
      mgp = c(cex_ttl_shift, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(0, 0.25),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len,
     cex.axis = cex_axis)
title(ylab = expression(paste(p^"*")), mgp = c(cex_ttl_shift, 0, 0), cex.lab = cex_lab)

legend(8.0, 0.225, legend_expressions, lty = c(1, 2),
       lwd = 2, bty = "n",
       cex = leg_cex)

# Save the plot
dev.off()
embed_fonts(otpfullnames[2], outfile = otpfullnames[2])
