#
# title     : plotTraceUQPosteriorCO.R
# purpose   : R script to create plot of UQ propagation using posterior samples
#           : for CO output
# author    : WD41, LRS/EPFL/PSI
# date      : Jan. 2018
#
# Read data -------------------------------------------------------------------
n_sub <- 5
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

# Make the plot ---------------------------------------------------------------
p <- ggplot(data = trc_uq_df, aes(x = time, y = nom_run))
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
                    shape = 4, stroke = 1.1)

# Limit the axes to maximum around 10.0 [kg] as the tank already saturated
p <- p + scale_x_continuous(limits = x_lims)
p <- p + scale_y_continuous(limits = y_lims)

# Scale the ribbon color
p <- p + scale_fill_manual(name = "",
                           values = c("prior" = "#4D4D4D",
                                      "post_ind" = "#AEAEAE",
                                      "post_corr" = "#E6E6E6"),
                           labels = c("Prior",
                                      "Posterior, Ind.",
                                      "Posterior, Corr."))

# Set axis labels and font size
p <- p + theme_bw()
p <- p + labs(x = "",
              y = "")
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
