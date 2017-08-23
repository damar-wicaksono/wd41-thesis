#
# title     : plotHitAndMiss.R
# purpose   : R script to create an illustration plot that GP Metamodel is a  
#           : statistical metamodel, some prediction will be better and the 
#           : other though a good metamodel will give more good prediction 
#           : than the bad, on average over many realizations as confirmed
#           : in the study through computing Q2 on separate large validation
#           : dataset
#           : The figure also shows the limit of PC metamodel where
#           : discontinuity is hard to reconstruct thus inflate the error a bit.
# author    : WD41, LRS/EPFL/PSI
# date      : Aug. 2017
#
# Load required libraries -----------------------------------------------------
library(DiceKriging)

# Global variables ------------------------------------------------------------
# Output filename
otpfullnames <- c("./figures/plotHitAndMiss_1.pdf",
                  "./figures/plotHitAndMiss_2.pdf")

# Input data filenames
data_path_gp_pc <- "../../../../wd41-thesis.analysis.new/trace-gp/result-gp"
gp_pc_filename <- "febaTrans216Ext-febaVars12Influential-sobol_1920_12-tc-pca-gp-powexp.Rds"

data_path_trc_pca  <- "../../../../wd41-thesis.analysis.new/trace-gp/result-pc" 
trc_pca_filename  <- "febaTrans216Ext-febaVars12Influential-sobol_1920_12-tc-pca.Rds"

data_path_trc_test <- "../../../../wd41-thesis.analysis.new/postpro-gp-training/result-compiled"
trc_test_filename <- "febaTrans216Ext-febaVars12Influential-lhs_1000_12_valid.Rds"

data_path_trc_runs <- "../../../../wd41-thesis/simulation/gp-training/dmfiles"
xx_test_filename  <- "lhs_1000_12_valid.csv"

idx <- c(981, 106)  # Random selection of realization, good and bad prediction

# Graphic Parameters
fig_size <- c(5, 5)                 # width, height
margin <- c(4.5, 5, 2.2, 1) + 0.1   # canvas margin (bot, left, top, right)
cex_axis <- 1.0     # Axis marker size
cex_lab  <- 1.5     # Axis label size
cex_main <- 3.0     # Main title size
tck_len  <- -0.35   # Tick length
cex_lab_shift <- 1.0   # Shift of the axis label from the axis

# Read the data ---------------------------------------------------------------
# Read GP
gp_pc <- readRDS(paste(data_path_gp_pc, gp_pc_filename, sep = "/"))

# Read Test Inputs
xx_test <- read.csv(paste(data_path_trc_runs, xx_test_filename, sep = "/"),
                    header = FALSE)
names(xx_test) <- paste0("x", seq(1, 12))

# Read Test Dataset
trc_test <- readRDS(paste(data_path_trc_test, trc_test_filename, sep = "/"))

# Read PCA
trc_train_pca <- readRDS(paste(data_path_trc_pca, trc_pca_filename, sep = "/"))

# Pre-process the data --------------------------------------------------------
# Shorten variable names
yy_train_ave <- trc_train_pca$yy_train_ave  # Training samples outputs average
yy_train_scl <- trc_train_pca$yy_train_scl  # Training samples outputs scaler
yy_train_var <- trc_train_pca$yy_train_var  # Training outputs PC variance
yy_train_loadings <- trc_train_pca$yy_train_loadings # Training outputs PC load

# Make the plot ---------------------------------------------------------------
for (i in 1:2)
{
    pdf(otpfullnames[i], family = "CM Roman",
        width = fig_size[1], height = fig_size[2])
    par(mfrow = c(1,1), mar = margin, las = 1,
        oma = c(0, 0, 0, 0), bty = "n")
    plot(0, 0, type = "n", 
         xlim = c(0, 800), 
         ylim = c(300, 1400),
         axes = FALSE,
         xlab = "", xaxt = "n",
         ylab = "", yaxt = "n")
    
    for(j in 1:8) lines(trc_test$time, trc_test$replicates[, idx[i], j],
                        col = "black")
    
    for (j in 1:8)
    {
        rec <- matrix(yy_train_ave, ncol = 8)[, j]
        for (k in 1:7)
        {
            pc_pred <- predict(gp_pc[[k]], xx_test[idx[i],],
                               "SK")$mean * yy_train_loadings[, k]
            rec <- rec + matrix(pc_pred, ncol = 8)[, j]
        }
        lines(trc_test$time[2:length(trc_test$time)], rec,
              lty = 2, col = "dark gray")
    }
    
    # x-axis
    axis(side = 1, lwd = 1.5,
         at = c(0, 400, 800), 
         mgp = c(3, cex_lab_shift, 0), 
         tcl = tck_len, cex.axis = cex_axis)
    title(xlab = "Time [s]", mgp = c(2.5, 0, 0), cex.lab = cex_lab)
    # y-axis
    axis(side = 2, lwd = 1.5,
         at = c(400, 900, 1400), 
         mgp = c(3, cex_lab_shift, 0), 
         tcl = tck_len, 
         cex.axis = cex_axis)
    title(ylab = "Clad Temperature [K]", mgp = c(3, 0, 0), cex.lab = cex_lab)
    
    # Close the device
    dev.off()
}