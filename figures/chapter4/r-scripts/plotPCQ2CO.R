#
# title     : plotPCQ2CO.R
# purpose   : R script to create a series of plot the convergence of PC
#           : metamodel of the liquid carryover output based on the Q2 metric
# author    : WD41, LRS/EPFL/PSI
# date      : Aug. 2017
#
# Load Required Library -------------------------------------------------------
library(ggplot2)
library(dplyr)
source("./r-scripts/compileGPError.R")

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotPCQ2CO.pdf"

# Current case
output_type <- "co"
data_path <- "../../../../wd41-thesis.analysis.new/trace-gp/result-er"
feba_case <- "febaTrans216Ext"
param_file <- "febaVars12Influential"
n_params <- 12

idx_pc <- c(1, 3, 5)    # Selected PC to present

# Graphic variables
fig_size <- c(10, 4)             # width, height

# Read Data -------------------------------------------------------------------
gp_error_df <- compileGPError(
    output_type, data_path, feba_case, param_file, n_params)

# Pre-process Data ------------------------------------------------------------
str_pc <- paste0("PC", idx_pc)
str_q2 <- paste0(str_pc, "_Q2")
    
gp_error_df_sub <- gp_error_df %>% filter(type == str_q2[1] |
                                          type == str_q2[2] | 
                                          type == str_q2[3])
for (i in 1:3)
{
    levels(gp_error_df_sub$type)[levels(gp_error_df_sub$type) == str_q2[i]] <-
        str_pc[i]
}

# Make the plot ---------------------------------------------------------------
p <- ggplot(gp_error_df_sub,
            aes(x = log10(n_train), y = error)) + 
    geom_point(shape = 4) + 
    facet_wrap(~type)

# Set theme and size
p <- p + theme(text=element_text(family="CM Roman"))
p <- p + theme_bw(base_size = 16)

# Set the font of the facet label
p <- p + theme(strip.text.x = element_text(size = 16, face="bold"))

# Make the grid lines slightly thicker
p <- p + theme(panel.grid.major = element_line(size = 0.5, 
                                               color = "grey"))

# Set axis labels and font size
p <- p + labs(x = "log10 (samples)", 
              y = "Q2 [-]")
p <- p + theme(axis.title.y = element_text(vjust = 1.5, size = 16),
               axis.title.x = element_text(vjust = -0.5, size = 16))

p <- p + theme(axis.ticks.y = element_line(size = 1),
               axis.ticks.x = element_line(size = 1),
               axis.text.x = element_text(size = 14),
               axis.text.y = element_text(size = 14))

# Save the plot into a pdf ----------------------------------------------------
pdf(otpfullname, family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
print(p)
dev.off()
embed_fonts(otpfullname, outfile=otpfullname)