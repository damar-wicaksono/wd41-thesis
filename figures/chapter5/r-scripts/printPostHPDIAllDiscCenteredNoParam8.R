#
# title     : printPostHPDIAllDiscCenteredNoParam8.R
# purpose   : R script to my own version of corner plot for the posterior
#           : samples of model calibration using:
#           :   - All output types
#           :   - No model discrepancy, variance
#           :   - No model discrepancy, mean (centered)
#           :   - Excluding Parameter 8 (dffbVIHTC)
# author    : WD41, LRS/EPFL/PSI
# date      : Nov. 2017
#
ens_rds_fullname <- "../../../../wd41-thesis.analysis.new/trace-mcmc-fixvar-revise-reduced/results/2000/216-ens-all-1000-2000-fix_bc-fix_scale-unbiased-nobc-noparam8.Rds"

# Burnin for this case (always change accordingly)
burnin <- 850

ens_samples <- readRDS(ens_rds_fullname)

ens_samples <- ens_samples[,,(burnin+1):2000]

ens_samples_burned <- t(ens_samples[,1,1:dim(ens_samples)[3]])

for (i in 2:dim(ens_samples)[2])
{
  ens_samples_burned <- rbind(ens_samples_burned,
                              t(ens_samples[,i,1:dim(ens_samples)[3]]))
}

# Rescale model parameters and save to a file
ens_samples_rescaled <- ens_samples_burned
# x5 : Grid HT Enhancement [0.5, 2.0] logunif
k <- 1
ens_samples_rescaled[, k] <- 4^ens_samples_rescaled[,k] * 0.5
# x6 : iafbWallHTC [0.5, 2.0] logunif
k <- 2
ens_samples_rescaled[, k] <- 4^ens_samples_rescaled[,k] * 0.5
# x7 : dffbWallHTC [0.5, 2.0] logunif
k <- 3
ens_samples_rescaled[, k] <- 4^ens_samples_rescaled[,k] * 0.5
# x9 : iafbIntDrag [0.25, 4.0] logunif
k <- 4
ens_samples_rescaled[, k] <- 16^ens_samples_rescaled[,k] * 0.25
# x10: dffbIntDrag [0.25, 4.0] logunif
k <- 5
ens_samples_rescaled[, k] <- 16^ens_samples_rescaled[,k] * 0.25
# x11: dffbWallDrag [0.5, 2.0] logunif
k <- 6
ens_samples_rescaled[, k] <- 4^ens_samples_rescaled[,k] * 0.5
# x12: Tminfb [-50, 50] unif
k <- 7
ens_samples_rescaled[, k] <- 100 * ens_samples_rescaled[,k] - 50

ens_hpdi <- apply(ens_samples_rescaled, 2, HPDI, prob = 0.95)
ens_med <- apply(ens_samples_rescaled, 2, median)

for (i in 1:7)
{
  x <- sprintf("[%.1f,%.1f,%.1f]", ens_hpdi[1,i], ens_med[i], ens_hpdi[2,i])
  print(x)
}