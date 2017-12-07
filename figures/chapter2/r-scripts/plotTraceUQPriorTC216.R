#
# title     : plotTraceUQPriorTC216.R
# purpose   : R script to plot the 95% uncertainty band of the prior
#           : uncertainty predictions of the cladding temperature (TC)
#           : FEBA Test No. 216
# author    : WD41, LRS/EPFL/PSI
# date      : Nov. 2017
#
# Load required libraries -----------------------------------------------------
library(ggplot2)

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotTraceUQPriorTC216.pdf"

# Input filename
rds_tidy_fullname <- "../../../wd41-thesis/figures/data-support/postpro/srs/febaTrans216-febaVars12Influential-srs_1000_12-tc-tidy.Rds"

# Graphic variables
fig_size <- c(18, 9)
alpha <- 0.75
plot_title <- parse(
  text = "'FEBA Test No. 216, '*P[sys]*' = 4.1 [bar], Flooding Rate = 3.8 ['*m.s^-1*']'")

# Source the plotting script --------------------------------------------------
source("r-scripts/plotTraceUQPriorTC.R")