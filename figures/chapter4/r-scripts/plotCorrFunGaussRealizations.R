#
# title     : plotCorrFunGaussRealizations.R
# purpose   : R script to create an illustration of realizations from GP using 
#           : Gaussian correlation function
# figure    : 7
# author    : WD41, LRS/EPFL/PSI
# date      : Jan. 2017
#
# Set Random Number -----------------------------------------------------------
set.seed(2345790)

# Load required libraries or custom functions ---------------------------------
library("DiceKriging")

# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotCorrFunGaussRealization_1.pdf",
                  "./figures/plotCorrFunGaussRealization_2.pdf",
                  "./figures/plotCorrFunGaussRealization_3.pdf")
# Graphic Parameters
fig_size <- c(6.5, 6.5)             # width, height
margin <- c(4, 5, 2.2, 1) + 0.1     # canvas margin (bot, left, top, right)
cex_axis <- 2.5     # Axis marker size
cex_lab  <- 3.0     # Axis label size
cex_main <- 3.0     # Main title size
tck_len  <- -0.35   # Tick length
cex_lab_shift <- 1.25   # Shift of the axis label from the axis

# Parameters for Illustration -------------------------------------------------
thetas <- c(0.1, 1.0, 10.0)      # Characteristic length scale
n_sim <- 3                       # Number of realizations

# Construct DiceKriging covariance structure ----------------------------------
x <- seq(0, 3, length.out = 500)

y_sim <- list()

for (i in 1:length(thetas)) {
    km_model <- km(~0, 
                   design = data.frame(x=x), 
                   response = rep(0,500), 
                   covtype = "gauss", 
                   coef.trend = 0,
                   coef.cov = thetas[i], 
                   coef.var = 1, 
                   nugget = 1e-4)
    y_sim[[i]] <- simulate(km_model, nsim = 3, newdata = data.frame(x = x))
}

# Make the plot ---------------------------------------------------------------
for (i in 1:length(thetas))
{
    pdf(otpfullnames[i], family = "CM Roman", 
        width = fig_size[1], height = fig_size[2])
    par(mfrow = c(1,1), mar = margin, las = 1,
        oma = c(0, 0, 0, 0), bty = "n")
    
    plot(0, 0, type = "n", 
         xlim = c(0, 3), 
         ylim = c(-3*sqrt(1), 3*sqrt(1)),
         axes = FALSE,
         ylab = "", 
         xlab = "")
    
    for (j in 1:n_sim) lines(x, y_sim[[i]][j,], 
                             type = "l", lty = 1, ylab = "y")
    
    
    # Set Axis, Ticks and Labels
    # x-axis
    axis(side = 1, lwd = 1.5,
         at = c(0:3), 
         mgp = c(3, cex_lab_shift, 0), 
         tcl = tck_len, cex.axis = cex_axis)
    title(xlab = "x", mgp = c(2.5, 0, 0), cex.lab = cex_lab)
    # y-axis
    axis(side = 2, lwd = 1.5,
         at = c(-3*sqrt(1), 0, 3*sqrt(1)), 
         mgp = c(3, cex_lab_shift, 0), 
         tcl = tck_len, 
         cex.axis = cex_axis)
    title(ylab = "y", mgp = c(3.5, 0, 0), cex.lab = cex_lab)
    title(main = parse(text=paste("theta == ", thetas[i], sep = "")),
          cex.main = cex_main)
    dev.off()
    embed_fonts(otpfullnames[i], outfile = otpfullnames[i])
}