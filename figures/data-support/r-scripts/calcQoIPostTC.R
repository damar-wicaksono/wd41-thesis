#
# title     : calcQoIPostTC.R
# purpose   : R script to compute various quantities of interest for comparing
#           : different posterior prediction w.r.t TC output.
#           :   - RMSE (betweeen middle run and experimental data)
#           :   - Informativeness
#           :   - Calibration Score
#           : The script automatically returns tidy RDS
# usage     : Rscript calcQoiPostTC.R -b <base_runs/prior RDS> \
#           :                         -p <posterior runs RDS> \
#           :                         -o <output RDS>
# author    : WD41, LRS/EPFL/PSI
# date      : Nov. 2017
#
# Custom function -------------------------------------------------------------
library("optparse")

option_list <- list(
  make_option(c("-b", "--prior"), type = "character", default = NULL,
              help = "RDS file with compiled results of prior TRACE runs"),
  make_option(c("-p", "--posterior"), type = "character", default = NULL,
              help = "RDS file with compiled results of posterior TRACE runs"),
  make_option(c("-o", "--output"), type = "character", default = NULL,
              help = "RDS output file of tidy data")
)

opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

source("./r-scripts/cal_score.R")
source("./r-scripts/inf_score.R")

# Read data -------------------------------------------------------------------
trc_prior_df <- readRDS(opt$prior)[[1]]
trc_post_df <- readRDS(opt$posterior)[[1]]
trc_exp_df <- readRDS(opt$prior)[[2]]

prior_filename <- strsplit(opt$posterior, "/")[[1]]
prior_filename <- prior_filename[length(prior_filename)]
feba_test <- gsub("\\D", "", strsplit(prior_filename, "-")[[1]][1])
case_name <- strsplit(strsplit(prior_filename, "-")[[1]][3], "_")[[1]][1]

# Compute QoIs ----------------------------------------------------------------

ax_locs <- unique(trc_prior_df$ax_locs)
t_exp_idx <- (unique(trc_exp_df$time)[-1] * 10)

inf_scores <- numeric(length(ax_locs)*length(t_exp_idx))
cal_scores_prior <- numeric(length(ax_locs)*length(t_exp_idx))
cal_scores <- numeric(length(ax_locs)*length(t_exp_idx))
rmse <- numeric(length(ax_locs)*length(t_exp_idx))

ax_loc <- ax_locs[8]
k <- 1
for (ax_loc in ax_locs)
{
  # Loop over axial location
  trc_prior_ax <- subset(trc_prior_df, ax_locs == ax_loc)[-1,]
  trc_post_ax <- subset(trc_post_df, ax_locs == ax_loc)[-1,]
  trc_exp_ax <- subset(trc_exp_df, ax_locs == ax_loc)[-1,]
  for (i in 1:length(t_exp_idx))
  {
    # Loop over time points
    inf_scores[k] <- inf_score(lb_ref = trc_prior_ax[t_exp_idx[i],]$lb_run,
                               ub_ref = trc_prior_ax[t_exp_idx[i],]$ub_run,
                               lb_val = trc_post_ax[t_exp_idx[i],]$lb_run,
                               ub_val = trc_post_ax[t_exp_idx[i],]$ub_run)
    cal_scores[k] <- cal_score(exp_val = trc_exp_ax$exp_data[i],
                               ref_val = trc_post_ax[t_exp_idx[i],]$mid_run,
                               lb_val = trc_post_ax[t_exp_idx[i],]$lb_run,
                               ub_val = trc_post_ax[t_exp_idx[i],]$ub_run)
    rmse[k] <- (trc_exp_ax$exp_data[i] - trc_post_ax[t_exp_idx[i],]$mid_run)^2
    k <- k + 1
  }
}

qoi_post <- data.frame(feba_test = feba_test,
                       case_name = case_name,
                       output_type = "TC",
                       inf_score = mean(inf_scores),
                       cal_score = mean(cal_scores),
                       rmse = sqrt(mean(rmse)))

# Save the file ---------------------------------------------------------------
saveRDS(qoi_post, opt$output)
