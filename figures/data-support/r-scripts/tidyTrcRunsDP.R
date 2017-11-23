#
# title     : tidyTrcRunsDP.R
# purpose   : R script to tidy up data from TRACE UQ runs, computing the
#           : (by default) 95% probability interval point by point basis.
# author    : WD41, LRS/EPFL/PSI
# date      : Nov. 2017
#
# Load required libraries -----------------------------------------------------
library("optparse")

option_list <- list(
  make_option(c("-i", "--input"), type = "character", default = NULL,
              help = "RDS file with compiled results of TRACE runs"),
  make_option(c("-m", "--input_map"), type = "character", default = NULL,
              help = "RDS file with compiled results of TRACE runs using MAP Estimates"),
  make_option(c("-e", "--exp"), type = "character", default = NULL,
              help = "RDS file with experimental data"),
  make_option(c("-o", "--output"), type = "character", default = NULL,
              help = "RDS output file of tidy data"),
  make_option(c("-p", "--percentile"), type = "integer", default = 95,
              help = "The percentile")
)

opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

# Global variables ------------------------------------------------------------
ax_locs_dp <- c("Bottom", "Middle", "Top", "Total")

# Read data -------------------------------------------------------------------
trc_runs <- readRDS(opt$input)
trc_map_run <- readRDS(opt$input_map)
exp_data <- readRDS(opt$exp)$exp_data[[2]]

n_t_trc <- length(trc_runs$time)
n_t_exp <- length(exp_data[,1])
lb_pct <- (100 - opt$percentile) / 2 / 100
ub_pct <- lb_pct + opt$percentile / 100
mid_idx <- 500

# Create tidy data, TC --------------------------------------------------------
#  Read Trace Runs
trc_uq_dp_df <- data.frame(time = c(),
                           mid_run = c(),
                           nom_run = c(),
                           map_run = c(),
                           ub_run = c(),
                           lb_run = c(),
                           ax_locs = c())

for (i in 1:length(ax_locs_dp))
{
  ub_run <- numeric(n_t_trc)    # Upper uncertainty bound
  lb_run <- numeric(n_t_trc)    # Lower uncertainty bound
  mid_run <- numeric(n_t_trc)   # Middle Run
  nom_run <- numeric(n_t_trc)   # Nominal Run
  map_run <- numeric(n_t_trc)   # MAP Run

  for (t_idx in 1:n_t_trc)
  {
    lb_run[t_idx] <- quantile(trc_runs$replicates[t_idx,,i], probs = c(lb_pct))
    ub_run[t_idx] <- quantile(trc_runs$replicates[t_idx,,i], probs = c(ub_pct))
    mid_run[t_idx] <- sort(trc_runs$replicates[t_idx,,i])[mid_idx]
    nom_run[t_idx] <- trc_runs$nominal[t_idx,i]
    map_run[t_idx] <- trc_map_run$replicates[t_idx,1,i]
  }

  trc_uq_dp_df <- rbind(trc_uq_dp_df, data.frame(time = trc_runs$time,
                                                 mid_run = mid_run,
                                                 nom_run = nom_run,
                                                 map_run = map_run,
                                                 ub_run = ub_run,
                                                 lb_run = lb_run,
                                                 ax_locs = rep(ax_locs_dp[i],
                                                               n_t_trc)))
}

# Read experimental data
trc_exp_df <- data.frame(time = c(), exp_data = c(), ax_locs = c())
for (i in 1:length(ax_locs_dp))
{
  trc_exp_df <- rbind(trc_exp_df,
                      data.frame(time = exp_data[,1],
                                 exp_data = exp_data[,i+1] * 1e5,
                                 ax_locs = rep(ax_locs_dp[i], n_t_exp)))
}

# Save file ------------------
tidy_list <- list(trc = trc_uq_dp_df, exp = trc_exp_df)
saveRDS(tidy_list, opt$output)
