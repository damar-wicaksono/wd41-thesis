#
# title     : plotEnsTracePlot.R
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
otpfullname <- "./figures/plotEnsTracePlotAllDiscCentered.pdf"

# Input filename
ens_rds_fullname <- "../../../../wd41-thesis.analysis.new/trace-mcmc-fixvar-revise-reduced/results/2000/216-ens-all-1000-2000-fix_bc-fix_scale-unbiased-nobc-rep1.Rds"

# Burnin for this case (always change accordingly)
burnin <- 760

# Graphic variables
fig_size <- c(18, 9)

# Create tidy data ------------------------------------------------------------
ens_samples <- readRDS(ens_rds_fullname)
# Rescale model parameters and save to a file
ens_samples_rescaled <- ens_samples
# x5 : Grid HT Enhancement [0.5, 2.0] logunif
k <- 1
ens_samples_rescaled[k,,] <- 4^ens_samples_rescaled[k,,] * 0.5
# x6 : iafbWallHTC [0.5, 2.0] logunif
k <- 2
ens_samples_rescaled[k,,] <- 4^ens_samples_rescaled[k,,] * 0.5
# x7 : dffbWallHTC [0.5, 2.0] logunif
k <- 3
ens_samples_rescaled[k,,] <- 4^ens_samples_rescaled[k,,] * 0.5
# x8 : dffbVIHTC [0.25, 4.0] logunif
k <- 4
ens_samples_rescaled[k,,] <- 16^ens_samples_rescaled[k,,] * 0.25
# x9 : iafbIntDrag [0.25, 4.0] logunif
k <- 5
ens_samples_rescaled[k,,] <- 16^ens_samples_rescaled[k,,] * 0.25
# x10: dffbIntDrag [0.25, 4.0] logunif
k <- 6
ens_samples_rescaled[k,,] <- 16^ens_samples_rescaled[k,,] * 0.25
# x11: dffbWallDrag [0.5, 2.0] logunif
k <- 7
ens_samples_rescaled[k,,] <- 4^ens_samples_rescaled[k,,] * 0.5
# x12: Tminfb [-50, 50] unif
k <- 8
ens_samples_rescaled[k,,] <- 100 * ens_samples_rescaled[k,,] - 50

ens_tidy <- data.frame(walker = c(), param = c(), iter = c(), value = c())

n_param <- dim(ens_samples)[1]
n_walker <- dim(ens_samples)[2]
n_iter <- dim(ens_samples)[3]

for (i in 1:1000)
{
  for (j in 1:8)
  {
    ens_tidy <- rbind(ens_tidy, data.frame(walker = rep(i, n_iter-burnin),
                                           param = rep(param_names[j], n_iter-burnin),
                                           iter = seq(1, n_iter-burnin),
                                           value = ens_samples_rescaled[j,i,(burnin+1):n_iter]))

  }
}

saveRDS(ens_tidy, "216-ens-all-1000-2000-fix_bc-fix_scale-unbiased-nobc-rep1-tidy_df.Rds")

# Create dummy for the plot limit ---------------------------------------------
ddummy <- data.frame(walker = c(), param = c(), iter = c(), value = c())
for (i in 1:8)
{
  ddummy <- rbind(ddummy, data.frame(walker = rep(1, 2),
                                     param = rep(param_names[i], 2),
                                     iter = seq(1, 2),
                                     value = prior_ranges[[i]]))
}

# Make the  plot --------------------------------------------------------------
p <- ggplot(data = ens_tidy, aes(x = iter, y = value, group = walker))
p <- p + geom_line(alpha = 1.0)
p <- p + geom_blank(data = ddummy, aes(x = iter, y = value))
p <- p + theme_bw()
p <- p + facet_wrap(~param, scales = "free_y", ncol = 4)

# Set axis labels and font size
p <- p + labs(y = "Parameter value",
              x = "Number of Iterations (after burn-in)")
p <- p + theme(strip.text.x = element_text(size = 16, face = "bold"))
p <- p + theme(axis.ticks.y = element_line(size = 1),
               axis.ticks.x = element_line(size = 1),
               axis.text.x = element_text(size = 16, angle = 30, hjust = 1),
               axis.text.y = element_text(size = 18))
p <- p + theme(axis.title.y = element_text(vjust = 1.5, size = 24),
               axis.title.x = element_text(vjust = -0.5, size = 24))
p

# Make the plot ---------------------------------------------------------------
pdf(otpfullname, family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
print(p)
dev.off()
embed_fonts(otpfullname, outfile=otpfullname)
