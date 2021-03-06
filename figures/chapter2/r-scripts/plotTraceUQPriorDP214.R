#
# title     : plotTraceUQPriorDP214.R
# purpose   : R script to plot the 95% uncertainty band of the prior
#           : uncertainty predictions of the pressure drop (DP)
#           : FEBA Test No. 214
# author    : WD41, LRS/EPFL/PSI
# date      : Nov. 2017
#
# Load required libraries -----------------------------------------------------
library(ggplot2)

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotTraceUQPriorDP214.pdf"

# Input filename
rds_tidy_fullname <- "../../../wd41-thesis/figures/data-support/postpro/srs/febaTrans214-febaVars12Influential-srs_1000_12-dp-tidy.Rds"

# Graphic variables
fig_size <- c(14, 4)
alpha <- 0.75
plot_title <- parse(
  text = "'FEBA Test No. 214, '*P[sys]*' = 4.1 [bar], Flooding Rate = 5.8 ['*m.s^-1*']'")

# Source the plotting script --------------------------------------------------
source("r-scripts/plotTraceUQPriorDP.R")