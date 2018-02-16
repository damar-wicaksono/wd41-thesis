#
# title     : plotTraceUQPriorTC.R
# purpose   : R script to plot the 95% uncertainty band of the prior
#           : Clad temperature (TC) predictions
# author    : WD41, LRS/EPFL/PSI
# date      : Jan. 2018
#
# Read the data ---------------------------------------------------------------
n_sub <- 5  # Sub sample points (each point would make the file too large)
trc_uq_df <- readRDS(rds_tidy_fullname)[[1]]
n_t <- dim(trc_uq_df)[1]
trc_uq_df <- readRDS(rds_tidy_fullname)[[1]][seq(1, n_t, n_sub),]
#trc_exp_df <- readRDS(rds_tidy_fullname)[[2]]

# Make the plot ---------------------------------------------------------------
p <- ggplot(data = subset(trc_uq_df, ax_locs == "TC4 (2.4 [m])"),
            aes(x = time, y = nom_run))
p <- p + facet_wrap(~ax_locs, ncol = 1)
p <- p + geom_ribbon(aes(x = time, ymin = lb_run, ymax = ub_run),
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
