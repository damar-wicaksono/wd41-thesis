#
# title     : plotTraceUQPosterioTC216.R
# purpose   : R script to create plot of UQ propagation using posterior samples
#           : for TC output
#           : FEBA Test No. 216
# author    : WD41, LRS/EPFL/PSI
# date      : Jan. 2018
#
# Load required libraries -----------------------------------------------------
library(ggplot2)

# Global variables ------------------------------------------------------------

# FEBA Test No
feba_test <- 216

# Input filename
rds_tidy_prior_fullname <- paste0(
    "../../../wd41-thesis/figures/data-support/postpro/srs/febaTrans",
    feba_test,
    "-febaVars12Influential-srs_1000_12-tc-tidy.Rds")

# Graphic variables
fig_size <- c(9.75, 4.0)

# Make the plot ---------------------------------------------------------------
# w/ Bias
# Output filename
otpfullname <- paste0("./figures/plotTraceUQPosteriorAllDiscCenteredTC",
                      feba_test, ".png")
# Input filenames, posterior samples, correlated and independent
rds_tidy_corr_fullname <- paste0(
    "../../../wd41-thesis/figures/data-support/postpro/disc/centered/all-params/correlated/febaTrans",
    feba_test,
    "-febaVars12Influential-mcmcAllDiscCentered_1000_12-tc-tidy.RDs")
rds_tidy_ind_fullname <- paste0(
    "../../../wd41-thesis/figures/data-support/postpro/disc/centered/all-params/independent/febaTrans",
    feba_test,
    "-febaVars12Influential-mcmcAllDiscCenteredInd_1000_12-tc-tidy.RDs")
# Make the plot
source("./r-scripts/plotTraceUQPosteriorTC.R")

# w/o Bias
# Output filename
otpfullname <- paste0("./figures/plotTraceUQPosteriorAllNoDiscNoBCTC",
                      feba_test, ".png")
# Input filenames, posterior samples, correlated and independent
rds_tidy_corr_fullname <- paste0(
    "../../../wd41-thesis/figures/data-support/postpro/nodisc/not-centered/fix-bc/correlated/febaTrans",
    feba_test,
    "-febaVars12Influential-mcmcAllNoDiscNoBC_1000_12-tc-tidy.RDs")
rds_tidy_ind_fullname <- paste0(
    "../../../wd41-thesis/figures/data-support/postpro/nodisc/not-centered/fix-bc/independent/febaTrans",
    feba_test,
    "-febaVars12Influential-mcmcAllNoDiscNoBCInd_1000_12-tc-tidy.RDs")
# Make the plot
source("./r-scripts/plotTraceUQPosteriorTC.R")

# w/o Parameter 8 (dffbVIHTC)
# Output filename
otpfullname <- paste0(
    "./figures/plotTraceUQPosteriorAllDiscCenteredNoParam8TC",
    feba_test, ".png")
# Input filenames, posterior samples, correlated and independent
rds_tidy_corr_fullname <- paste0(
    "../../../wd41-thesis/figures/data-support/postpro/disc/centered/no-param8/correlated/febaTrans",
    feba_test,
    "-febaVars12Influential-mcmcAllDiscCenteredNoParam8_1000_12-tc-tidy.RDs")
rds_tidy_ind_fullname <- paste0(
    "../../../wd41-thesis/figures/data-support/postpro/disc/centered/no-param8/independent/febaTrans",
    feba_test,
    "-febaVars12Influential-mcmcAllDiscCenteredNoParam8Ind_1000_12-tc-tidy.RDs")
# Make the plot
source("./r-scripts/plotTraceUQPosteriorTC.R")
