#
# title     : plotTraceUQPriorCO222.R
# purpose   : R script to plot the 95% uncertainty band of the prior
#           : uncertainty predictions of the liquid carryover (DP)
#           : FEBA Test No. 222
# author    : WD41, LRS/EPFL/PSI
# date      : Dec. 2017
#
# Load required libraries -----------------------------------------------------
library(ggplot2)

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotTraceUQPriorCO222.pdf"

# Input filename
rds_tidy_fullname <- "../../../wd41-thesis/figures/data-support/postpro/srs/febaTrans222-febaVars12Influential-srs_1000_12-co-tidy.Rds"

# Graphic variables
fig_size <- c(5, 5)
alpha <- 0.75
x_lims <- c(0, 150.)
y_lims <- c(0, 20.0)

# Source the plotting script --------------------------------------------------
source("r-scripts/plotTraceUQPriorCO.R")