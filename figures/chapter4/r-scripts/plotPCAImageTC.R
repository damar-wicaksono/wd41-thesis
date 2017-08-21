#
# title     : plotPCAImageTC.R
# purpose   : R script to create a plot of principal component of 
#           : the temperature output as image (function of time and axial 
#           : location)
#           : 0-th PC indicates the average output
# author    : WD41, LRS/EPFL/PSI
# date      : Aug. 2017
#
# Load required libraries -----------------------------------------------------
library(fields)
library(viridis)

# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotPCAImageAve.pdf",
                  "./figures/plotPCAImagePC1.pdf",
                  "./figures/plotPCAImagePC2.pdf")

# Input data filename
trc_train_pca_path <- "../../../../wd41-thesis.analysis.new/trace-gp/result-pc/"
trc_train_pca_filename <- c(
    "febaTrans216Ext-febaVars12Influential-sobol_1920_12-tc-pca.Rds")

ax_locs <- c(0.254, 0.749, 1.344, 1.889, 2.434, 2.979, 3.524, 4.069)

# Graphic parameters
fig_size <- c(8, 7)                 # width, height
margin <- c(4, 5, 2.2, 1) + 0.1     # canvas margin (bot, left, top, right)
cex_axis <- 2.0     # Axis marker size
cex_lab  <- 2.5     # Axis label size
tck_len  <- -0.35   # Tick length
cex_lab_shift <- 1.25   # Shift of the axis label from the axis

# Read Data -------------------------------------------------------------------
trc_train_pca <- readRDS(
    paste0(trc_train_pca_path, "/", trc_train_pca_filename))

# Make the plot ---------------------------------------------------------------
for (i in 1:3)
{
    if (i == 1)
    {
        pc <- matrix(trc_train_pca$yy_train_ave, ncol = 8)
    } else
    {
        pc <- matrix(trc_train_pca$yy_train_loadings[, i], ncol = 8)
    }
    pdf(otpfullnames[i], family = "CM Roman", 
        width = fig_size[1], height = fig_size[2])
    par(mfrow = c(1,1), mar = margin, las = 1,
        oma = c(0, 0, 0, 0), bty = "n")
    image.plot(seq(0.1, 999.9, by = 0.1), ax_locs, pc, add = F,
               nlevel = 64, col = magma(64),
               xlab = "Time [s]",
               ylab = "Axial Location [m]",
               xlim = c(0., 750.),
               cex.axis = cex_axis,
               cex.lab = cex_lab,
               tcl = tck_len)
    dev.off()
    embed_fonts(otpfullnames[i], outfile = otpfullnames[i])
}
