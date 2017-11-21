#
# title     : plotQ2PCs.R
# purpose   : R script to create an illustration plot of Q2 convergence for
#           : each PC with increasing number of test sample size
# author    : WD41, LRS/EPFL/PSI
# date      : Aug. 2017
#
# Load required libraries -----------------------------------------------------
library(ggplot2)
library(tidyr)
library(DiceKriging)

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotQ2PCs.pdf"

# Input data filenames
data_path <- "../../../analysis/gp-pca/results"
input_filenames <- c("q2_pcs_tc.csv",
                     "q2_pcs_dp.csv",
                     "q2_pcs_co.csv")

n_test <- 5000
n_pcs <- c(10, 10, 5)
output_types <- c("tc", "dp", "co")

# Graphic Parameters
fig_size <- c(10, 4)                 # width, height

# Read the data ---------------------------------------------------------------
# Read Q2 files
for (i in 1:3)
{
    q2_pcs <- read.csv(paste(data_path, input_filenames[i], sep = "/"),
                       header = F)
    names(q2_pcs) <- paste0("PC", seq(1, n_pcs[i]))
    q2_pcs$sample <- seq(10:n_test)
    q2_pcs <- gather(q2_pcs, pc, q2, -sample)
    q2_pcs$output_type <- replicate(nrow(q2_pcs), output_types[i])
    if (i == 1)
    {
        q2_pcs_df <- q2_pcs    
    } else
    {
        q2_pcs_df <- rbind(q2_pcs_df, q2_pcs)
    }
}
q2_pcs_df$output_type <- factor(q2_pcs_df$output_type,
                                levels = c("tc", "dp", "co"))
levels(q2_pcs_df$output_type) <- c("Clad Temperature",
                                   "Pressure Drop",
                                   "Liquid Carryover")
# Pre-process the data --------------------------------------------------------

# Make the plot ---------------------------------------------------------------
p <- ggplot(q2_pcs_df, aes(x = sample, y = q2, linetype = pc)) + geom_line()
p <- p + facet_wrap(~output_type)

# Set theme and size
p <- p + theme(text=element_text(family="CM Roman"))
p <- p + theme_bw(base_size = 16)

# Set the font of the facet label
p <- p + theme(strip.text.x = element_text(size = 16, face="bold"))

# Set axis labels and font size
p <- p + labs(x = "Test Samples", 
              y = "Q2 [-]")
p <- p + theme(axis.title.y = element_text(vjust = 1.5, size = 16),
               axis.title.x = element_text(vjust = -0.5, size = 16))

p <- p + theme(axis.ticks.y = element_line(size = 1),
               axis.ticks.x = element_line(size = 1),
               axis.text.x = element_text(size = 14),
               axis.text.y = element_text(size = 14))
p <- p + theme(legend.position = "none")

# Save the plot
pdf(otpfullname, family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
print(p)
dev.off()
embed_fonts(otpfullname, outfile = otpfullname)
