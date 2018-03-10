#
# title     : plotCalibInfoInit.R
# purpose   : R script to create a facet plot of Calibration Score vs.
#           : Informativeness for each output for each FEBA Test
# author    : WD41, LRS/EPFL/PSI
# date      : Jan. 2018
#
# Load required libraries -----------------------------------------------------
library(ggplot2)
library(plyr)

# Global variables ------------------------------------------------------------
# Input filenames
infilenames <- list.files("../../../wd41-thesis/figures/data-support/postpro/qoi/", full.names = T)

# Output filename
otpfullname <- "./figures/plotCalibInfoInit.png"

# Graphic variables
fig_size <- c(9.1, 5.75)

# Read the data ---------------------------------------------------------------
calibinfo_df <- readRDS(infilenames[1])
for (i in 2:length(infilenames))
{
    calibinfo_df <- rbind(calibinfo_df, readRDS(infilenames[i]))
}

calibinfo_df1 <- subset(calibinfo_df, case_name != "srs")
calibinfo_srs_df <- subset(calibinfo_df, case_name == "srs")

calibinfo_df1$feba_test <- factor(calibinfo_df1$feba_test,
                                  levels = c(214,216,218,223,220,222),
                                  ordered = T)
calibinfo_df1$output_type <- factor(calibinfo_df1$output_type,
                                    levels = c("TC", "DP", "CO"),
                                    ordered = T)

calibinfo_df1$case_name <- revalue(calibinfo_df1$case_name,
                                   c("mcmcAllDiscCentered" = "w/ Bias, All, Corr.",
                                     "mcmcAllDiscCenteredInd" = "w/ Bias, All, Ind.",
                                     "mcmcAllDiscCenteredNoParam8" = "w/ Bias, no dffbVIHT, Corr.",
                                     "mcmcAllDiscCenteredNoParam8Ind" = "w/ Bias, no dffbVIHT, Ind.",
                                     "mcmcAllNoDiscNoBC" = "w/o Bias, Corr.",
                                     "mcmcAllNoDiscNoBCInd" = "w/o Bias, Ind.",
                                     "mcmcTCDiscCentered" = "w/ Bias, TC",
                                     "mcmcDPDiscCentered" = "w/ Bias, DP",
                                     "mcmcCODiscCentered" = "w/ Bias, CO"))

case_names <- c("w/ Bias, All, Corr.", "w/ Bias, All, Ind.",
                "w/ Bias, no dffbVIHT, Corr.", "w/ Bias, no dffbVIHT, Ind.",
                "w/o Bias, Corr.", "w/o Bias, Ind.",
                "w/ Bias, TC", "w/ Bias, DP", "w/ Bias, CO")

calibinfo_df1$case_name <- factor(calibinfo_df1$case_name,
                                  levels = case_names,
                                  ordered = T)

calibinfo_df1 <- calibinfo_df1[calibinfo_df1$feba_test %in% c(214,218,223,220,222),]
calibinfo_srs_df <- calibinfo_srs_df[calibinfo_srs_df$feba_test %in% c(214,218,223,220,222),]

case_names <- c("w/ Bias, All, Corr.", "w/ Bias, All, Ind.",
                "w/o Bias, Corr.", "w/o Bias, Ind.")
calibinfo_df1 <- calibinfo_df1[calibinfo_df1$case_name %in% case_names,]

# Make the plot ---------------------------------------------------------------
p <- ggplot(data = calibinfo_df1,
            aes(x = inf_score, y = cal_score, shape = case_name))
p <- p + facet_grid(output_type ~ feba_test)
p <- p + geom_point(size = 4)
p <- p + scale_shape_manual(values = c(0,15,1,16,11,7,8))
p <- p + theme_bw()
p <- p + geom_hline(data = calibinfo_srs_df, aes(yintercept = cal_score))
p <- p + geom_vline(data = calibinfo_srs_df, aes(xintercept = inf_score))

# Set axis labels and font size
p <- p + labs(x = "",
              y = "")
p <- p + theme(strip.text.x = element_text(size = 18, face = "bold"))
p <- p + theme(strip.text.y = element_text(size = 18, face = "bold"))
p <- p + theme(axis.ticks.y = element_line(size = 1),
               axis.ticks.x = element_line(size = 1),
               axis.text.x = element_text(size = 14, angle = 30, hjust = 1),
               axis.text.y = element_text(size = 14))
p <- p + theme(axis.title.y = element_text(vjust = 1.5, size = 18),
               axis.title.x = element_text(vjust = -0.5, size = 18))
p <- p + theme(legend.position = "top")
p <- p + guides(shape = guide_legend(title = "Calibration Scheme"))
p <- p + theme(legend.text = element_text(size = 14),
               legend.title = element_text(size = 15, face = "bold"))

# Save the plot ---------------------------------------------------------------
png(otpfullname,
    width = fig_size[1], height = fig_size[2], units = "in", res = 300)
print(p)
dev.off()
