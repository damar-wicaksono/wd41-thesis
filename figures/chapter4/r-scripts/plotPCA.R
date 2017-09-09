#
# title     : plotPCA.R
# purpose   : R script to create an illustration of principal component 
#           : analysis important concepts.
# author    : WD41, LRS/EPFL/PSI
# date      : May 2017
#
# Global variables ------------------------------------------------------------
set.seed(11245012)
otpfullnames <- c("./figures/plotPCA_1.pdf",
                  "./figures/plotPCA_2.pdf")

# Graphic Parameters
fig_size <- c(5, 5)                 # width, height
margin <- c(4, 5, 2.2, 1) + 0.1     # canvas margin (bot, left, top, right)
cex_axis <- 2.5     # Axis marker size
cex_lab  <- 3.0     # Axis label size
cex_main <- 3.0     # Main title size
cex_ann  <- 2.0     # Annotation text
tck_len  <- -0.35   # Tick length
cex_lab_shift <- 1.25   # Shift of the axis label from the axis

# Define the illustrative case ------------------------------------------------
mu <- matrix(c(0, 0))                   # Mean vector
rr <- matrix(c(0.81, -1 * sqrt(0.81) * sqrt(0.25) * 0.85, 
               -1 * sqrt(0.81) * sqrt(0.16) * 0.85, 0.16), 
             nrow = 2)                              # Arbitrary covariance

ll <- t(chol(rr))

n <- 50
zz <- matrix(ncol = 2, nrow = n)

for (i in 1:n)
{
    zz[i, ] <- mu + ll %*% c(as.matrix(rnorm(2), nrow = 2))
}

# Carry out the principal component analysis ----------------------------------
zz_svd  <- svd(scale(zz,scale = F), nv = 2) # SVD on unscaled data
std_dev <- sqrt((zz_svd$d)^2/(n-1))
D <- diag(zz_svd$d)
pc_scores <- zz_svd$u %*% D

#zz_svd_scaled <- svd(scale(zz), nv = 2)    # SVD on scaled data
#D <- diag(zz_svd_scaled$d)
#pc_scores <- zz_svd_scaled$u %*% D
#std_dev <- sqrt(diag(D^2 / (n - 1)))
#diag(D^2 / (n - 1))

computeXY <- function(xx, yy, std_x, eigenvector)
{
    ax1 <- 3 * std_x * cos(atan(eigenvector[2]/eigenvector[1]))
    ax2 <- 3 * std_x * sin(atan(eigenvector[2]/eigenvector[1]))
    return(list(c(mean(xx) - ax1, mean(xx), mean(xx) + ax1),
                c(mean(yy) - ax2, mean(yy), mean(yy) + ax2)))
}

# Data points in the original coordinate system plot --------------------------
idx <- c(23, 20, 27)         # Selected illustrative points
pdf(otpfullnames[1], family = "CM Roman", 
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1,1), mar = margin, las = 1,
    oma = c(0, 0, 0, 0), bty = "n")

plot(0, 0, type = "n", 
     xlim = c(mean(zz[,1]) - 1 * ceiling(3 * sqrt(0.81)), mean(zz[,1]) + ceiling(3 * sqrt(0.81))), 
     ylim = c(mean(zz[,1]) - 1 * ceiling(3 * sqrt(0.81)), mean(zz[,1]) + ceiling(3 * sqrt(0.81))),
     axes = FALSE,
     ylab = "", 
     xlab = "")

points(zz[,1], zz[,2], col = rgb(0, 0, 0, 0.25))
# Principal components lines with +- 3 sigma as length
lines(computeXY(zz[,1], zz[,2], std_dev[1], zz_svd$v[,1])[[1]],
      computeXY(zz[,1], zz[,2], std_dev[1], zz_svd$v[,1])[[2]],
      lwd = 0.5)
lines(computeXY(zz[,2], zz[,1], std_dev[2], zz_svd$v[,2])[[1]],
      computeXY(zz[,2], zz[,1], std_dev[2], zz_svd$v[,2])[[2]],
      lwd = 0.5)

# Illustrative points
points(zz[idx,1], zz[idx,2], pch = 20, cex = 2.0)

# Put labels
label <- data.frame(x = zz[idx,1],
                    y = zz[idx,2])
text(label$x[1], label$y[1], 
     labels = c(parse(text=paste("y[",idx[1],"]", sep = ""))), cex = cex_ann, pos = 2)
text(label$x[2], label$y[2], 
     labels = c(parse(text=paste("y[",idx[2],"]", sep = ""))), cex = cex_ann, pos = 3)
