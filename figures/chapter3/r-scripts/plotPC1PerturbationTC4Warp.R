#
# title     : plotPC1PerturbationTC4Warp.R
# purpose   : Create an illustration plot of the 1st principal component of the
#           : mid-assembly temperature curve warping functions
#           : and the effect of perturbing around the mean function
# author    : WD41, LRS/EPFL/PSI
# date      : August 2017
#
# Load the Required Library ---------------------------------------------------
library(fda)
source("./r-scripts/plotHarmonic.R")
source("./r-scripts/plotPCPerturbation.R")

# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotPC1TC4Warp.pdf",
                  "./figures/plotPC1PerturbationTC4Warp.pdf") # Output filenames

pca_fd_fullname <- "../../../analysis/sobol/results/tc_warpfd_pcafd-tc_4.Rds"

harmonic <- 1   # which harmonics

# Graphic Parameters
fig_size <- c(4, 4)             # width, height
x_limits <- c(0, 550)
#y_limits <- c(400, 1400)
output_labels <- c("Principal Component [s]",
                   "Warping Function [s]")

# Read the Data ----
pca_fd <- readRDS(pca_fd_fullname)

# Make the plot -----
# Harmonic plot
p1 <- plotHarmonic(pca_fd, harmonic)
# Set x-axis limits and labels
p1 <- p1 + scale_x_continuous(limits = c(x_limits[1], x_limits[2]))
p1 <- p1 + labs(x = "Time [s]")
# Set y-axis limits and labels
p1 <- p1 + labs(y = output_labels[1])

# Perturbation plot
p2 <- plotPCPerturbation(pca_fd, 1)
# Set x-axis limits and labels
p2 <- p2 + scale_x_continuous(limits = c(x_limits[1], x_limits[2]))
p2 <- p2 + labs(x = "Time [s]")
# Set y-axis limits and labels
p2 <- p2 + labs(y = output_labels[2])

# Save into a pdf -------------------------------------------------------------
# 1st plot
pdf(otpfullnames[1], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
print(p1)
dev.off()
embed_fonts(otpfullnames[1], outfile=otpfullnames[1])
# 2nd plot
pdf(otpfullnames[2], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
print(p2)
dev.off()
embed_fonts(otpfullnames[2], outfile=otpfullnames[2])
