#
# title     : plotTraceUQDPPrior.R
# purpose   : R script to plot the 95% uncertainty band of the prior
#           : uncertainty predictions of the pressure drop (DP)
# author    : WD41, LRS/EPFL/PSI
# date      : Nov. 2017
#
# Global variables ------------------------------------------------------------
bar_to_pa <- 1e5
n_sub <- 5  # Sub sample points (each point would make the file too large)

# Read data -------------------------------------------------------------------
trc_uq_df <- readRDS(rds_tidy_fullname)[[1]]
n_t <- dim(trc_uq_df)[1]
trc_uq_df <- readRDS(rds_tidy_fullname)[[1]][seq(1, n_t, n_sub),]
trc_exp_df <- readRDS(rds_tidy_fullname)[[2]]

# Revalue the axial segments
new_ax_locs <- c("Bottom" = "Bottom (z = 0.0 - 1.7 [m])",
                 "Middle" = "Middle (z = 1.7 - 2.3 [m])",
                 "Top" = "Top (z = 2.3 - 4.1 [m])",
                 "Total" = "Total (z = 0.0 - 4.1 [m])")
trc_uq_df$ax_locs <- revalue(trc_uq_df$ax_locs, new_ax_locs)
trc_exp_df$ax_locs <- revalue(trc_exp_df$ax_locs, new_ax_locs)

# Make the plot ---------------------------------------------------------------
p <- ggplot(data = trc_uq_df, aes(x = time, y = nom_run / bar_to_pa))
p <- p + facet_wrap(~ax_locs, ncol = 4)
p <- p + geom_ribbon(
  aes(x = time, ymin = lb_run / bar_to_pa, ymax = ub_run / bar_to_pa),
  fill = "#4D4D4D", alpha = alpha)
p <- p + geom_line()
p <- p + geom_point(data = trc_exp_df, aes(x = time, y = exp_data / bar_to_pa),
                    shape = 4, stroke = 1.0)

# Set axis labels and font size
p <- p + theme_bw()
p <- p + labs(x = "Time [s]",
              y = "Pressure Drop [bar]")
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

