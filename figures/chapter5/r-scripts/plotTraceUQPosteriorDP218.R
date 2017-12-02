#
# title     : plotTraceUQPosteriorDP218.R
# purpose   : R script to create plot of UQ propagation using posterior samples
#           : for DP output
#           : FEBA Test No. 218
# author    : WD41, LRS/EPFL/PSI
# date      : Nov. 2017
#
# Load required libraries -----------------------------------------------------
library(ggplot2)
library(plyr)

# Global variables ------------------------------------------------------------

# FEBA Test No
feba_test <- 218

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
# Add plot title
plot_title <- parse(
  text = "'FEBA Test No. 218, '*P[sys]*' = 2.1 [bar], Flooding Rate = 5.8 ['*m.s^-1*'], Calibration scheme w/ Bias, All'")
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
plot_title <- parse(
  text = "'FEBA Test No. 218, '*P[sys]*' = 2.1 [bar], Flooding Rate = 5.8 ['*m.s^-1*'], Calibration scheme w/o Bias'")
# Make the plot
source("./r-scripts/plotTraceUQPosteriorDP.R")

# w/o Parameter 8 (dffbVIHTC)
# Output filename
otpfullname <- paste0(
  "./figures/plotTraceUQPosteriorAllDiscCenteredNoParam8DP",
  feba_test, ".pdf")
# Input filenames, posterior samples, correlated and independent
rds_tidy_corr_fullname <- paste0(
  "../data-support/postpro/disc/centered/no-param8/correlated/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllDiscCenteredNoParam8_1000_12-dp-tidy.RDs")
rds_tidy_ind_fullname <- paste0(
  "../data-support/postpro/disc/centered/no-param8/independent/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllDiscCenteredNoParam8Ind_1000_12-dp-tidy.RDs")
# Add plot title
plot_title <- parse(
  text = "'FEBA Test No. 218, '*P[sys]*' = 2.1 [bar], Flooding Rate = 5.8 ['*m.s^-1*'], Calibration scheme w/ Bias, no dffbVIHT'")
# Make the plot
source("./r-scripts/plotTraceUQPosteriorDP.R")
