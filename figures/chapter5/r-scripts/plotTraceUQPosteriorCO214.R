#
# title     : plotTraceUQPosteriorCO214.R
# purpose   : R script to create plot of UQ propagation using posterior samples
#           : for CO output
#           : FEBA Test No. 214
# author    : WD41, LRS/EPFL/PSI
# date      : Nov. 2017
#
# Load required libraries -----------------------------------------------------
library(ggplot2)

# Global variables ------------------------------------------------------------

# FEBA Test No
feba_test <- 214

# Input filename, UQ from prior samples
rds_tidy_prior_fullname <- paste0(
  "../data-support/postpro/srs/febaTrans",
  feba_test,
  "-febaVars12Influential-srs_1000_12-co-tidy.Rds")

# Graphic variables
fig_size <- c(5, 5)
x_lims <- c(0, 250.)
y_lims <- c(0, 20.0)

# Make the plot ---------------------------------------------------------------
# w/ Bias
# Output filename
otpfullname <- paste0("./figures/plotTraceUQPosteriorAllDiscCenteredCO",
                      feba_test, ".pdf")
# Input filenames
rds_tidy_corr_fullname <- paste0(
  "../data-support/postpro/disc/centered/all-params/correlated/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllDiscCentered_1000_12-co-tidy.RDs")
rds_tidy_ind_fullname <- paste0(
  "../data-support/postpro/disc/centered/all-params/independent/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllDiscCenteredInd_1000_12-co-tidy.RDs")
# Make the plot
source("./r-scripts/plotTraceUQPosteriorCO.R")

# w/o Bias
# Output filename
otpfullname <- paste0("./figures/plotTraceUQPosteriorAllNoDiscNoBCCO",
                      feba_test, ".pdf")
# Input filenames
rds_tidy_corr_fullname <- paste0(
  "../data-support/postpro/nodisc/not-centered/fix-bc/correlated/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllNoDiscNoBC_1000_12-co-tidy.RDs")
rds_tidy_ind_fullname <- paste0(
  "../data-support/postpro/nodisc/not-centered/fix-bc/independent/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllNoDiscNoBCInd_1000_12-co-tidy.RDs")
# Make the plot
source("./r-scripts/plotTraceUQPosteriorCO.R")

# w/o Parameter 8 (dffbVIHTC)
# Output filename
otpfullname <- paste0(
  "./figures/plotTraceUQPosteriorAllDiscCenteredNoParam8CO",
  feba_test, ".pdf")
# Input filenames, posterior samples, correlated and independent
rds_tidy_corr_fullname <- paste0(
  "../data-support/postpro/disc/centered/no-param8/correlated/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllDiscCenteredNoParam8_1000_12-co-tidy.RDs")
rds_tidy_ind_fullname <- paste0(
  "../data-support/postpro/disc/centered/no-param8/independent/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllDiscCenteredNoParam8Ind_1000_12-co-tidy.RDs")
# Make the plot
source("./r-scripts/plotTraceUQPosteriorCO.R")

