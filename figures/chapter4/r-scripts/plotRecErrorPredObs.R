#
# title     : plotRecErroPredObs.R
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
# date      : Aug. 2017
#
# Load required libraries -----------------------------------------------------
library(ggplot2)
library(DiceKriging)

# Global variables ------------------------------------------------------------
# Output filename
otpfullnames <- c("./figures/plotRecErrorPredObsTC.pdf",
                  "./figures/plotRecErrorPredObsDP.pdf",
                  "./figures/plotRecErrorPredObsCO.pdf")

# Input data filenames
data_path <- "../../../analysis/gp-pca/results"
rec_error_filenames <- c(
    "rec_error_df_tc.csv",
    "rec_error_df_dp.csv",
    "rec_error_df_co.csv")

# Graphic Parameters
fig_size <- c(5, 5)                 # width, height
x_labs <- c("Observed Reconstruction Error (RMSE) [K]",
            "Observed Reconstruction Error (RMSE) [Pa]",
            "Observed Reconstruction Error (RMSE) [kg]")
y_labs <- c("Predicted Reconstruction Error (RMSE) [K]",
            "Predicted Reconstruction Error (RMSE) [Pa]",
            "Predicted Reconstruction Error (RMSE) [kg]")
ax_lims <- list(c(10, 105), c(0, 310), c(0, 1.0))

for (i in 1:3)
{
    # Read the data -----------------------------------------------------------
    # Read reconstruction error file
    rec_error_df <- read.csv(paste(data_path, rec_error_filenames[i],
                                   sep = "/"), header = TRUE)

    # Make the plot -----------------------------------------------------------
    p <- ggplot(data = rec_error_df, aes(x = obs, y = pred)) +
        geom_point(shape = 4, colour=alpha("black", 2/10))
    
    # Set plotting canvas
    p <- p + labs(x = x_labs[i], y = y_labs[i])
    p <- p + theme_bw()
    p <- p + theme(axis.title.x = element_text(size = 16))
    p <- p + theme(axis.title.y = element_text(size = 16, vjust = 1.5))
    p <- p + theme(axis.text.x = element_text(size = 14))
    p <- p + theme(axis.text.y = element_text(size = 14))
    p <- p + geom_abline(slope = 1, intercept = 0)
    
    p <- p + scale_y_continuous(limits = ax_lims[[i]])
    p <- p + scale_x_continuous(limits = ax_lims[[i]])
    
    # Save the plot
    pdf(otpfullnames[i], family = "CM Roman",
        width = fig_size[1], height = fig_size[2])
    print(p)
    dev.off()
}
