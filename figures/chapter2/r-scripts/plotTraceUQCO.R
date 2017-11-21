#
# title     : plotTraceUQPriorCO.R
# purpose   : R script to create a single uncertainty propagation campaign
#           : Plotting the 95% uncertainty bound.
#           : Liquid carryover output
# author    : WD41, LRS/EPFL/PSI
# date      : Nov. 2017
#
# Read data -------------------------------------------------------------------
trc_uq_df <- readRDS(rds_tidy_fullname)[[1]]
trc_exp_df <- readRDS(rds_tidy_fullname)[[2]]

# Make the plot ---------------------------------------------------------------
p <- ggplot(data = trc_uq_df, aes(x = time, y = mid_run))
p <- p + geom_ribbon(aes(x = time, ymin = lb_run, ymax = ub_run),
                     fill = "gray", alpha = alpha)
p <- p + geom_line()
p <- p + geom_point(data = trc_exp_df, aes(x = time, y = exp_data),
                    shape = 4, stroke = 1.1)

# Set axis labels and font size
p <- p + theme_bw()
p <- p + scale_x_continuous(limits = x_lims)
p <- p + scale_y_continuous(limits = y_lims)
p <- p + labs(x = "Time [s]",
              y = "Liquid Carryover [kg]")
p <- p + theme(strip.text.x = element_text(size = 16, face = "bold"))
p <- p + theme(axis.ticks.y = element_line(size = 1),
               axis.ticks.x = element_line(size = 1),
               axis.text.x = element_text(size = 14, angle = 30, hjust = 1),
               axis.text.y = element_text(size = 14))
p <- p + theme(axis.title.y = element_text(vjust = 1.5, size = 18),
               axis.title.x = element_text(vjust = -0.5, size = 18))

# Save the plot ---------------------------------------------------------------
pdf(otpfullname, family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
print(p)
dev.off()
