#
# title     : plotFEBATC1Post.R
# purpose   : R script to create plot of UQ propagation using posterior samples
#           : for TC1 output (at the top of the assembly) for comparing
#           : different calibration schemes
#           : FEBA Test No. 216
# author    : WD41, LRS/EPFL/PSI
# date      : Dec. 2017
#
# Load required libraries -----------------------------------------------------
library(ggplot2)

# Global variables ------------------------------------------------------------

# FEBA Test No
feba_tests <- c(214, 216, 218, 220, 222, 223)

# Output filename
otpfullnames_nodisc <- c("./figures/plotFEBA214TC1PostNoDisc.pdf",
                         "./figures/plotFEBA216TC1PostNoDisc.pdf",
                         "./figures/plotFEBA218TC1PostNoDisc.pdf",
                         "./figures/plotFEBA220TC1PostNoDisc.pdf",
                         "./figures/plotFEBA222TC1PostNoDisc.pdf",
                         "./figures/plotFEBA223TC1PostNoDisc.pdf")

otpfullnames_noparam8 <- c("./figures/plotFEBA214TC1PostDiscNoParam8.pdf",
                           "./figures/plotFEBA216TC1PostDiscNoParam8.pdf",
                           "./figures/plotFEBA218TC1PostDiscNoParam8.pdf",
                           "./figures/plotFEBA220TC1PostDiscNoParam8.pdf",
                           "./figures/plotFEBA222TC1PostDiscNoParam8.pdf",
                           "./figures/plotFEBA223TC1PostDiscNoParam8.pdf")

otpfullnames_disc <- c("./figures/plotFEBA214TC1PostDisc.pdf",
                       "./figures/plotFEBA216TC1PostDisc.pdf",
                       "./figures/plotFEBA218TC1PostDisc.pdf",
                       "./figures/plotFEBA220TC1PostDisc.pdf",
                       "./figures/plotFEBA222TC1PostDisc.pdf",
                       "./figures/plotFEBA223TC1PostDisc.pdf")

# Graphic variables
fig_size <- c(4, 4)

# Make the plot ---------------------------------------------------------------
for (i in 1:length(feba_tests))
{
  # w/ Bias
  # Input filename
  rds_tidy_prior_fullname <- paste0(
    "../data-support/postpro/srs/febaTrans",
    feba_tests[i],
    "-febaVars12Influential-srs_1000_12-tc-tidy.Rds")
  # Input filenames, posterior samples, correlated and independent
  rds_tidy_corr_fullname <- paste0(
    "../data-support/postpro/disc/centered/all-params/correlated/febaTrans",
    feba_tests[i],
    "-febaVars12Influential-mcmcAllDiscCentered_1000_12-tc-tidy.RDs")
  rds_tidy_ind_fullname <- paste0(
    "../data-support/postpro/disc/centered/all-params/independent/febaTrans",
    feba_tests[i],
    "-febaVars12Influential-mcmcAllDiscCenteredInd_1000_12-tc-tidy.RDs")
  # Make the plot
  p <- plotSingleTC(rds_tidy_prior_fullname,
                    rds_tidy_corr_fullname,
                    rds_tidy_ind_fullname)
  pdf(otpfullnames_disc[i], family = "CM Roman",
      width = fig_size[1], height = fig_size[2])
  print(p)
  dev.off()
  embed_fonts(otpfullnames_disc[i], outfile = otpfullnames_disc[i])
}

