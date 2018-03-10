#
# title     : plotTraceUQPosteriorTC.R
# purpose   : R script to create plot of UQ propagation using posterior samples
#           : for TC output
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

# Aggregate the dataframe
trc_uq_prior_df$uq <- as.factor("prior")
trc_uq_post_corr_df$uq <- as.factor("post_corr")
trc_uq_post_ind_df$uq <- as.factor("post_ind")
trc_uq_df <- rbind(trc_uq_prior_df,
                   trc_uq_post_ind_df,
                   trc_uq_post_corr_df)
select_ax_locs <- c("TC5 (1.9 [m])", "TC3 (3.0 [m])", "TC1 (4.1 [m])")
trc_uq_df <- trc_uq_df[trc_uq_df$ax_locs %in% select_ax_locs,]
trc_uq_post_corr_df <- trc_uq_post_corr_df[trc_uq_post_corr_df$ax_locs %in% select_ax_locs,]
trc_exp_df <- trc_exp_df[trc_exp_df$ax_locs %in% select_ax_locs,]

# Make the plot ---------------------------------------------------------------
p <- ggplot(data = trc_uq_df, aes(x = time, y = nom_run))
p <- p + facet_wrap(~ax_locs, ncol = 4)
# Plot the uncertainty bounds
p <- p + geom_ribbon(aes(x = time, ymin = lb_run, ymax = ub_run, fill = uq))
# Nominal run
p <- p + geom_line()
# Posterior, middle run
p <- p + geom_line(data = trc_uq_post_corr_df,
                   aes(x = time, y = mid_run),
                   lty = 2)
# Experimental data
p <- p + geom_point(data = trc_exp_df, aes(x = time, y = exp_data),
                    shape = 4, stroke = 1.0)

# Scale the ribbon color
p <- p + scale_fill_manual(name = "Uncertainty Bands",
                           values = c("prior" = alpha("#4D4D4D", 0.75),
                                      "post_ind" = alpha("#AEAEAE", 0.75),
                                      "post_corr" = alpha("#E6E6E6", 0.75)),
                           labels = c("Prior",
                                      "Posterior, Ind.",
                                      "Posterior, Corr."))

# Set axis labels and font size
p <- p + theme_bw()
p <- p + labs(x = "",
              y = "")
p <- p + theme(strip.text.x = element_text(size = 18, face = "bold"))
p <- p + theme(axis.ticks.y = element_line(size = 1),
               axis.ticks.x = element_line(size = 1),
               axis.text.x = element_text(size = 14, angle = 30, hjust = 1),
               axis.text.y = element_text(size = 14))
p <- p + theme(axis.title.y = element_text(vjust = 1.5, size = 18),
               axis.title.x = element_text(vjust = -0.5, size = 18))
p <- p + theme(legend.position = "none")

# Save the plot ---------------------------------------------------------------
png(otpfullname,
    width = fig_size[1], height = fig_size[2], units = "in", res = 300)
print(p)
dev.off()
