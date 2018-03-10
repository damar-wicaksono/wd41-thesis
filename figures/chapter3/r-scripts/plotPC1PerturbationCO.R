#
# title     : plotPC1PerturbationCO.R
# purpose   : Create an illustration plot of the 1st principal component of the
#           : liquid carryover curves 
#           : and the effect of perturbing the mean function
# author    : WD41, LRS/EPFL/PSI
# date      : August 2017
#
# Load the Required Library ---------------------------------------------------
library(fda)
source("./r-scripts/import.R")
source("./r-scripts/plotHarmonic.R")
source("./r-scripts/plotPCPerturbation.R")

# Global variables ------------------------------------------------------------
# Output filenames (2 separate files)
otpfullnames <- c("./figures/plotPC1CO.pdf",
                  "./figures/plotPC1PerturbationCO.pdf")

pca_fd_fullname <- "../../../postpro/result-qoi/co/rds_fd/febaTrans216Ext-febaVars12Influential-sobol_2000_12-co-fpc.Rds"

harmonic <- 1   # which harmonics

# Graphic Parameters
fig_size <- c(4, 4)             # width, height
x_limits <- c(0, 550)
y_limits <- c(0, 20)
output_labels <- c("Principal Component [kg]",
                   "Liquid Carryover [kg]")

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
p2 <- plotPCPerturbation(pca_fd, harmonic)
# Set x-axis limits and labels
p2 <- p2 + scale_x_continuous(limits = c(x_limits[1], x_limits[2]))
p2 <- p2 + labs(x = "Time [s]")
# Set y-axis limits and labels
p2 <- p2 + scale_y_continuous(limits = c(y_limits[1], y_limits[2]))
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
