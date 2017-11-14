#
# title     : plotEnsDPDiscCentered.R
# purpose   : R script to my own version of corner plot for the posterior
#           : samples of model calibration using:
#           :   - DP output type
#           :   - Model discrepancy, variance
#           :   - Model discrepancy, mean (centered)
# author    : WD41, LRS/EPFL/PSI
# date      : Nov. 2017
#
# Load required libraries -----------------------------------------------------
source("./r-scripts/multiplot.R")
source("./r-scripts/plot_ensemble.R")

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotEnsDPDiscCentered.pdf"

# Input filename
ens_rds_fullname <- "../../../../wd41-thesis.analysis.new/trace-mcmc-fixvar-revise-reduced/results/2000/216-ens-dp-1000-2000-fix_bc-fix_scale-unbiased-nobc.Rds"

# Burnin for this case (always change accordingly)
burnin <- 970

# Graphic variables
fig_size <- c(17, 11)

# Make the plot ---------------------------------------------------------------
pdf(otpfullname, family = "CM Roman",
    width = fig_size[1], height = fig_size[2])

plot_ensemble(ens_rds_fullname,
              burnin = burnin,
              param_names = param_names,
              param_ranges = prior_ranges,
              n_bins = 30)
dev.off()
embed_fonts(otpfullname, outfile = otpfullname)
