#
# title     : calcQoIPostCO.R
# purpose   : R script to compute various quantities of interest for comparing
#           : different posterior prediction w.r.t CO output.
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
trc_exp_df <- readRDS(opt$posterior)[[2]]

posterior_filename <- strsplit(opt$posterior, "/")[[1]]
posterior_filename <- posterior_filename[length(posterior_filename)]
feba_test <- gsub("\\D", "", strsplit(posterior_filename, "-")[[1]][1])
case_name <- strsplit(strsplit(posterior_filename, "-")[[1]][3], "_")[[1]][1]

# Compute QoIs ----------------------------------------------------------------
lte_10_idx <- which(trc_exp_df$exp_data<10)
lte_10 <- c(lte_10_idx,
            lte_10_idx[length(lte_10_idx)]+1)
t_exp_idx <- (unique(trc_exp_df[lte_10,]$time)[-1] * 10)

inf_scores <- numeric(length(t_exp_idx))
cal_scores <- numeric(length(t_exp_idx))

for (i in 1:length(t_exp_idx))
{
  # Loop over time points
  inf_scores[i] <- inf_score(lb_ref = trc_prior_df[t_exp_idx[i],]$lb_run,
                             ub_ref = trc_prior_df[t_exp_idx[i],]$ub_run,
                             lb_val = trc_post_df[t_exp_idx[i],]$lb_run,
                             ub_val = trc_post_df[t_exp_idx[i],]$ub_run)
  cal_scores[i] <- cal_score(exp_val = trc_exp_df[-1,]$exp_data[i],
                             ref_val = trc_post_df[t_exp_idx[i],]$mid_run,
                             lb_val = trc_post_df[t_exp_idx[i],]$lb_run,
                             ub_val = trc_post_df[t_exp_idx[i],]$ub_run)
}

inf_scores[inf_scores < 0] <- 0 # Force negative informativeness to zero

qoi_post <- data.frame(feba_test = feba_test,
                       case_name = case_name,
                       output_type = "CO",
                       inf_score = mean(inf_scores),
                       cal_score = mean(cal_scores),
                       rmse = sqrt(mean(trc_exp_df[lte_10,]$mse)))

# Save the file ---------------------------------------------------------------
saveRDS(qoi_post, opt$output)
