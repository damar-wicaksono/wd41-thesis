#
# title     : plotTraceUQPriorDP218.R
# purpose   : R script to plot the 95% uncertainty band of the prior
#           : uncertainty predictions of the pressure drop (DP)
#           : FEBA Test No. 218
# author    : WD41, LRS/EPFL/PSI
# date      : Dec. 2017
#
# Load required libraries -----------------------------------------------------
library(ggplot2)
library(plyr)

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotTraceUQPriorDP218.pdf"

# Input filename
rds_tidy_fullname <- "../../../wd41-thesis/figures/data-support/postpro/srs/febaTrans218-febaVars12Influential-srs_1000_12-dp-tidy.Rds"

# Graphic variables
fig_size <- c(14, 4)
alpha <- 0.75
plot_title <- parse(
  text = "'FEBA Test No. 218, '*P[sys]*' = 2.1 [bar], Flooding Rate = 5.8 ['*m.s^-1*']'")

# Source the plotting script --------------------------------------------------
source("r-scripts/plotTraceUQPriorDP.R")