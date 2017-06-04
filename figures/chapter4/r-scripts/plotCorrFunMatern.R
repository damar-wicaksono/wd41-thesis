#
# title     : plotCorrFunMatern.R
# purpose   : R script to create a plot of Matern correlation kernel 
#           : function with different range and shape parameters values
# author    : WD41, LRS/EPFL/PSI
# date      : June 2017
#
# Load required libraries or custom functions ---------------------------------
library("DiceKriging")

# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotCorrFunMatern_1.pdf",
                  "./figures/plotCorrFunMatern_2.pdf")
# Graphic Parameters
fig_size <- c(6.5, 6.5)                 # width, height
margin <- c(5.25, 6.25, 2.2, 1) + 0.1   # canvas margin (bot, left, top, right)
cex_axis <- 2.0     # Axis marker size
cex_lab  <- 2.5     # Axis label size
leg_cex <- 2.0      # Legend size
tck_len  <- -0.35   # Tick length
cex_lab_shift <- 1.25   # Shift of the axis label from the axis
cex_ttl_shift <- 4.25   # Shift of the axis title from the axis

# Construct DiceKriging covariance structure ----------------------------------
thetas <- c(1.0, 2.0)
nu_string <- c("3 / 2", " 5 / 2")
matern <- c("matern3_2", "matern5_2")
nu <- c(3/2, 5/2)

x <- seq(0, 3, length.out = 500)

y_cov <- list()

for (i in 1:2) 
{
    # Iterate over the range parameter
    for (j in 1:2)
    {
        powexp_cov <- covStruct.create(covtype=matern[j],
                                       d=1,
                                       known.covparam = "All",
                                       var.names = "x",
                                       coef.cov = thetas[i],
                                       coef.var = 1)
        if (j == 1) 
        {
            y_cov[[i]] <- covMat1Mat2(powexp_cov, as.matrix(x), as.matrix(0))
        } else
        {
            y_cov[[i]] <- cbind(y_cov[[i]], 
                                covMat1Mat2(powexp_cov, 
                                            as.matrix(x), 
                                            as.matrix(0)))
        }
    }
}

# Create legend expression because greek symbol involves
legend_labels <- c()
for(i in 1:2)
{
    legend_labels <- c(legend_labels, 
                       paste("nu == ", nu_string[i], sep=""))
}
legend_expressions <- parse(text=legend_labels) # use parse for expression inp.

for (i in 1:length(thetas))
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
    
    for (j in 1:length(nu)) lines(x, y_cov[[i]][,j], 
                                  type = "l", lty = j, lwd = 2)
    
    
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
    title(main = parse(text=paste("theta == ", thetas[i])),
          cex.main = cex_main)
    
    legend(1.5, 0.9, legend_expressions, lty = c(1, 2), 
           lwd = 2, bty = "n", 
           cex = leg_cex)
    
    dev.off()
    embed_fonts(otpfullnames[i], outfile = otpfullnames[i])
}
