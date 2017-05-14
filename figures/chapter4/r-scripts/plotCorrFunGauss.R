#
# title     : plotCorrFunGauss.R
# purpose   : R script to create a plot of Gaussian correlation function
#           : with several different length scale parameter values
# author    : WD41, LRS/EPFL/PSI
# date      : May. 2017
#
# Load required libraries or custom functions ---------------------------------
library("DiceKriging")

# Global variables ------------------------------------------------------------
otpfullname <- c("./figures/plotCorrFunGauss.pdf")

# Graphic Parameters
fig_size <- c(6.5, 6.5)                   # width, height
margin <- c(5.25, 6.25, 2.2, 1) + 0.1     # canvas margin (bot, left, top, right)
cex_axis <- 2.0     # Axis marker size
cex_lab  <- 2.5     # Axis label size
leg_cex <- 2.0      # Legend size
tck_len  <- -0.35   # Tick length
cex_lab_shift <- 1.25   # Shift of the axis label from the axis

thetas <- c(0.1, 1.0, 10.0)      # Characteristic length scale
n_sim <- 3                       # Number of realizations

# Construct DiceKriging covariance structure ----------------------------------
x <- seq(0, 3, length.out = 500)

gauss_cov <- covStruct.create(covtype="gauss",
                              d = 1,
                              known.covparam = "All",
                              var.names = "x",
                              coef.cov = thetas[1],
                              coef.var = 1)

y_cov <- covMat1Mat2(gauss_cov, as.matrix(x), as.matrix(0))

for (i in 2:3) {
    gauss_cov <- covStruct.create(covtype="gauss",
                                  d=1,
                                  known.covparam = "All",
                                  var.names = "x",
                                  coef.cov = thetas[i],
                                  coef.var = 1)
    y_cov <- cbind(y_cov, covMat1Mat2(gauss_cov, as.matrix(x), as.matrix(0)))
}

# Make the plot ---------------------------------------------------------------
pdf(otpfullname, family = "CM Roman", 
    width = fig_size[1], height = fig_size[2])

par(mfrow = c(1,1), 
    mar = margin, 
    las = 1, 
    oma = c(0,0,0,0),
    bty = "n")

plot(0, 0, 
     type = "n", xlim = c(0, 3.0), ylim = c(0, 1.0), axes = FALSE,
     ylab = "",
     xlab = "")

for (i in 1:3) lines(x, y_cov[,i], lty = i, lwd = 2)


# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, at = c(0, 1.0, 2.0, 3.0), mgp = c(3, cex_lab_shift, 0), 
     tcl = tck_len, cex.axis = cex_axis)
title(xlab = expression((x[i] - x[j])^2), mgp = c(4.5, 0, 0), 
      cex.lab = cex_lab)
# y-axis
axis(side = 2, at = c(0, 0.5, 1.0), mgp = c(3, cex_lab_shift, 0), 
     tcl = tck_len, cex.axis = cex_axis)
title(ylab = expression(y), mgp = c(4.5, 0, 0), cex.lab = cex_lab) 

# Create legend expression because greek symbol involves
legend_labels <- c()
for(i in 1:3)
{
    legend_labels <- c(legend_labels, paste("theta == ", thetas[i], sep=""))
}
legend_expressions <- parse(text=legend_labels) # use parse for expression inp.

legend(1.50, 0.9, legend_expressions, lty = c(1, 2, 3), 
       lwd = 2, bty="n", 
       cex = leg_cex)

dev.off()
embed_fonts(otpfullname, outfile = otpfullname)