for (i in 1:length(feba_tests))
{
  # w/o Bias
  # Input filename
  rds_tidy_prior_fullname <- paste0(
    "../data-support/postpro/srs/febaTrans",
    feba_tests[i],
    "-febaVars12Influential-srs_1000_12-tc-tidy.Rds")
  # Input filenames, posterior samples, correlated and independent
  rds_tidy_corr_fullname <- paste0(
    "../data-support/postpro/nodisc/not-centered/fix-bc/correlated/febaTrans",
    feba_tests[i],
    "-febaVars12Influential-mcmcAllNoDiscNoBC_1000_12-tc-tidy.RDs")
  rds_tidy_ind_fullname <- paste0(
    "../data-support/postpro/nodisc/not-centered/fix-bc/independent/febaTrans",
    feba_tests[i],
    "-febaVars12Influential-mcmcAllNoDiscNoBCInd_1000_12-tc-tidy.RDs")
  # Make the plot
  p <- plotSingleTC(rds_tidy_prior_fullname,
                    rds_tidy_corr_fullname,
                    rds_tidy_ind_fullname)

  pdf(otpfullnames_nodisc[i], family = "CM Roman",
      width = fig_size[1], height = fig_size[2])
  print(p)
  dev.off()
  embed_fonts(otpfullnames_nodisc[i], outfile = otpfullnames_nodisc[i])
}

for (i in 1:length(feba_tests))
{
  # w/o Parameter 8 (dffbVIHTC)
  # Input filename
  rds_tidy_prior_fullname <- paste0(
    "../data-support/postpro/srs/febaTrans",
    feba_tests[i],
    "-febaVars12Influential-srs_1000_12-tc-tidy.Rds")
  # Input filenames, posterior samples, correlated and independent
  rds_tidy_corr_fullname <- paste0(
    "../data-support/postpro/disc/centered/no-param8/correlated/febaTrans",
    feba_tests[i],
    "-febaVars12Influential-mcmcAllDiscCenteredNoParam8_1000_12-tc-tidy.RDs")
  rds_tidy_ind_fullname <- paste0(
    "../data-support/postpro/disc/centered/no-param8/independent/febaTrans",
    feba_tests[i],
    "-febaVars12Influential-mcmcAllDiscCenteredNoParam8Ind_1000_12-tc-tidy.RDs")
  # Make the plot
  p <- plotSingleTC(rds_tidy_prior_fullname,
                    rds_tidy_corr_fullname,
                    rds_tidy_ind_fullname)

  # Save the plot
  pdf(otpfullnames_noparam8[i], family = "CM Roman",
      width = fig_size[1], height = fig_size[2])
  print(p)
  dev.off()
  embed_fonts(otpfullnames_noparam8[i], outfile = otpfullnames_noparam8[i])
}

# Make the plot ---------------------------------------------------------------
plotSingleTC <- function(rds_tidy_prior_fullname,
                         rds_tidy_corr_fullname,
                         rds_tidy_ind_fullname,
                         show_legend = F)
{
  # Read data
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

  p <- ggplot(data = subset(trc_uq_df, ax_locs == "TC1 (4.1 [m])"),
              aes(x = time, y = nom_run))
  # Plot the ncertainty bounds
  p <- p + geom_ribbon(aes(x = time, ymin = lb_run, ymax = ub_run, fill = uq))
  # Nominal run
  p <- p + geom_line()
  # Posterior, middle run
  p <- p + geom_line(data = subset(trc_uq_post_corr_df,
                                   ax_locs == "TC1 (4.1 [m])"),
                     aes(x = time, y = mid_run),
                     lty = 2)
  # Experimental data
  p <- p + geom_point(data = subset(trc_exp_df, ax_locs == "TC1 (4.1 [m])"),
                      aes(x = time, y = exp_data),
                      shape = 4, stroke = 1.0)

  # Scale the ribbon color
  p <- p + scale_fill_manual(name = "Uncertainty Bands",
                             values = c("prior" = alpha("#4D4D4D", 0.75),
                                        "post_ind" = alpha("#AEAEAE", 0.75),
                                        "post_corr" = alpha("#E6E6E6", 0.75)),
                             labels = c("Prior",
                                        "Posterior, Corr.",
                                        "Posterior, Ind."))

  # Set axis labels and font size
  p <- p + theme_bw()
  p <- p + labs(x = "Time [s]",
                y = "Clad Temperature [K]")
  p <- p + theme(plot.title = element_text(size = 18, face = "bold"))
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
