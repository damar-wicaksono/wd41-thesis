#
# title     : plotDesignExamples.R
# purpose   : R script to create an illustration of design
# author    : WD41, LRS/EPFL/PSI
# date      : May 2016
#
# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotDesignExamples_1.pdf",
                  "./figures/plotDesignExamples_2.pdf",
                  "./figures/plotDesignExamples_3.pdf")
# Graphic Parameters
fig_size <- c(6.5, 6.5)             # width, height
margin <- c(4, 5, 2.2, 1) + 0.1     # canvas margin (bot, left, top, right)
cex_axis <- 2.5     # Axis marker size
cex_lab  <- 3.0     # Axis label size
cex_main <- 3.0     # Main title size
tck_len  <- -0.35   # Tick length
cex_lab_shift <- 1.25   # Shift of the axis label from the axis

# Load required data ----------------------------------------------------------
n_samples <- 64
dm_names <- c("x1", "x2")
dm <- list()
dm[[1]] <- read.csv("./data-support/srs_64_2.csv", header = FALSE,
                    col.names = dm_names)
dm[[2]] <- read.csv("./data-support/lhs_64_2.csv", header = FALSE,
                    col.names = dm_names)
dm[[3]] <- read.csv("./data-support/sobol_64_2.csv", header = FALSE,
                    col.names = dm_names)

# Make the plot ---------------------------------------------------------------
for (i in 1:3)
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
    
    points(dm[[i]]$x1, dm[[i]]$x2, pch = 4, 
         xlab = expression(x[1]),
         ylab = expression(x[2]),
         cex = 2.0)
    
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
