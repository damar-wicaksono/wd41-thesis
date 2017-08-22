#
# title     : plotPCGPConstructionTC.R
# purpose   : R script to create a facet plot of the sensitivity of
#           : reconstruction RMSE for the temperature output to the different
#           : options of Gaussian process metamodel.
# author    : WD41, LRS/EPFL/PSI
# date      : Aug. 2017
#
# Load required libraries -----------------------------------------------------
library(ggplot2)
library(dplyr)
source("./r-scripts/compileGPError.R")

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotPCGPConstructionTC.pdf"

# Current case
output_type <- "tc"
data_path <- "../../../../wd41-thesis.analysis.new/trace-gp/result-er"
feba_case <- "febaTrans216Ext"
param_file <- "febaVars12Influential"
n_params <- 12

error_type <- "recPC7_RMSE"

# Graphic variables
fig_size <- c(18, 9)             # width, height
y_lab <- "PC Reconstruction Error [K]"

# Read Data -------------------------------------------------------------------
gp_error_df <- compileGPError(
    output_type, data_path, feba_case, param_file, n_params)

# Pre-process data ------------------------------------------------------------
levels(gp_error_df$doe_name) <- c("SRS", 
                                  "LHS", 
                                  "Opt. LHS", 
                                  "Sobol' Seq.")
levels(gp_error_df$cov_type) <- c("Gaussian", 
                                  "Matérn 3/2", 
                                  "Matérn 5/2", 
                                  "PowExp")

# Make the plot ---------------------------------------------------------------
p <- gp_error_df %>%
    filter(type == error_type) %>% 
    ggplot(aes(x = cov_type, y = error)) 
p <- p + geom_point(shape = 4, size = 5)
p <- p + facet_grid(doe_name ~ n_train)

# Set theme and size
p <- p + theme(text=element_text(family="CM Roman"))
p <- p + theme_bw(base_size = 16)

# Set the font of the facet label
p <- p + theme(strip.text.x = element_text(size = 20, face = "bold"),
               strip.text.y = element_text(size = 18, face = "bold"))

# Set axis labels and font size
p <- p + labs(x = "Covariance Kernel Function",
              y = y_lab)
p <- p + theme(axis.title.y = element_text(vjust = 1.5, size = 24),
               axis.title.x = element_text(vjust = -0.5, size = 24))

p <- p + theme(axis.ticks.y = element_line(size = 1),
               axis.ticks.x = element_line(size = 1),
               axis.text.x = element_text(size = 16, angle = 30, hjust = 1),
               axis.text.y = element_text(size = 18))

# Save the plot ---------------------------------------------------------------
pdf(otpfullname, family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
print(p)
dev.off()
embed_fonts(otpfullname, outfile=otpfullname)
