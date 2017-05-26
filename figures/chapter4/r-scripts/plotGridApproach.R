#
# title     : plotGridApproach.R
# purpose   : R script to create an illustration of grid approach in design of
#           : experiment 
# author    : WD41, LRS/EPFL/PSI
# date      : May 2017
#
# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotGridApproach_1.pdf",
                  "./figures/plotGridApproach_2.pdf",
                  "./figures/plotGridApproach_3.pdf")
# Graphic Parameters
fig_size <- c(6.5, 6.5)             # width, height
margin <- c(4, 5, 2.2, 1) + 0.1     # canvas margin (bot, left, top, right)
cex_axis <- 2.5     # Axis marker size
cex_lab  <- 3.0     # Axis label size
cex_main <- 3.0     # Main title size
tck_len  <- -0.35   # Tick length
cex_lab_shift <- 1.25   # Shift of the axis label from the axis

# Parameters for Illustration -------------------------------------------------
num_levels <- c(5, 10, 20)
num_points <- num_levels^2
i <- 20
# Make the plot ---------------------------------------------------------------
for (i in 1:length(num_levels))
{
    pdf(otpfullnames[i], family = "CM Roman", 
        width = fig_size[1], height = fig_size[2])
    par(mfrow = c(1,1), mar = margin, las = 1,
        oma = c(0, 0, 0, 0), bty = "n")
    
    plot(0, 0, type = "n", 
         xlim = c(0, 1), 
         ylim = c(0, 1),
         axes = FALSE,
         ylab = "", 
         xlab = "")
    
    for (j in 0:(num_levels[i]+1)){
        lines(replicate(num_levels[i]+1, j * 1/num_levels[i]), 
              seq(0, 1, length.out = num_levels[i]+1), 
              ylim = c(0,1))
        lines(seq(0, 1, length.out = num_levels[i]+1), 
              replicate(num_levels[i]+1, j * 1/num_levels[i]), 
              xlim = c(0,1))
    }
    
    # Set Axis, Ticks and Labels
    # x-axis
    axis(side = 1, lwd = 1.5,
         at = c(0:1), 
         mgp = c(3, cex_lab_shift, 0), 
         tcl = tck_len, cex.axis = cex_axis)
    title(xlab = expression(x[1]), mgp = c(2.5, 0, 0), cex.lab = cex_lab)
    # y-axis
    axis(side = 2, lwd = 1.5,
         at = c(0,1), 
         mgp = c(3, cex_lab_shift, 0), 
         tcl = tck_len, 
         cex.axis = cex_axis)
    title(ylab = expression(x[2]), mgp = c(2.5, 0, 0), cex.lab = cex_lab)
    dev.off()
    embed_fonts(otpfullnames[i], outfile = otpfullnames[i])
}