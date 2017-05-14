#
# title     : plotCorrFunPowExp.R
# purpose   : R script to create a plot of power exponential orrelation 
#           : function with different shape and scale parameters values
# author    : WD41, LRS/EPFL/PSI
# date      : May 2017
#
# Load required libraries or custom functions ---------------------------------
library("DiceKriging")

# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotCorrFunPowExp_1.pdf",
                  "./figures/plotCorrFunPowExp_2.pdf",
                  "./figures/plotCorrFunPowExp_3.pdf")
# Graphic Parameters
fig_size <- c(6.5, 6.5)                 # width, height
margin <- c(5.25, 6.25, 2.2, 1) + 0.1   # canvas margin (bot, left, top, right)
cex_axis <- 2.0     # Axis marker size
cex_lab  <- 2.5     # Axis label size
leg_cex <- 2.0      # Legend size
tck_len  <- -0.35   # Tick length
cex_lab_shift <- 1.25   # Shift of the axis label from the axis
cex_ttl_shift <- 4.25   # Shift of the axis title from the axis

# Illustrative Case Parameters
thetas <- c(0.1, 0.5, 2.5)      # Characteristic length scale
pow_fac <- c(0.1, 0.5, 2.0)     # The power factor
n_sim <- 3                      # Number of realizations

# Construct DiceKriging covariance structure ----------------------------------
x <- seq(0, 3, length.out = 500)

y_cov <- list()

for (i in 1:3) 
{
    # Iterate over the characteristic length scale
    j <- 1
    powexp_cov <- covStruct.create(covtype="powexp",
                                   d=1,
                                   known.covparam = "All",
                                   var.names = "x",
                                   coef.cov = c(thetas[j], pow_fac[i]),
                                   coef.var = 1)
    y_cov[[i]] <- covMat1Mat2(powexp_cov, as.matrix(x), as.matrix(0))
    for (j in 2:3)
    {
        # Iterate over the power factor
        powexp_cov <- covStruct.create(covtype="powexp",
                                       d=1,
                                       known.covparam = "All",
                                       var.names = "x",
                                       coef.cov = c(thetas[j], pow_fac[i]),
                                       coef.var = 1)
        y_cov[[i]] <- cbind(y_cov[[i]], 
                            covMat1Mat2(powexp_cov, as.matrix(x), as.matrix(0)))
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

for (i in 1:length(proc_vars))
{
    pdf(otpfullnames[i], family = "CM Roman", 
        width = fig_size[1], height = fig_size[2])
    par(mfrow = c(1,1), mar = margin, las = 1,
        oma = c(0, 0, 0, 0), bty = "n")
    
    plot(0, 0, type = "n", 
         xlim = c(0, 3), 
         ylim = c(0, 1),
         axes = FALSE,
         ylab = "", 
         xlab = "")
    
    for (j in 1:n_sim) lines(x, y_cov[[i]][,j], type = "l", lty = j, lwd = 2)
    
    
    # Set Axis, Ticks and Labels
    # x-axis
    axis(side = 1, lwd = 1.5,
         at = c(0:3), 
         mgp = c(3, cex_lab_shift, 0), 
         tcl = tck_len, cex.axis = cex_axis)
    title(xlab = expression(group("|",x[i]-x[j],"|")), 
          mgp = c(cex_ttl_shift, 0, 0), cex.lab = cex_lab)
    # y-axis
    axis(side = 2, lwd = 1.5,
         at = c(0, 0.5, 1), 
         mgp = c(3, cex_lab_shift, 0), 
         tcl = tck_len, 
         cex.axis = cex_axis)
    title(ylab = "y", mgp = c(cex_ttl_shift, 0, 0), cex.lab = cex_lab)
    title(main = paste("p = ", pow_fac[i]),
          cex.main = cex_main)
    
    legend(1.50, 0.9, legend_expressions, lty = c(1, 2, 3), 
           lwd = 2, bty = "n", 
           cex = leg_cex)
    
    dev.off()
    embed_fonts(otpfullnames[i], outfile = otpfullnames[i])
}


