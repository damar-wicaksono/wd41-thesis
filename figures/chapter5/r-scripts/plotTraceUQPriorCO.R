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
otpfullname <- "./figures/plotTraceUQPriorCO.pdf"

# Input filename
rds_tidy_fullname <- "./data/febaTrans216-febaVars12Influential-srs_1000_12-tidy-co.Rds"

# Graphic variables
fig_size <- c(4, 4)
alpha <- 0.5
x_lims <- c(0, 250.)
y_lims <- c(0, 20.0)

# Read data -------------------------------------------------------------------
trc_uq_df <- readRDS(rds_tidy_fullname)[[1]]
trc_exp_df <- readRDS(rds_tidy_fullname)[[2]]

# Make the plot
p <- ggplot(data = trc_uq_df, aes(x = time, y = mid_run))
p <- p + geom_line()
p <- p + geom_point(data = trc_exp_df, aes(x = time, y = exp_data),
                    shape = 4, stroke = 1.1)
p <- p + geom_ribbon(aes(x = time, ymin = lb_run, ymax = ub_run),
                     fill = "gray", alpha = alpha)
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
