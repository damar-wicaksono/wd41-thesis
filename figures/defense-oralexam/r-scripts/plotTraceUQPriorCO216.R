#
# title     : plotTraceUQPriorCO216.R
# purpose   : R script to plot the 95% uncertainty band of the prior
#           : uncertainty predictions of the liquid carryover (DP)
#           : FEBA Test No. 216
# author    : WD41, LRS/EPFL/PSI
# date      : Jan. 2017
#
# Load required libraries -----------------------------------------------------
library(ggplot2)

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotTraceUQPriorCO216.png"

# Input filename
rds_tidy_fullname <- "../../../wd41-thesis/figures/data-support/postpro/srs/febaTrans216-febaVars12Influential-srs_1000_12-co-tidy.Rds"

# Graphic variables
fig_size <- c(3.1, 3.1)
alpha <- 0.75
x_lims <- c(0, 500)

# Source the plotting script --------------------------------------------------
source("r-scripts/plotTraceUQPriorCO.R")