text(label$x[3], label$y[3], 
     labels = c(parse(text=paste("y[",idx[3],"]", sep = ""))), cex = cex_ann, pos = 3)

text(computeXY(zz[,1], zz[,2], std_dev[1], zz_svd$v[,1])[[1]][3] + 0.1, 
     computeXY(zz[,1], zz[,2], std_dev[1], zz_svd$v[,1])[[2]][3] + 0.1, 
     labels = expression(v[1]),
     cex = 1.5)
text(computeXY(zz[,2], zz[,1], std_dev[2], zz_svd$v[,2])[[1]][1] - 0.1, 
     computeXY(zz[,2], zz[,1], std_dev[2], zz_svd$v[,2])[[2]][1] - 0.1, 
     labels = expression(v[2]),
     cex = 1.5)

# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, lwd = 1.5,
     at = c(round(mean(zz[,1])) - ceiling(3 * sqrt(0.81)), 
            round(mean(zz[,1])), 
            round(mean(zz[,1])) + ceiling(3 * sqrt(0.81))), 
     mgp = c(3, cex_lab_shift, 0), 
     tcl = tck_len, cex.axis = cex_axis)
title(xlab = expression(y[1]), mgp = c(3.25, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(round(mean(zz[,1])) - ceiling(3 * sqrt(0.81)), 
            round(mean(zz[,1])), 
            round(mean(zz[,1])) + ceiling(3 * sqrt(0.81))), 
     mgp = c(3, cex_lab_shift, 0), 
     tcl = tck_len, cex.axis = cex_axis)
title(ylab = expression(y[2]), mgp = c(2.5, 0, 0), cex.lab = cex_lab)

dev.off()
embed_fonts(otpfullnames[1], outfile = otpfullnames[1])


# Data points in the new (optimal) coordinate system plot ---------------------
pdf(otpfullnames[2], family = "CM Roman", 
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1,1), mar = margin, las = 1,
    oma = c(0, 0, 0, 0), bty = "n")

plot(0, 0, type = "n", 
     xlim = c(-1 * floor(3 * std_dev[1]), floor(3 * std_dev[1])), 
     ylim = c(-1 * floor(3 * std_dev[1]), floor(3 * std_dev[1])),
     axes = FALSE,
     ylab = "", 
     xlab = "")

points(pc_scores[,1], pc_scores[,2], col = rgb(0, 0, 0, 0.25))

lines(c(-3 * sd(pc_scores[,1]), 0, 3 * sd(pc_scores[,1])), c(0, 0, 0), 
      lwd = 0.5)
lines(c(0, 0, 0), c(-3 * sd(pc_scores[,2]), 0, 3 * sd(pc_scores[,2])), 
      lwd = 0.5)
# Illustrative points
points(pc_scores[idx,1], pc_scores[idx,2], pch = 20, cex = 2.0)
label <- data.frame(x = pc_scores[idx,1],
                    y = pc_scores[idx,2])
# Put labels
for (i in 1:3) 
{
    lines(c(pc_scores[idx[i],1], pc_scores[idx[i],1]), c(0, pc_scores[idx[i],2]), lwd = .5, lty = 2)
    lines(c(0, pc_scores[idx[i],1]), c(pc_scores[idx[i],2], pc_scores[idx[i],2]), lwd = .5, lty = 2)
}
text(label$x[1], label$y[1], 
     labels = c(parse(text=paste("w[",idx[1],"]", sep = ""))), cex = cex_ann, pos = 2)
text(label$x[2], label$y[2], 
     labels = c(parse(text=paste("w[",idx[2],"]", sep = ""))), cex = cex_ann, pos = 1)
text(label$x[3], label$y[3], 
     labels = c(parse(text=paste("w[",idx[3],"]", sep = ""))), cex = cex_ann, pos = 1)

# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, lwd = 1.5,
     at = c(-1 * floor(3 * std_dev[1]), 0, floor(3 * std_dev[1])), 
     mgp = c(3, cex_lab_shift, 0), 
     tcl = tck_len, cex.axis = cex_axis)
title(xlab = expression(v[1]), mgp = c(3.25, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(-1 * floor(3 * std_dev[1]), 0, floor(3 * std_dev[1])), 
     mgp = c(3, cex_lab_shift, 0), 
     tcl = tck_len, cex.axis = cex_axis)
title(ylab = expression(v[2]), mgp = c(2.5, 0, 0), cex.lab = cex_lab)

# Save the plot
dev.off()
embed_fonts(otpfullnames[2], outfile = otpfullnames[2])
