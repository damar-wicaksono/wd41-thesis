#
# title     : plotEnsTraceAllDiscCentered.R
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
ens_tidy_fullname <- "216-ens-all-1000-2000-fix_bc-fix_scale-unbiased-nobc-rep1-tidy_df.Rds"

# Burnin for this case (always change accordingly)
n_walker <- 1000

# Graphic variables
set.seed(345230)
fig_size <- c(18, 9)

# Read tidy data ------------------------------------------------------------

ens_tidy <- readRDS(ens_tidy_fullname)

# Create dummy for the plot limit ---------------------------------------------
ddummy <- data.frame(walker = c(), param = c(), iter = c(), value = c())
for (i in 1:8)
{
  ddummy <- rbind(ddummy, data.frame(walker = rep(1, 2),
                                     param = rep(param_names[i], 2),
                                     iter = seq(1, 2),
                                     value = prior_ranges[[i]]))
}

# 1000 curves is a bit too large for plotting, so we just do some selections
subset_walker <- sample(1:n_walker, size = 125, replace = F)
subset_ens_tidy <- subset(ens_tidy, walker == 1)
for (i in 2:length(subset_walker))
{
  subset_ens_tidy <- rbind(subset_ens_tidy,
                           subset(ens_tidy, walker == subset_walker[i]))
}

# Make the  plot --------------------------------------------------------------
p <- ggplot(data = subset_ens_tidy,
            aes(x = iter, y = value, group = walker))
p <- p + geom_line(alpha = 0.2)
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

# Make the plot ---------------------------------------------------------------
pdf(otpfullname, family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
print(p)
dev.off()
# Embedding font makes the alpha behave strangely
# embed_fonts(otpfullname, outfile=otpfullname)
