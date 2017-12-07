#
# title     : plotTraceUQPriorTC218.R
# purpose   : R script to plot the 95% uncertainty band of the prior
#           : uncertainty predictions of the cladding temperature (TC)
#           : FEBA Test No. 218
# author    : WD41, LRS/EPFL/PSI
# date      : Nov. 2017
#
# Load required libraries -----------------------------------------------------
library(ggplot2)

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotTraceUQPriorTC218.pdf"

# Input filename
rds_tidy_fullname <- "../../../wd41-thesis/figures/data-support/postpro/srs/febaTrans218-febaVars12Influential-srs_1000_12-tc-tidy.Rds"

# Graphic variables
fig_size <- c(18, 9)
alpha <- 0.75
plot_title <- parse(
  text = "'FEBA Test No. 218, '*P[sys]*' = 2.1 [bar], Flooding Rate = 5.8 ['*m.s^-1*']'")

# Read data -------------------------------------------------------------------
trc_uq_df <- readRDS(rds_tidy_fullname)[[1]]
trc_exp_df <- readRDS(rds_tidy_fullname)[[2]]

# Do some cleanup -------------------------------------------------------------
# Test 218 contains error in the first point of TC4
trc_exp_df <- trc_exp_df[-117,]

# Source the plotting script --------------------------------------------------
source("r-scripts/plotTraceUQPriorTC.R")