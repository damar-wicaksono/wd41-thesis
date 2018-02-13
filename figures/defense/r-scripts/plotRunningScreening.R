#
# title     : plotRunningScreening.R
# purpose   : Create a plot for running EE statistics (mean of absolute) and
#           : the Sobol total-effect indices
# author    : WD41, LRS/EPFL/PSI
# date      : August
#
# Load the Required Library ---------------------------------------------------
library(tidyr)

# Global variables ------------------------------------------------------------
# Output filename
otpfullnames <- c("./figures/plotRunningScreeningMorrisRadial.png",
                  "./figures/plotRunningScreeningMorrisTrajectory.png",
                  "./figures/plotRunningScreeningSobolTotal.png")
                  
# Input filenames
data_path <- c("../../../../wd41-thesis/analysis/screening/results/")
input_filenames <- c(
    "ee_trace-std-rad-tc_4-ave.csv",
    "ee_trace-std-trj-tc_4-ave.csv",
    "st_trace-tc_4-ave.csv")

str_methods <- c("Morris (radial)", 
                 "Morris (trajectory)", 
                 "Sobol' (total-effect)")

# Graphic Parameters
fig_size <- c(3.1, 3.1)            # width, height

# Create Tidy Data ------------------------------------------------------------
running_indices <- data.frame(num_blocks = c(), params = c(),
                              value = c(), method = c())

for (i in 1:3)
{
    read_df <- read.csv(paste0(data_path, "/", input_filenames[i]))
    read_df <- gather(read_df, params, value, -num_blocks)
    read_df$method <- str_methods[i]
    running_indices <- rbind(running_indices,
                             read_df)
}

running_indices$params <- factor(running_indices$params,
                                 levels = unique(running_indices$params))

# Make the plot ---------------------------------------------------------------
for (i in 1:3)
{
    p <- ggplot(subset(running_indices,
                       method == unique(running_indices$method)[i]),
                aes(x = num_blocks, y = value,
                    linetype = params, colour = params))
    p <- p + facet_grid(~method)
    p <- p + geom_line(lwd = 0.5)
    
    # Set the theme
    p <- p + theme_bw(base_size = 18)
    p <- p + theme(panel.grid.minor = element_blank())
    
    # Use this color pallete for 12 categorical variables
    new_colors <- rep("darkgrey", 27)
    p <- p + scale_color_manual(values = new_colors)
    
    p <- p + scale_linetype_manual(values = c(rep("dotted", 14),
                                              "solid", "dotted", "dotdash",
                                              rep("dotted", 2),
                                              "dashed", rep("dotted", 2),
                                              "twodash", rep("dotted", 4)))
    
    # Set axis label
    p <- p + labs(y = "",
                  x = "")
    
    # Set axis labels and font size
    #p <- p + theme(axis.title.y = element_text(vjust = 1.5, size = 18),
    #               axis.title.x = element_text(vjust = -0.5, size = 18))
    
    p <- p + theme(axis.ticks.y = element_line(size = 1),
                   axis.ticks.x = element_line(size = 1),
                   axis.text.x = element_text(size = 14),
                   axis.text.y = element_text(size = 14))
    
    # Set the color of the facet box
    p <- p + theme(strip.text.x = element_text(size = 16, face = "bold"),
                   strip.background = element_rect(fill = "grey",
                                                   colour = "black"))
    
    # Suppress the legend (not necessary)
    p <- p + theme(legend.position = "None")
    
    # Save into a pdf -------------------------------------------------------------
    png(otpfullnames[i],
        width = fig_size[1], height = fig_size[2], units = "in", res = 600)
    print(p)
    dev.off()
}
