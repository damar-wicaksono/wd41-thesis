#
# title     : plotImageTCRun.R
# purpose   : R script to create a plot of "image" clad temperature output 
#           : as function of time and axial location
# author    : WD41, LRS/EPFL/PSI
# date      : Aug. 2017
#
# Load required libraries -----------------------------------------------------
library(fields)
library(viridis)

# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotImageTCRun1.pdf",
                  "./figures/plotImageTCRun2.pdf",
                  "./figures/plotImageTCRun3.pdf")

# Input data filename
trc_valid_path <- "../../../../wd41-thesis.analysis.new/postpro-gp-training/result-compiled"
trc_valid_filename <- "febaTrans216Ext-febaVars12Influential-sobol_1920_12.Rds"

ax_locs <- c(0.254, 0.749, 1.344, 1.889, 2.434, 2.979, 3.524, 4.069)

# Graphic parameters
fig_size <- c(8, 7)                 # width, height
margin <- c(4, 5, 2.2, 1) + 0.1     # canvas margin (bot, left, top, right)
cex_axis <- 2.0     # Axis marker size
cex_lab  <- 2.5     # Axis label size
tck_len  <- -0.35   # Tick length
cex_lab_shift <- 1.25   # Shift of the axis label from the axis

set.seed(123890)
idx_runs <- sample(1:1920, 3)

# Read Data -------------------------------------------------------------------
trc_runs <- readRDS(paste0(trc_valid_path, "/", trc_valid_filename))

# Make the plot ---------------------------------------------------------------
for (i in 1:3)
{
    trc_run <- trc_runs$replicates[2:length(trc_runs$time), idx_runs[i], 1:8]
    
    pdf(otpfullnames[i], family = "CM Roman", 
        width = fig_size[1], height = fig_size[2])
    par(mfrow = c(1,1), mar = margin, las = 1,
        oma = c(0, 0, 0, 0), bty = "n")
    if (i == 3)
    {
        image.plot(seq(0.1, 999.9, by = 0.1), ax_locs, trc_run, add = F,
                   zlim = c(300, 1400),
                   nlevel = 64, col = magma(64),
                   xlab = "Time [s]",
                   ylab = "Axial Location [m]",
                   xlim = c(0., 750.),
                   cex.axis = cex_axis,
                   cex.lab = cex_lab,
                   tcl = tck_len)    
    } else
    {
        image(seq(0.1, 999.9, by = 0.1), ax_locs, trc_run, add = F,
              zlim = c(300, 1400),
              nlevel = 64, col = magma(64),
              xlab = "Time [s]",
              ylab = "Axial Location [m]",
              xlim = c(0., 750.),
              cex.axis = cex_axis,
              cex.lab = cex_lab,
              tcl = tck_len)
    }
    
    dev.off()
    embed_fonts(otpfullnames[i], outfile = otpfullnames[i])
}
