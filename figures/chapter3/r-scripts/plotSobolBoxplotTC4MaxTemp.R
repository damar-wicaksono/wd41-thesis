#
# title     : plotSobolBoxplotTC4MaxTemp.R
# purpose   : Script to create a boxplot of Sobol Indices for each parameter
#           : with the time of quenching as the QoI
# author    : WD41, LRS/EPFL/PSI
# date      : January 2016
#
# Load the Required Libraries -------------------------------------------------
source("./r-scripts/import.R")
source("./r-scripts/createSobolBoxplot.R")
source("./r-scripts/createLabels.R")

# define the summary function to redefined boxplot ----------------------------
f <- function(x) {
    r <- quantile(x, probs = c(0.025, 0.25, 0.5, 0.75, 0.975))
    names(r) <- c("ymin", "lower", "middle", "upper", "ymax")
    r
}

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotSobolBoxplotTC4MaxTemp.pdf"

# Input filename
bootstrap_files <- c(
    "../../../analysis/sobol/results/bootstrap-janon-tc_4-maxTemp-2000.csv",
    "../../../analysis/sobol/results/bootstrap-sti-tc_4-maxTemp-2000.csv")
indices_file <- c(
    "../../../analysis/sobol/results/estimate-tc_4-maxTemp-2000.csv")

idx_estimator <- 2      # Use Janon et al estimator

indices <- c("main", "total")

# Graphic Parameters
fig_size <- c(12, 5)             # width, height

# Create tidy dataframe -------------------------------------------------------
n_bootstrap <- dim(bootstrap_df1)[1]

# Create tidy dataframe
bootstrap_df <- data.frame(value = c(), index = c(), parameter = c())
for (i in 1:2)
{
    bootstrap_df_temp <- read.csv(bootstrap_files[i], header = FALSE)
    for (j in 1:12)
    {
        bootstrap_df <- rbind(bootstrap_df,
                              data.frame(value = bootstrap_df_temp[,j],
                                         index = rep(indices[i],
                                                     n_bootstrap),
                                          parameter = rep(param_names[j],
                                                          n_bootstrap)))
    }
}

indices_df <- read.csv(indices_file, header = FALSE)
indices_df[indices_df[,idx_estimator] < 0, ] <- 0.0

# Create the boxplot ----------------------------------------------------------
p <- createSobolBoxplot(bootstrap_df)

# Make a fine y-axis tick mark
p <- p + scale_y_continuous(breaks = seq(-0.1, 0.6, 0.1),
                            limits = c(-0.1, 0.5))

# Calculate the sum of first order indices, all, first 4, and DFFB-related
sum(indices_df[, idx_estimator])                # 0.82
sum(indices_df[c(5,7,8,10), idx_estimator])     # 0.77
sum(indices_df[c(7,8,10), idx_estimator])       # 0.63

# Make a title informing the sum of the first order indices
first_line <- "Sum of the main effect indices = 0.82 \n"
second_line <- "Maximum temperature standard deviation = 59.7 [K]"
sobol_title <- paste(first_line, second_line, sep="")
p <- p + ggtitle(sobol_title)
p <- p + theme(plot.title = element_text(hjust = 0.0,
                                         vjust = 0.75, 
                                         size = rel(0.85)))

# Save into a pdf -------------------------------------------------------------
pdf(otpfullname, family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
print(p)
dev.off()
embed_fonts(otpfullname, outfile=otpfullname)
