#
# title     : plotFEBA216COPost.R
# purpose   : R script to create plot of UQ propagation using posterior samples
#           : for TC1 output (at the top of the assembly) for comparing
#           : different calibration schemes
#           : FEBA Test No. 216
# author    : WD41, LRS/EPFL/PSI
# date      : Dec. 2017
#
# Load required libraries -----------------------------------------------------
library(ggplot2)

# Custom functions ------------------------------------------------------------
plotSingleCO <- function(rds_tidy_prior_fullname,
                         rds_tidy_corr_fullname,
                         rds_tidy_ind_fullname,
                         show_legend = F)
{
  # Read data -------------------------------------------------------------------
  n_sub <- 5
  trc_uq_prior_df <- readRDS(rds_tidy_prior_fullname)[[1]]
  n_t <- dim(trc_uq_prior_df)[1]

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
                                        "Posterior, Corr.",
                                        "Posterior, Ind."))

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
  p <- p + theme(legend.position = "none")

  if (show_legend)
  {
    p <- p + theme(legend.position = "bottom")
    p <- p + theme(legend.text = element_text(size = 16),
                   legend.title = element_text(size = 18))
  }

  return(p)
}

# Global variables ------------------------------------------------------------

# FEBA Test No
feba_test <- 216

# Input filename
rds_tidy_prior_fullname <- paste0(
  "../data-support/postpro/srs/febaTrans",
  feba_test,
  "-febaVars12Influential-srs_1000_12-co-tidy.Rds")

# Output filename
otpfullnames <- c("./figures/plotFEBA216COPost_1.pdf",
                  "./figures/plotFEBA216COPost_2.pdf",
                  "./figures/plotFEBA216COPost_3.pdf")

# Graphic variables
fig_size <- c(4, 4)

# Make the plot ---------------------------------------------------------------
# w/ Bias
# Input filenames, posterior samples, correlated and independent
rds_tidy_corr_fullname <- paste0(
  "../data-support/postpro/disc/centered/all-params/correlated/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllDiscCentered_1000_12-co-tidy.RDs")
rds_tidy_ind_fullname <- paste0(
  "../data-support/postpro/disc/centered/all-params/independent/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllDiscCenteredInd_1000_12-co-tidy.RDs")
# Make the plot
p1 <- plotSingleCO(rds_tidy_prior_fullname,
                   rds_tidy_corr_fullname,
                   rds_tidy_ind_fullname)

# w/o Bias
# Input filenames, posterior samples, correlated and independent
rds_tidy_corr_fullname <- paste0(
  "../data-support/postpro/nodisc/not-centered/fix-bc/correlated/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllNoDiscNoBC_1000_12-co-tidy.RDs")
rds_tidy_ind_fullname <- paste0(
  "../data-support/postpro/nodisc/not-centered/fix-bc/independent/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllNoDiscNoBCInd_1000_12-co-tidy.RDs")
# Make the plot
p2 <- plotSingleCO(rds_tidy_prior_fullname,
                   rds_tidy_corr_fullname,
                   rds_tidy_ind_fullname)

# w/o Parameter 8 (dffbVIHTC)
# Input filenames, posterior samples, correlated and independent
rds_tidy_corr_fullname <- paste0(
  "../data-support/postpro/disc/centered/no-param8/correlated/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllDiscCenteredNoParam8_1000_12-co-tidy.RDs")
rds_tidy_ind_fullname <- paste0(
  "../data-support/postpro/disc/centered/no-param8/independent/febaTrans",
  feba_test,
  "-febaVars12Influential-mcmcAllDiscCenteredNoParam8Ind_1000_12-co-tidy.RDs")
# Make the plot
p3 <- plotSingleCO(rds_tidy_prior_fullname,
                   rds_tidy_corr_fullname,
                   rds_tidy_ind_fullname)

p <- list(p1, p2, p3)

# Save the plot ---------------------------------------------------------------
for (i in 1:3)
{
  pdf(otpfullnames[i], family = "CM Roman",
      width = fig_size[1], height = fig_size[2])
  print(p[[i]])
  dev.off()
  embed_fonts(otpfullnames[i], outfile = otpfullnames[i])
}
