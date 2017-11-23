#
# title     : plotTraceUQPosteriorAllDiscCenteredCO.R
# purpose   : R script to create a trace plot of an ensemble sampler
#           : samples of model calibration using:
#           :   - All output types
#           :   - Model discrepancy, variance
#           :   - Model discrepancy, mean (centered)
# author    : WD41, LRS/EPFL/PSI
# date      : Nov. 2017
#
# Load required libraries -----------------------------------------------------

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotTraceUQPosteriorAllDiscCenteredCO.pdf"

# Input filename
rds_tidy_prior_fullname <- "../data-support/postpro/srs/febaTrans216-febaVars12Influential-srs_1000_12-co-tidy.Rds"
rds_tidy_corr_fullname <- "../data-support/postpro/disc/centered/all-params/correlated/febaTrans216-febaVars12Influential-mcmcAllDiscCentered_1000_12-co-tidy.RDs"
rds_tidy_ind_fullname <- "../data-support/postpro/disc/centered/all-params/independent/febaTrans216-febaVars12Influential-mcmcAllDiscCenteredInd_1000_12-co-tidy.RDs"

# Graphic variables
fig_size <- c(4, 4)
x_lims <- c(0, 250.)
y_lims <- c(0, 20.0)

# Read data -------------------------------------------------------------------
trc_uq_prior_df <- readRDS(rds_tidy_prior_fullname)[[1]]
trc_uq_post_corr_df <- readRDS(rds_tidy_corr_fullname)[[1]]
trc_uq_post_ind_df <- readRDS(rds_tidy_ind_fullname)[[1]]
trc_exp_df <- readRDS(rds_tidy_prior_fullname)[[2]]

# Make the plot
p <- ggplot(data = trc_uq_prior_df, aes(x = time, y = nom_run))
p <- p + geom_ribbon(aes(x = time, ymin = lb_run, ymax = ub_run),
                     fill = "darkgray", alpha = 1.0)
p <- p + geom_ribbon(data = trc_uq_post_ind_df,
                     aes(x = time, ymin = lb_run, ymax = ub_run),
                     fill = "lightgray", alpha = 1.0)
p <- p + geom_ribbon(data = trc_uq_post_corr_df,
                     aes(x = time, ymin = lb_run, ymax = ub_run),
                     fill = "white", alpha = 1.0)
p <- p + geom_line()
p <- p + geom_point(data = trc_exp_df, aes(x = time, y = exp_data),
                    shape = 4, stroke = 1.1)
p <- p + scale_x_continuous(limits = x_lims)
p <- p + scale_y_continuous(limits = y_lims)

# Set axis labels and font size
p <- p + theme_bw()
p <- p + labs(x = "Time [s]",
              y = "Liquid Carryover [kg]")
p <- p + theme(strip.text.x = element_text(size = 16, face = "bold"))
p <- p + theme(axis.ticks.y = element_line(size = 1),
               axis.ticks.x = element_line(size = 1),
               axis.text.x = element_text(size = 14, angle = 30, hjust = 1),
               axis.text.y = element_text(size = 14))
p <- p + theme(axis.title.y = element_text(vjust = 1.5, size = 18),
               axis.title.x = element_text(vjust = -0.5, size = 18))

# Make the plot ---------------------------------------------------------------
pdf(otpfullname, family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
print(p)
dev.off()
embed_fonts(otpfullname, outfile = otpfullname)
