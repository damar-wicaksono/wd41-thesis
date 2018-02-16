#
# title     : plotTraceUQPriorTC216.R
# purpose   : R script to plot the 95% uncertainty band of the prior
#           : uncertainty predictions of the cladding temperature (TC)
#           : FEBA Test No. 216
#           : Plot only TC5 for illustration purpose
# author    : WD41, LRS/EPFL/PSI
# date      : Jan. 2018
#
# Load required libraries -----------------------------------------------------
library(ggplot2)

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotTraceUQPriorTC216.png"

# Input filename
rds_tidy_fullname <- "../../../wd41-thesis/figures/data-support/postpro/srs/febaTrans216-febaVars12Influential-srs_1000_12-tc-tidy.Rds"

# Graphic variables
fig_size <- c(3.1, 3.1)
alpha <- 0.75

# Source the plotting script --------------------------------------------------
source("r-scripts/plotTraceUQPriorTC.R")