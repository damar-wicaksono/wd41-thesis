#
# title     : plotTraceUQPosteriorDP216.R
# purpose   : R script to create plot of UQ propagation using posterior samples
#           : for DP output
#           : FEBA Test No. 216
# author    : WD41, LRS/EPFL/PSI
# date      : Nov. 2017
#
# Load required libraries -----------------------------------------------------
library(ggplot2)

# Global variables ------------------------------------------------------------

# FEBA Test No
feba_test <- 216

# Input filename, prior samples
rds_tidy_prior_fullname <- paste0(
  "../data-support/postpro/srs/febaTrans",
  feba_test,
  "-febaVars12Influential-srs_1000_12-dp-tidy.Rds")

# Graphic variables
fig_size <- c(14, 4)

# Make the plot ---------------------------------------------------------------
# w/ Bias
# Output filename
otpfullname <- paste0("./figures/plotTraceUQPosteriorAllDiscCenteredDP",
                      feba_test, ".pdf")
# Input filenames, posterior samples, correlated and independent
rds_tidy_corr_fullname <- paste0(
  "../data-support/postpro/disc/centered/all-params/correlated/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllDiscCentered_1000_12-dp-tidy.RDs")
rds_tidy_ind_fullname <- paste0(
  "../data-support/postpro/disc/centered/all-params/independent/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllDiscCenteredInd_1000_12-dp-tidy.RDs")
# Make the plot
source("./r-scripts/plotTraceUQPosteriorDP.R")

# w/o Bias
# Output filename
otpfullname <- paste0("./figures/plotTraceUQPosteriorAllNoDiscNoBCDP",
                      feba_test, ".pdf")
# Input filenames, posterior samples, correlated and independent
rds_tidy_corr_fullname <- paste0(
  "../data-support/postpro/nodisc/not-centered/fix-bc/correlated/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllNoDiscNoBC_1000_12-dp-tidy.RDs")
rds_tidy_ind_fullname <- paste0(
  "../data-support/postpro/nodisc/not-centered/fix-bc/independent/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllNoDiscNoBCInd_1000_12-dp-tidy.RDs")
# Make the plot
source("./r-scripts/plotTraceUQPosteriorDP.R")
