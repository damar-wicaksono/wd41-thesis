#
# title     : plotTraceUQPriorDP216.R
# purpose   : R script to plot the 95% uncertainty band of the prior
#           : uncertainty predictions of the pressure drop (DP)
#           : FEBA Test No. 216
# author    : WD41, LRS/EPFL/PSI
# date      : Jan. 2017
#
# Load required libraries -----------------------------------------------------
library(ggplot2)
library(plyr)

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotTraceUQPriorDP216.png"

# Input filename
rds_tidy_fullname <- "../../../wd41-thesis/figures/data-support/postpro/srs/febaTrans216-febaVars12Influential-srs_1000_12-dp-tidy.Rds"

# Graphic variables
fig_size <- c(3.1, 3.1)

# Source the plotting script --------------------------------------------------
source("r-scripts/plotTraceUQPriorDP.R")