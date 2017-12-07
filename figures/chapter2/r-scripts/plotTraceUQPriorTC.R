#
# title     : plotTraceUQPriorTC.R
# purpose   : R script to plot the 95% uncertainty band of the prior
#           : Clad temperature (TC) predictions
# author    : WD41, LRS/EPFL/PSI
# date      : Dec. 2017
#
# Read the data ---------------------------------------------------------------
n_sub <- 5  # Sub sample points (each point would make the file too large)
trc_uq_df <- readRDS(rds_tidy_fullname)[[1]]
n_t <- dim(trc_uq_df)[1]
trc_uq_df <- readRDS(rds_tidy_fullname)[[1]][seq(1, n_t, n_sub),]
trc_exp_df <- readRDS(rds_tidy_fullname)[[2]]

# Make the plot ---------------------------------------------------------------
p <- ggplot(data = trc_uq_df, aes(x = time, y = nom_run))
p <- p + facet_wrap(~ax_locs, ncol = 4)
p <- p + geom_ribbon(aes(x = time, ymin = lb_run, ymax = ub_run),
                     fill = "#4D4D4D", alpha = alpha)
p <- p + geom_line()
p <- p + geom_point(data = trc_exp_df, aes(x = time, y = exp_data),
                    shape = 4, stroke = 1.0)

# Set axis labels and font size
p <- p + theme_bw()
p <- p + labs(x = "Time [s]",
              y = "Clad Temperature [K]")
p <- p + ggtitle(plot_title)
p <- p + theme(plot.title = element_text(size = 18, face = "bold"))
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
embed_fonts(otpfullname, outfile = otpfullname)
