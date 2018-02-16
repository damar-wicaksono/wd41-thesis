#
# title     : plotIllustrateCornerPlot.R
# purpose   : R script to my own version of corner plot for the posterior
#           : samples of model calibration using:
#           :   - All output types
#           :   - Model discrepancy, variance
#           :   - Model discrepancy, mean (centered)
# author    : WD41, LRS/EPFL/PSI
# date      : Jan. 2017
#
# Load required libraries -----------------------------------------------------
library(viridis)
library(hexbin)

source("./r-scripts/multiplot.R")
source("./r-scripts/plot_ensemble_illustrate.R")

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotIllustrateCornerPlot.png"

# Input filename
ens_rds_fullname <- "../../../../wd41-thesis.analysis.new/trace-mcmc-fixvar-revise-reduced/results/2000/216-ens-all-1000-2000-fix_bc-fix_scale-unbiased-nobc-rep1.Rds"
#ens_rds_fullname <- "F:\\wd41-thesis\\trace-mcmc\\trace-mcmc-fixvar-revise-reduced\\results\\2000\\216-ens-all-1000-2000-fix_bc-fix_scale-unbiased-nobc-rep1.Rds"

# Burnin for this case (always change accordingly)
burnin <- 760

# Graphic variables
fig_size <- c(7.5, 4.9)

param_names <- c("",
                 "",
                 "",
                 "",
                 "",
                 "",
                 "",
                 "")

prior_ranges <- list(c(0.5, 2.0),
                     c(0.5, 2.0),
                     c(0.5, 2.0),
                     c(0.25, 4.0),
                     c(0.25, 4.0),
                     c(0.25, 4.0),
                     c(0.5, 2.0),
                     c(-50, 50))

nom_params <- c(1, 1, 1, 1,
                1, 1, 1, 0)

# Make the plot ---------------------------------------------------------------
png(otpfullname,
    width = fig_size[1], height = fig_size[2], units = "in", res = 300)

p <- plot_ensemble_illustrate(ens_rds_fullname,
                              burnin = burnin,
                              param_names = param_names,
                              param_ranges = prior_ranges,
                              n_bins = 30)
dev.off()
