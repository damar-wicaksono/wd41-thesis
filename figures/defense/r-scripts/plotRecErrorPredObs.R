#
# title     : plotRecErrorPredObs.R
# purpose   : R script to create an illustration plot that GP Metamodel is a  
#           : statistical metamodel, some prediction will be better and the 
#           : other though a good metamodel will give more good prediction 
#           : than the bad, on average over many realizations as confirmed
#           : in the study through computing Q2 on separate large validation
#           : dataset
#           : The figure also shows the limit of PC metamodel where
#           : discontinuity is hard to reconstruct thus inflate the error a
#           : bit, especially with respect to the clad temperature output.
# author    : WD41, LRS/EPFL/PSI
# date      : Jan. 2018
#
# Load required libraries -----------------------------------------------------
library(ggplot2)
library(DiceKriging)

# Global variables ------------------------------------------------------------
# Output filename
otpfullnames <- c("./figures/plotRecErrorPredObsTCBlank.png",
                  "./figures/plotRecErrorPredObsDP.png",
                  "./figures/plotRecErrorPredObsCO.png")

# Input data filenames
data_path <- "../../../../wd41-thesis/analysis/gp-pca/results"
rec_error_filenames <- c(
    "rec_error_df_tc.csv",
    "rec_error_df_dp.csv",
    "rec_error_df_co.csv")

# Graphic Parameters
fig_size <- c(3.2, 3.2)                 # width, height
x_labs <- c("",
            "",
            "")
y_labs <- c("",
            "",
            "")
ax_lims <- list(c(10, 105), c(0, 310), c(0, 1.0))

for (i in 1:1)
{
    # Read the data -----------------------------------------------------------
    # Read reconstruction error file
    rec_error_df <- read.csv(paste(data_path, rec_error_filenames[i],
                                   sep = "/"), header = TRUE)
    
    # Make the plot -----------------------------------------------------------
    p <- ggplot(data = rec_error_df, aes(x = obs, y = pred)) +
        geom_point(shape = 4, colour=alpha("black", 0))
    
    # Set plotting canvas
    p <- p + labs(x = x_labs[i], y = y_labs[i])
    p <- p + theme_bw()
    p <- p + theme(axis.text.x = element_text(size = 17, colour=alpha("black", 0)))
    p <- p + theme(axis.text.y = element_text(size = 17, colour=alpha("black", 0)))
    p <- p + geom_abline(slope = 1, intercept = 0, colour=alpha("black", 5/10))
    
    p <- p + scale_y_continuous(limits = ax_lims[[i]])
    p <- p + scale_x_continuous(limits = ax_lims[[i]])
    
    # Save the plot
    png(otpfullnames[i],
        width = fig_size[1], height = fig_size[2], units = "in", res = 300)
    print(p)
    dev.off()
}
