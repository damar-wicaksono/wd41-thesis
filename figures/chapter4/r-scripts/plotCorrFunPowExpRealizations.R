#
# title     : plotCorrFunPowExpRealizations.R
# purpose   : R script to create an illustration of realizations from GP using 
#           : power-exponential correlation function
# author    : WD41, LRS/EPFL/PSI
# date      : May 2017
#
# Set Random Number -----------------------------------------------------------
set.seed(2345790)

# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotCorrFunPowExpRealizations_1.pdf",
                  "./figures/plotCorrFunPowExpRealizations_2.pdf",
                  "./figures/plotCorrFunPowExpRealizations_3.pdf")

# Graphic Parameters
fig_size <- c(6.5, 6.5)             # width, height
margin <- c(4, 5, 2.2, 1) + 0.1     # canvas margin (bot, left, top, right)
cex_axis <- 2.5     # Axis marker size
cex_lab  <- 3.0     # Axis label size
cex_main <- 3.0     # Main title size
tck_len  <- -0.35   # Tick length
cex_lab_shift <- 1.25   # Shift of the axis label from the axis

# Illustrative Case Parameters
thetas <- c(0.1, 0.5, 2.5)      # Characteristic length scale
pow_fac <- c(0.1, 1.0, 2.0)     # The power factor
n_sim <- 1                      # Number of realizations

# Construct DiceKriging covariance structure ----------------------------------
x <- seq(0, 3, length.out = 500)

y_sim <- list()

for (i in 1:3) 
{
    # Iterate over the characteristic length scale
    j <- 1
    km_model <- km(~0, 
                   design=data.frame(x=x), 
                   response=rep(0,500), 
                   covtype="powexp", 
                   coef.trend=0,
                   coef.cov=c(thetas[j], pow_fac[i]), 
                   coef.var=1, 
                   nugget=1e-4)
    
    y_sim[[i]] <- simulate(km_model, nsim=n_sim, newdata=data.frame(x=x))
    
    for (j in 2:3)
    {
        # Iterate over the power factor
        km_model <- km(~0, 
                       design=data.frame(x=x), 
                       response=rep(0,500), 
                       covtype="powexp", 
                       coef.trend=0,
                       coef.cov=c(thetas[j], pow_fac[i]), 
                       coef.var=1, 
                       nugget=1e-4)
        y_sim[[i]] <- rbind(y_sim[[i]], 
                            simulate(km_model, nsim=n_sim, newdata=data.frame(x=x)))
    }    
}

# Make the plot ---------------------------------------------------------------
# Create legend expression because greek symbol involves
legend_labels <- c()
for(i in 1:3)
{
    legend_labels <- c(legend_labels, 
                       paste("theta == ", thetas[i], sep=""))
}
legend_expressions <- parse(text=legend_labels) # use parse for expression inp.

for (i in 1:3)
{
    pdf(otpfullnames[i], family = "CM Roman", 
        width = fig_size[1], height = fig_size[2])
    
    par(mfrow = c(1,1), mar = margin, las = 1,
        oma = c(0, 0, 0, 0), bty = "n")
    
    plot(0, 0, 
         type = "n", xlim = c(0, 3.0), ylim = c(-3, 3), axes = FALSE,
         ylab = "",
         xlab = "")
    for (k in 1:3) lines(x, y_sim[[i]][k,], lty = k, lwd = 1.5)
    
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
    title(main = paste("p =", pow_fac[i], sep = " "),
          cex.main = cex_main)

    if (i == 3) {
        legend(0.05, 3.2, legend_expressions, lty = c(1, 2, 3), 
               lwd = 2, bty = "n", 
               cex = leg_cex)
    }
    
    dev.off()
    embed_fonts(otpfullnames[i], outfile = otpfullnames[i])
}


