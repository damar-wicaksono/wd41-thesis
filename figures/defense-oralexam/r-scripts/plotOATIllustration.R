#
# title     : plotOATIllustration.R
# purpose   : Create an illustration plot of phase variation in a functional
#           : data set
# author    : WD41, LRS/EPFL/PSI
# date      : September 2017
#
# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotOATIllustration_1.png",
                  "./figures/plotOATIllustration_2.png")

# Input filenames
inpfullnames <- c("../chapter3/data-support/trajectory_4_2_6.csv",
                  "../chapter3/data-support/radial_4_2.csv")

# Graphic parameters
fig_size <- c(4, 4)                     # width, height
margin   <- c(4, 6.5, 2.2, 1) + 0.1     # canvas margin (bot, left, top, right)
cex_axis <- 1.5     # Axis marker size
cex_lab  <- 2.0     # Axis label size
tck_len  <- -0.35   # Tick length
cex_lab_shift <- 1.25   # Shift of the axis label from the axis

# Read the data ---------------------------------------------------------------
oat_trj <- read.csv(inpfullnames[1], header = FALSE)
oat_rad <- read.csv(inpfullnames[2], header = FALSE)

# Make the plot ---------------------------------------------------------------

# Trajectory Design
png(otpfullnames[1],
    width = fig_size[1], height = fig_size[2], units = "in", res = 600)
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "n")

plot(-1, -1, xlim = c(0, 1.0), ylim = c(0, 1.0),
     xlab = "", ylab = "", axes = FALSE)
for (i in 1:4)
{
    j <- (i - 1) * 2 + i
    points(oat_trj$V1[j], oat_trj$V2[j], pch = 16)
    for (k in 1:2)
    {
        l <- (j+1):(j+2)
        points(oat_trj$V1[l], oat_trj$V2[l], pch = 4)
        
        if (k == 1)
        {
            lines(c(oat_trj$V1[j], oat_trj$V1[l[k]]),
                  c(oat_trj$V2[j], oat_trj$V2[l[k]]),
                  lwd = 0.5)    
        } else
        {
            lines(oat_trj$V1[l], oat_trj$V2[l],
                  lwd = 0.5)
        }   
    }
}

# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, lwd = 1.5,
     at = c(0, 0.5, 1.0), 
     mgp = c(3, cex_lab_shift, 0), 
     tcl = tck_len, cex.axis = cex_axis)
title(xlab = "", mgp = c(3.0, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(0, 0.5, 1.0), 
     mgp = c(2, cex_lab_shift, 0), 
     tcl = tck_len, 
     cex.axis = cex_axis)
title(ylab = "", mgp = c(3.0, 0, 0), cex.lab = cex_lab)

# Close the device
dev.off()

# Radial Design
png(otpfullnames[2],
    width = fig_size[1], height = fig_size[2], units = "in", res = 600)
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "n")

plot(-1, -1, xlim = c(0, 1.0), ylim = c(0, 1.0), 
     xlab = "", ylab = "", axes = FALSE)

for (i in 1:4)
{
    j <- (i - 1) * 2 + i
    points(oat_rad$V1[j], oat_rad$V2[j], pch = 16)
    for (k in 1:2)
    {
        l <- (j+1):(j+2)
        points(oat_rad$V1[l], oat_rad$V2[l], pch = 4)
        lines(c(oat_rad$V1[j], oat_rad$V1[l[k]]), 
              c(oat_rad$V2[j], oat_rad$V2[l[k]]),
              lwd = 0.5)    
    }
}

# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, lwd = 1.5,
     at = c(0, 0.5, 1.0), 
     mgp = c(3, cex_lab_shift, 0), 
     tcl = tck_len, cex.axis = cex_axis)
title(xlab = "", mgp = c(3.0, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(0, 0.5, 1.0), 
     mgp = c(2, cex_lab_shift, 0), 
     tcl = tck_len, 
     cex.axis = cex_axis)
title(ylab = "", mgp = c(3.0, 0, 0), cex.lab = cex_lab)

# Close the device
dev.off()
