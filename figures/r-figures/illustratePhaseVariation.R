# Number of curves
n <- 20
# number of observation points
m <- 100

# Argument values
t <- seq(0, 1, length = m+2)[2:(m+1)]

theta <- function(t) dnorm(t, mean = 0.3, sd = 0.2) + dnorm(t, mean = 0.7, sd = 0.15)

plot(t, theta(t))
w <- runif(n, min = -0.20, max = 0.20)
sigma <- 0.1
y <- lapply(w, function(w) {theta(t + w) + w})
t <- lapply(1:n, function(x) t)
plot(0, 0, xlim = c(-0.2, 1.2), ylim = range(y), type = "n",
     xlab = "t",
     ylab = "y(t)")
legend(0.9, 3, legend = expression(theta(t)), lty = 2, lwd = 2)
for (i in 1:n) lines(t[[i]], y[[i]], col = rainbow(n)[i])

y <- matrix(unlist(y), ncol = n, byrow=F)
plot(0, 0, xlim = c(-0.05, 1.05), ylim = range(y), type = "n",
     xlab = "t",
     ylab = "y(t)")
for (i in 1:n) lines(t[[i]], y[,i], col = rgb(0, 0, 0, 0.25))
lines(t, theta(t), lwd = 2, lty = 2)

t <- t[[1]]
landmark <- c()
for(i in 1:n) landmark <- c(landmark, t[which.max(y[,i])])
landmark_ref <- t[which.max(theta(t))]

abline(v=landmark)
abline(v=landmark_ref)


nbasis_test <- 4 + length(t) - 4
breaks <- seq(t[1],t[length(t)],length.out = 30)
rng_test <- range(t)
wbasis.growth <- create.bspline.basis(rangeval=rng_test,
                                      nbasis=32, norder=4,
                                      breaks=breaks)
test_fdpar <- fdPar(wbasis.growth)
y1_smooth <- smooth.basis(t, y[,], test_fdpar)
plot(test_smooth)
lines(t, eval.fd(t, mean.fd(test_smooth$fd)), lwd = 4)


wbasis <- create.bspline.basis(rangeval=c(t[1], t[length(t)]),
                               norder=4, breaks=seq(t[1], t[length(t)], len=11))
Wfd0   <- fd(matrix(0,wbasis$nbasis,1),wbasis)
WfdPar <- fdPar(Wfd0, 2, 1e-10)
test_reg_0 <- landmarkreg(test_smooth$fd, landmark, landmark_ref, WfdPar=WfdPar, monwrd = TRUE)

plot(test_reg_0$warpfd)
plot(test_reg_0$regfd)

lines(t, eval.fd(t,mean.fd(test_reg_0$regfd)), lwd = 4)
lines(t, eval.fd(t, mean.fd(test_smooth$fd)), lwd = 4, col = "red")
lines(t, theta(t), lwd = 2, lty = 2)

png("illustratePhaseVariation.png", width=22, height=11, units="cm", res=600)
par(mfrow=c(1, 2), mar=c(4,4,1,1) + 0.1, las = 1, oma = c(0,0,0,0) + 0.1)

#
n <- 100
w <- runif(n, min = 1.0, max = 2.0)
y2 <- matrix(0, ncol = n, nrow = length(t))
for(i in 1:n) y2[,i] <- exp(w[i] * t)
nbasis_test <- 4 + length(t) - 4
breaks <- seq(t[1],t[length(t)],length.out = 30)
rng_test <- range(t)
wbasis.growth <- create.bspline.basis(rangeval=rng_test,
                                      nbasis=32, norder=4,
                                      breaks=breaks)
test_fdpar <- fdPar(wbasis.growth)
y2_smooth <- smooth.basis(t, y2[,], test_fdpar)
plot(0, 0, xlim = c(-0.025, 1.025), ylim = range(y2), type = "n",
     yaxt = "n",
     xaxt = "n",
     xlab = "",
     ylab = "")
title(xlab = "t", ylab = "y(t)", mgp = c(1.25,1,0))
#legend(0.0, 7, legend = "Mean (Cross-Sectional)", lty = 2, lwd = 3,
#       bty = "n")
for(i in 1:n) lines(t, eval.fd(t, y2_smooth$fd)[,i], col = rgb(0, 0, 0, 0.15))
lines(t, eval.fd(t, mean.fd(y2_smooth$fd)), lty = 2, lwd = 3)

#
plot(0, 0, xlim = c(-0.025, 1.025), ylim = range(y), type = "n",
     yaxt = "n",
     xaxt = "n",
     xlab = "",
     ylab = "")
title(xlab = "t", ylab = "y(t)", mgp = c(1.25,1,0))
legend(0.1, 0.5, legend = c("Mean (Cross-Sectional)", "Mean (Structural)"), 
       lty = c(2,3), lwd = 3, bty = "n")
for(i in 1:20) lines(t, eval.fd(t, y1_smooth$fd)[,i], col = rgb(0, 0, 0, 0.15))
lines(t, eval.fd(t, mean.fd(y1_smooth$fd)), lwd = 3, lty = 2)
lines(t, eval.fd(t,mean.fd(test_reg_0$regfd)), lwd = 3, lty = 3)
dev.off()

plot(0, 0, xlim = c(-0.1, 1.1), ylim = range(y2), type = "n",
     xlab = "t",
     ylab = "y(t)")
