#
# title     : plotEnsAllNoDiscNoBC.R
# purpose   : R script to my own version of corner plot for the posterior
#           : samples of model calibration using:
#           :   - All output types
#           :   - No model discrepancy, variance
#           :   - No model discrepancy, mean (centered)
# author    : WD41, LRS/EPFL/PSI
# date      : Nov. 2017
#
# Load required libraries -----------------------------------------------------
library(viridis)
library(hexbin)

source("./r-scripts/multiplot.R")
source("./r-scripts/plot_ensemble.R")

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotEnsAllNoDiscNoBC.png"

# Input filename
ens_rds_fullname <- "../../../../wd41-thesis.analysis.new/trace-mcmc-nodisc-revise-reduced/results/2000/216-ens-all-1000-2000-fix_bc-nodisc.Rds"
#ens_rds_fullname <- "F:\\wd41-thesis\\trace-mcmc\\trace-mcmc-nodisc-revise-reduced\\results\\2000\\216-ens-all-1000-2000-fix_bc-nodisc.Rds"

# Burnin for this case (always change accordingly)
burnin <-1390

# Graphic variables
fig_size <- c(8.8, 5.1)

param_names <- c("gridHT [-]",
                 "iafbWHT [-]",
                 "dffbWHT [-]",
                 "dffbVIHT [-]",
                 "iafbIntDr [-]",
                 "dffbIntDr [-]",
                 "dffbWDr [-]",
                 "tQuench [K]")

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

p <- plot_ensemble(ens_rds_fullname,
                   burnin = burnin,
                   param_names = param_names,
                   param_ranges = prior_ranges,
                   n_bins = 30)
dev.off()
