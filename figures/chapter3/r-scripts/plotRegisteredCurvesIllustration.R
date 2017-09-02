#
# title     : plotRegisteredCurvesIllustration.R
# purpose   : Create an illustration plot of phase variation in a functional
#           : data set
# author    : WD41, LRS/EPFL/PSI
# date      : September 2017
#
# Load library ----------------------------------------------------------------
library(fda)

# Global variable -------------------------------------------------------------
otpfullnames <- c("./figures/plotRegisteredCurvesIllustration_1.pdf",
                  "./figures/plotRegisteredCurvesIllustration_2.pdf")

set.seed(30984)

# Graphic Parameters
fig_size <- c(5, 5)                     # width, height
margin   <- c(4, 6.5, 2.2, 1) + 0.1     # canvas margin (bot, left, top, right)
cex_lab  <- 2.0     # Axis label size
cex_main <- 3.0     # Main title size
tck_len  <- -0.35   # Tick length
cex_lab_shift <- 1.25   # Shift of the axis label from the axis

# Setup case ------------------------------------------------------------------
# Number of curves
n <- 20
# number of observation points
m <- 100
# Argument values
t <- seq(0, 1, length = m+2)[2:(m+1)]

# Create an illustrative function
theta <- function(t) {
    dnorm(t, mean = 0.3, sd = 0.2) + dnorm(t, mean = 0.7, sd = 0.15)
}

# Introduce random magnitude and phase variations & create functional data set
w <- runif(n, min = -0.20, max = 0.20)
y <- lapply(w, function(w) {theta(t + w) + w})
t <- lapply(1:n, function(x) t) # Argument for each function
y <- matrix(unlist(y), ncol = n, byrow=F)

# Compute the landmark, the time of the maximum
t <- t[[1]]
landmark_ref <- t[which.max(theta(t))]  # Reference landmark
# Realization landmark
landmark <- c()
for(i in 1:n) landmark <- c(landmark, t[which.max(y[,i])])

# Setup fd object and carry out landmark registration -------------------------
# fd object
nbasis_test <- 4 + length(t) - 4
breaks <- seq(t[1],t[length(t)],length.out = 30)
rng_test <- range(t)
wbasis.growth <- create.bspline.basis(rangeval = rng_test,
                                      nbasis = 32, norder = 4,
                                      breaks = breaks)
test_fdpar <- fdPar(wbasis.growth)
y1_smooth <- smooth.basis(t, y[,], test_fdpar)

# Registration curve
wbasis <- create.bspline.basis(rangeval = range(t),
                               norder = 4,
                               breaks = seq(t[1], t[length(t)], len = 11))
Wfd0   <- fd(matrix(0,wbasis$nbasis,1),wbasis)
WfdPar <- fdPar(Wfd0, 2, 1e-10)
test_reg_0 <- landmarkreg(y1_smooth$fd, landmark, landmark_ref, WfdPar=WfdPar,
                          monwrd = TRUE)

plot(test_reg_0$warpfd, col = rgb(0, 0, 0, 0.25), lty = 1)
plot(test_reg_0$regfd)

# Make the plot ---------------------------------------------------------------

# Unregistered Curves
pdf(otpfullnames[1], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0),
    bty = "l")
# Set plotting canvas
plot(0, 0, xlim = range(t), ylim = range(y), type = "n",
     yaxt = "n",
     xaxt = "n",
     xlab = "",
     ylab = "")
# Set Axis, Ticks and Labels
# x-axis
title(xlab = "t", mgp = c(1.5, 0, 0), cex.lab = cex_lab)
# y-axis
title(ylab = "y(t)", mgp = c(1.5, 0, 0), cex.lab = cex_lab)

# Plot the curves
lines(y1_smooth$fd, col = rgb(0, 0, 0, 0.25), lty = 1)
# Plot the landmarks
abline(v=landmark, col = rgb(0, 0, 0, 0.25), lwd = 1)
abline(v=landmark_ref, lty = 2, lwd = 2)
# Plot the structural mean
lines(t, eval.fd(t,mean.fd(test_reg_0$regfd)), lwd = 3, lty = 2)

# Close the device
dev.off()

# Plot the Registered curves
pdf(otpfullnames[2], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0),
    bty = "l")
# Set plotting canvas
plot(0, 0, xlim = range(t), ylim = range(y), type = "n",
     yaxt = "n",
     xaxt = "n",
     xlab = "",
     ylab = "")
# Set Axis, Ticks and Labels
# x-axis
title(xlab = "t", mgp = c(1.5, 0, 0), cex.lab = cex_lab)
# y-axis
title(ylab = "y(t)", mgp = c(1.5, 0, 0), cex.lab = cex_lab)

# Plot the curves
lines(test_reg_0$regfd, col = rgb(0, 0, 0, 0.25), lty = 1)
# Plot the landmark reference
abline(v=landmark_ref, lty = 2, lwd = 1)
# Plot the structural mean
lines(t, eval.fd(t,mean.fd(test_reg_0$regfd)), lwd = 3, lty = 2)

# Close the device
dev.off()