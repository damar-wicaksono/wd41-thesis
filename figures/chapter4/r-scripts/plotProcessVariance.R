#
# title     : plotProcessVariance.R
# purpose   : R script to create an illustration of realizations from GP using 
#           : Gaussian correlation function with different process variance
# author    : WD41, LRS/EPFL/PSI
# date      : May. 2017
#
# Set Random Number -----------------------------------------------------------
set.seed(2345790)

# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotProcessVariance_1.pdf",
                  "./figures/plotProcessVariance_2.pdf",
                  "./figures/plotProcessVariance_3.pdf")
# Graphic Parameters
fig_size <- c(6.5, 6.5)             # width, height
margin <- c(4, 5, 2.2, 1) + 0.1     # canvas margin (bot, left, top, right)
cex_axis <- 2.5     # Axis marker size
cex_lab  <- 3.0     # Axis label size
cex_main <- 3.0     # Main title size
tck_len  <- -0.35   # Tick length
cex_lab_shift <- 1.25   # Shift of the axis label from the axis

# Construct DiceKriging covariance structure ----------------------------------
x <- seq(0, 3, length.out = 100)

theta <- 1.0
proc_vars <- c(1.0, 25., 100.)
n_sim <- 3

y_sim <- list()

for (i in 1:length(proc_vars)) 
{
    km_model <- km(~0, 
                   design = data.frame(x=x), 
                   response=rep(0, 100), 
                   covtype="gauss", 
                   coef.trend=0,
                   coef.cov=theta, 
                   coef.var=proc_vars[i], 
                   nugget=1e-4)
    
    y_sim[[i]] <- simulate(km_model, nsim=n_sim, newdata=data.frame(x=x))
    
}

# Make the plot ---------------------------------------------------------------
# Plot with process variance of 1.0 (left)
for (i in 1:length(proc_vars))
{
    pdf(otpfullnames[i], family = "CM Roman", 
        width = fig_size[1], height = fig_size[2])
    par(mfrow = c(1,1), mar = margin, las = 1,
        oma = c(0, 0, 0, 0), bty = "n")
    
    plot(0, 0, type = "n", 
         xlim = c(0, 3), 
         ylim = c(-3*sqrt(proc_vars[i]), 3*sqrt(proc_vars[i])),
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
         at = c(-3*sqrt(proc_vars[i]), 0, 3*sqrt(proc_vars[i])), 
         mgp = c(3, cex_lab_shift, 0), 
         tcl = tck_len, 
         cex.axis = cex_axis)
    title(ylab = "y", mgp = c(3.5, 0, 0), cex.lab = cex_lab)
    title(main = parse(text=paste("sigma^2 == ", proc_vars[i], sep = "")),
          cex.main = cex_main)
    dev.off()
    embed_fonts(otpfullnames[i], outfile = otpfullnames[i])
}
