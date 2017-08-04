#
# title     : plotRunningIndices.R
# purpose   : Script to create running indices plot of Sobol' indices 
#           : estimation with maximum temperature as the quantity of interest
#           : using two different Sobol' estimator
# author    : WD41, LRS/EPFL/PSI
# date      : July 2017
#
# Load the Required Libraries -------------------------------------------------
source("./r-scripts/import.R")
source("./r-scripts/tidyRunIndex.R")

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotRunningIndices.pdf"

# Input filenames
qoi_label <- "maxTemp"
output_label <- "tc_4"

data_path <- "../../../analysis/sobol/results"
runindices_filename_1 <- paste0("trace-", output_label, "-", qoi_label, 
                                "-saltelli.csv")
runindices_fullname_1 <- paste0(data_path, "/", runindices_filename_1)
runindices_filename_2 <- paste0("trace-", output_label, "-", qoi_label, 
                                "-janon.csv")
runindices_fullname_2 <- paste0(data_path, "/", runindices_filename_2)

# Estimators label
estimator_1 <- "Saltelli et al."
estimator_2 <- "Janon et al."

# Graphic Parameters
fig_size <- c(8, 4)             # width, height

# Create a tidy dataframe -----------------------------------------------------
df_runindex <- tidyRunIndex(runindices_fullname_1, estimator_1,
                            runindices_fullname_2, estimator_2)

# Plot the running indices, using facet by the estimators ---------------------
p <- ggplot(subset(df_runindex, samples <= 1000),
            aes(x = samples, y = value, colour = index)) 
p <- p + facet_wrap(~estimator) + geom_line()
p <- p + scale_y_continuous(breaks = seq(-0.1, 1.0, 0.10), 
                            limits = c(-0.2, 1.0))

# Set the correct font
p <- p + theme(text=element_text(family="CM Roman"))
p <- p + theme_bw(base_size = 16)

# Edit the x-axis and y-axis labels

p <- p + labs(y = "Index Value [-]",
              x = "Number of Sobol Samples")

# Set axis labels and font size
p <- p + theme(axis.title.y = element_text(vjust = 1.5, size = 18),
               axis.title.x = element_text(vjust = -0.5, size = 18)
)
p <- p + theme(axis.ticks.y = element_line(size = 1),
               axis.ticks.x = element_line(size = 1),
               axis.text.x = element_text(size = 14),
               axis.text.y = element_text(size = 14))

# Set the color of the facet box
p <- p + theme(strip.text.x = element_text(size = 16, face="bold"))

# Use this color pallete for 12 categorical variables
new_colors <- rep("darkgrey", 12)
p <- p + scale_color_manual(values = new_colors)

# Suppress the legend (not necessary)
p <- p + theme(legend.position = "None")

# Save into a file
pdf(otpfullname, family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
print(p)
dev.off()
embed_fonts(otpfullname, outfile=otpfullname)
