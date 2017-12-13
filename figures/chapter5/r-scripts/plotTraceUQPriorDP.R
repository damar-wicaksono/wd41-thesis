#
# title     : plotTraceUQPriorDP.R
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
otpfullname <- "./figures/plotTraceUQPriorDP.pdf"

# Input filename
rds_tidy_fullname <- "./data/febaTrans216-febaVars12Influential-srs_1000_12-tidy-dp.Rds"

# Graphic variables
fig_size <- c(9, 9)

# Read data -------------------------------------------------------------------
trc_uq_df <- readRDS(rds_tidy_fullname)[[1]]
trc_exp_df <- readRDS(rds_tidy_fullname)[[2]]

# Make the plot
p <- ggplot(data = trc_uq_df, aes(x = time, y = mid_run / 1e5))
p <- p + geom_line()
p <- p + geom_point(data = trc_exp_df, aes(x = time, y = exp_data / 1e5),
                    shape = 4, stroke = 1.0)
p <- p + facet_wrap(~ax_locs, ncol = 2)
p <- p + geom_ribbon(aes(x = time, ymin = lb_run / 1e5, ymax = ub_run / 1e5),
                     fill = "gray", alpha = 0.5)
p <- p + theme_bw()

# Set axis labels and font size
p <- p + labs(x = "Time [s]",
              y = "Pressure Drop [bar]")
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
