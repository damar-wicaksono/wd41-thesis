#
# title     : plotTraceUQPriorTC214.R
# purpose   : R script to create an uncertainty propagation plot for
#           : clad temperature output
#           : FEBA Test No. 214
# author    : WD41, LRS/EPFL/PSI
# date      : Nov. 2017
#
# Load required libraries -----------------------------------------------------
library(ggplot2)

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotTraceUQPriorTC214.pdf"

# Input filename
rds_tidy_fullname <- "../../../wd41-thesis/figures/data-support/postpro/srs/febaTrans214-febaVars12Influential-srs_1000_12-tc-tidy.Rds"

# Graphic variables
fig_size <- c(18, 9)
alpha <- 0.5

# Source the plotting script --------------------------------------------------
source("r-scripts/plotTraceUQTC.R")