#
# title     : plotTraceUQPosteriorDP.R
# purpose   : R script to create plot of UQ propagation using posterior samples
#           : for DP output
# author    : WD41, LRS/EPFL/PSI
# date      : Nov. 2017
#
# Read data -------------------------------------------------------------------
n_sub <- 5  # Sub sample points (each point would make the file too large)
trc_uq_prior_df <- readRDS(rds_tidy_prior_fullname)[[1]]
n_t <- dim(trc_uq_prior_df)[1]
trc_uq_prior_df <- readRDS(rds_tidy_prior_fullname)[[1]][seq(1, n_t, n_sub),]
trc_uq_post_corr_df <- readRDS(rds_tidy_corr_fullname)[[1]][seq(1, n_t, n_sub),]
trc_uq_post_ind_df <- readRDS(rds_tidy_ind_fullname)[[1]][seq(1, n_t, n_sub),]
trc_exp_df <- readRDS(rds_tidy_prior_fullname)[[2]]

# Make the plot ---------------------------------------------------------------
p <- ggplot(data = trc_uq_prior_df, aes(x = time, y = nom_run / 1e5))
p <- p + facet_wrap(~ax_locs, ncol = 4)
p <- p + geom_ribbon(aes(x = time, ymin = lb_run / 1e5, ymax = ub_run / 1e5),
                     fill = "darkgray", alpha = 1.0)
p <- p + geom_ribbon(data = trc_uq_post_ind_df,
                     aes(x = time, ymin = lb_run / 1e5, ymax = ub_run / 1e5),
                     fill = "lightgray", alpha = 1.0)
p <- p + geom_ribbon(data = trc_uq_post_corr_df,
                     aes(x = time, ymin = lb_run / 1e5, ymax = ub_run / 1e5),
                     fill = "white", alpha = 1.0)
p <- p + geom_line()
p <- p + geom_point(data = trc_exp_df, aes(x = time, y = exp_data / 1e5),
                    shape = 4, stroke = 1.0)
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

# Save the plot ---------------------------------------------------------------
pdf(otpfullname, family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
print(p)
dev.off()
embed_fonts(otpfullname, outfile = otpfullname)