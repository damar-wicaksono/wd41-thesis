#
# title     : plotTraceUQDPPrior.R
# purpose   : R script to plot the 95% uncertainty band of the prior
#           : uncertainty predictions of the pressure drop (DP)
# author    : WD41, LRS/EPFL/PSI
# date      : Jan. 2018
#
# Global variables ------------------------------------------------------------
bar_to_pa <- 1e5
n_sub <- 5  # Sub sample points (each point would make the file too large)

# Read data -------------------------------------------------------------------
trc_uq_df <- readRDS(rds_tidy_fullname)[[1]]
n_t <- dim(trc_uq_df)[1]
trc_uq_df <- readRDS(rds_tidy_fullname)[[1]][seq(1, n_t, n_sub),]

# Revalue the axial segments
new_ax_locs <- c("Bottom" = "Bottom (z = 0.0 - 1.7 [m])",
                 "Middle" = "Mid DP (1.7 - 2.3 [m])",
                 "Top" = "Top (z = 2.3 - 4.1 [m])",
                 "Total" = "Total (z = 0.0 - 4.1 [m])")
trc_uq_df$ax_locs <- revalue(trc_uq_df$ax_locs, new_ax_locs)

# Make the plot ---------------------------------------------------------------
p <- ggplot(data = subset(trc_uq_df, ax_locs == "Mid DP (1.7 - 2.3 [m])"),
            aes(x = time, y = nom_run / bar_to_pa))
p <- p + facet_wrap(~ax_locs, ncol = 1)
p <- p + geom_ribbon(
    aes(x = time, ymin = lb_run / bar_to_pa, ymax = ub_run / bar_to_pa),
    fill = "#4D4D4D", alpha = alpha)
p <- p + geom_line()

# Set axis labels and font size
p <- p + theme_bw()
p <- p + labs(x = "",
              y = "")
p <- p + theme(strip.text.x = element_text(size = 16, face = "bold"))
p <- p + theme(axis.ticks.y = element_line(size = 1),
               axis.ticks.x = element_line(size = 1),
               axis.text.x = element_text(size = 14, angle = 30, hjust = 1),
               axis.text.y = element_text(size = 14))
p <- p + scale_x_continuous(limits = c(0, 500))

# Save the plot ---------------------------------------------------------------
png(otpfullname,
    width = fig_size[1], height = fig_size[2], units = "in", res = 600)
print(p)
dev.off()
