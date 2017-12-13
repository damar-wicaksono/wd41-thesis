#
# title     : plotEnsStatMCMC.R
# purpose   : R script to create a trace plot of an ensemble sampler
#           : samples of model calibration using:
#           :   - All output types
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
otpfullname <- "./figures/plotEnsStatMCMC.pdf"

# Input filename
ens_rds_fullname <- "../../../../wd41-thesis.analysis.new/trace-mcmc-fixvar-revise-reduced/results/2000/216-ens-all-1000-2000-fix_bc-fix_scale-unbiased-nobc-rep1.Rds"
ens_rds_fullname <- "F:\\wd41-thesis\\trace-mcmc\\trace-mcmc-fixvar-revise-reduced\\results\\2000\\216-ens-all-1000-2000-fix_bc-fix_scale-unbiased-nobc-rep1.Rds"

# Burnin for this case (always change accordingly)
burnin <- 760

# Graphic variables
fig_size <- c(10, 5)

# Read tidy data ------------------------------------------------------------
ens_samples <- readRDS(ens_rds_fullname)

# Compute the Statistics of the Ensemble per iteration ------------------------
n_iter <- dim(ens_samples)[3]
n_walker <- dim(ens_samples)[2]
n_params <- dim(ens_samples)[1]
ens_samples_stat <- array(0, dim = c(7, n_iter, 8))

for (j in 1:8)
{
  for (i in 1:n_iter)
  {
    ens_samples_stat[1,i,j] <- mean(ens_samples[j,,i])
    ens_samples_stat[2,i,j] <- sd(ens_samples[j,,i])
    ens_samples_stat[3,i,j] <- quantile(ens_samples[j,,i], probs = c(0.025))
    ens_samples_stat[4,i,j] <- quantile(ens_samples[j,,i], probs = c(0.5))
    ens_samples_stat[5,i,j] <- quantile(ens_samples[j,,i], probs = c(0.975))
    ens_samples_stat[6,i,j] <- HPDI(ens_samples[j,,i])[1]
    ens_samples_stat[7,i,j] <- HPDI(ens_samples[j,,i])[2]
  }
}

# Create tidy data ------------------------------------------------------------
ens_samples_stat_tidy <- data.frame(stat = c(),
                                    iter = c(),
                                    param = c(),
                                    value = c())
for (i in 1:n_params)
{
  ens_samples_stat_tidy <- rbind(ens_samples_stat_tidy,
                                 data.frame(stat = "Average",
                                            iter = seq(1,n_iter),
                                            param = rep(param_names[i], n_iter),
                                            value = ens_samples_stat[1,,i]))
  ens_samples_stat_tidy <- rbind(ens_samples_stat_tidy,
                                 data.frame(stat = "Standard Deviation",
                                            iter = seq(1,n_iter),
                                            param = rep(param_names[i], n_iter),
                                            value = ens_samples_stat[2,,i]))
}

# Create dummy for the plot limit ---------------------------------------------
# Because by facetting, we cannot access each axis individually
ddummy <- data.frame(stat = c(), iter = c(), param = c(), value = c())
for (i in 1:8)
{
  ddummy <- rbind(ddummy, data.frame(stat = rep("Average", 2),
                                     iter = seq(1, 2),
                                     param = rep(param_names[i], 2),
                                     value = c(0.25, 0.75)))
  ddummy <- rbind(ddummy, data.frame(stat = rep("Standard Deviation", 2),
                                     iter = seq(1, 2),
                                     param = rep(param_names[i], 2),
                                     value = c(0.0, 0.30)))
}

# Make the  plot --------------------------------------------------------------
p <- ggplot(data = ens_samples_stat_tidy,
            aes(x = iter, y = value, group = param))
p <- p + geom_line()
p <- p + geom_blank(data = ddummy, aes(x = iter, y = value))
p <- p + theme_bw()
p <- p + facet_wrap(~stat, scales = "free_y", ncol = 4)
p <- p + geom_vline(xintercept = burnin, linetype = 1)

# Set axis labels and font size
p <- p + labs(y = "Normalized Value",
              x = "Number of Iterations")
p <- p + theme(strip.text.x = element_text(size = 16, face = "bold"))
p <- p + theme(axis.ticks.y = element_line(size = 1),
               axis.ticks.x = element_line(size = 1),
               axis.text.x = element_text(size = 16, angle = 30, hjust = 1),
               axis.text.y = element_text(size = 18))
p <- p + theme(axis.title.y = element_text(vjust = 1.5, size = 20),
               axis.title.x = element_text(vjust = -0.5, size = 24))

# Make the plot ---------------------------------------------------------------
pdf(otpfullname, family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
print(p)
dev.off()
embed_fonts(otpfullname, outfile=otpfullname)
