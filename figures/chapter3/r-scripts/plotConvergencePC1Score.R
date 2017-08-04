#
# title     : plotConvergencePC1Score.R
# purpose   : Create convergence plot for Sobol' indices on 1st principal
#           : component scores
# author    : WD41, LRS/EPFL/PSI
# date      : July 2017
#
# Load the Required Library ---------------------------------------------------
source("./r-scripts/import.R")
source("./r-scripts/calcConvergenceSlope.R")
source("./r-scripts/tidyConvergence.R")

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotConvergencePC1Score.pdf"

# Input filename or path
qoi_label <- "pc1"
output_label <- "tc_4_regfd"
data_path <- "../../../analysis/sobol/results"

# Graphic Parameters
y_max <- 0.30                   # Maximum value of the CI length
fig_size <- c(8, 4)             # width, height

# Read and Scrub Data ---------------------------------------------------------
num_samples <- c(250, 500, 1000)
estimators <- c("saltelli", "janon")
estimators_name <- c("Saltelli et al.", "Janon et al.")
df_convergence <- data.frame(samples = c(),
                             ci_length = c(),
                             parameter = c(),
                             index = c(),
                             estimator = c())

for (i in num_samples)
{
    for (j in 1:2)
    {
        bootstrap_filename <- paste0("bootstrap-", estimators[j], "-", 
                                     output_label, "-", qoi_label, "-", i, 
                                     ".csv")
        bootstrap_fullname <- paste0(data_path, "/", bootstrap_filename)
        df_bootstrap <- read.csv(bootstrap_fullname, header = F)
        df_convergence <- rbind(df_convergence,
                                tidyConvergence(df_bootstrap, 
                                                i, 
                                                estimators_name[j],
                                                index = "main"))
    }
}

# Override the parameter names
df_convergence$parameter <- factor(param_names, ordered = TRUE)

# Subset 5 parameters ---------------------------------------------------------
# 4 are important and 1 is not
param_names <- c("gridHT", "dffbWHT", "dffbVIHT", "dffbIntDr", "breakP")
df_conv_sub <- subset(df_convergence, (parameter == param_names[1]| 
                                           parameter == param_names[2]|
                                           parameter == param_names[3]|
                                           parameter == param_names[4]|
                                           parameter == param_names[5]))

# Calculate Regression through the Origin (RTO) -------------------------------
df_conv_sub <- calcConvergenceSlope(df_conv_sub, param_names, estimators_name)

# Create the Convergence Plot -------------------------------------------------
p <- ggplot(df_conv_sub,
            aes(x = 1/sqrt(samples), y = ci_length, shape = parameter))
p <- p + geom_point(size = 3) + facet_wrap(~ estimator)
p <- p + scale_x_continuous(limit = c(0., 0.07))
p <- p + scale_y_continuous(limit = c(0., y_max))

# Set theme and size
p <- p + theme(text=element_text(family="CM Roman"))
p <- p + theme_bw(base_size = 16)

# Set the font of the facet label
p <- p + theme(strip.text.x = element_text(size = 16, face="bold"))

# Make the grid lines slightly thicker
p <- p + theme(panel.grid.major = element_line(size = 0.5, 
                                               color = "grey"))

# Set axis labels and font size
p <- p + labs(x = expression(1/sqrt(samples)), 
              y = "95% CI Length")
p <- p + theme(axis.title.y = element_text(vjust = 1.5, size = 16),
               axis.title.x = element_text(vjust = -0.5, size = 16)
)
p <- p + theme(axis.ticks.y = element_line(size = 1),
               axis.ticks.x = element_line(size = 1),
               axis.text.x = element_text(size = 14),
               axis.text.y = element_text(size = 14))

# Plot the legend
p <- p + theme(legend.position = "top",
               legend.title = element_text(size = 16))
# Plot the regression lines
p <- p + geom_abline(data = df_conv_sub, 
                     mapping = aes(slope = slope, 
                                   intercept = 0.0, 
                                   linetype = parameter), 
                     show.legend = TRUE)

# Save the plot into a pdf ----------------------------------------------------
pdf(otpfullname, family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
print(p)
dev.off()
embed_fonts(otpfullname, outfile=otpfullname)
