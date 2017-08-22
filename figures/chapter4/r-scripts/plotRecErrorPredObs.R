#
# title     : plotRecE.R
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
otpfullname <- "./figures/plotRecErrorPredObs.pdf"

# Input data filename
gp_pc_filename <- "../../../../wd41-thesis.analysis.new/trace-gp/result-gp/febaTrans216Ext-febaVars12Influential-sobol_1920_12-tc-pca-gp-powexp.Rds"
trc_pca_filename <- "../../../../wd41-thesis.analysis.new/trace-gp/result-pc/febaTrans216Ext-febaVars12Influential-sobol_1920_12-tc-pca.Rds"
trc_test_filename <- "../../../../wd41-thesis.analysis.new/postpro-gp-training/result-compiled/febaTrans216Ext-febaVars12Influential-lhs_1000_12_valid.Rds"
xx_test_filename <- "../../../../wd41-thesis/simulation/gp-training/dmfiles/lhs_1000_12_valid.csv"

idx <- c(314, 9)    # Random selection of realization, good and bad prediction

# Graphic Parameters
fig_size <- c(5, 5)                 # width, height

# Read the data ---------------------------------------------------------------
# Read GP
gp_pc <- readRDS(gp_pc_filename)

# Read Test Inputs
xx_test <- read.csv(xx_test_filename, header = FALSE)
names(xx_test) <- paste0("x", seq(1, 12))

# Read Test Dataset
trc_test <- readRDS(trc_test_filename)

# Read PCA
trc_train_pca <- readRDS(trc_pca_filename)

# Pre-process the data --------------------------------------------------------
n_train <- 1920
n_test <- 1000
idx_outp <- 1:8
yy_test <- matrix(0, n_test, 8 * 9999)
for (i in 1:n_valid) yy_test[i,] <- trc_test$replicates[2:length(trc_test$time), i, idx_outp]
rm(trc_test)

# Shorten variable names
yy_train_ave <- trc_train_pca$yy_train_ave  # Training samples outputs average
yy_train_scl <- trc_train_pca$yy_train_scl  # Training samples outputs scaler
yy_train_var <- trc_train_pca$yy_train_var  # Training outputs PC variance
yy_train_loadings <- trc_train_pca$yy_train_loadings # Training outputs PC load

# Centered and scaled
yy_test_ctrd <- sweep(yy_test, 2, yy_train_ave, `-`)
yy_test_scld <- sweep(yy_test_ctrd, 2, (1/yy_train_scl), `*`)

# Project validation data to the training PC coordinate
yy_test_scores <- yy_test_scld  %*% yy_train_loadings %*%
    diag(1/yy_train_var / (n_train - 1)) * (n_train - 1)
rm(yy_test_scld)

n_test <- 1000
rec_gps_pc_error <- rep(0, n_test)
rec_obs_pc_error <- rep(0, n_test)

for (i in 1:n_test)
{
    # GP Prediction Error
    rec <- yy_train_ave
    for (j in 1:7)
    {
        pc_pred <- predict(gp_pc[[j]], xx_test[i,],
                           "SK")$mean * yy_train_loadings[, j]
        rec <- rec + pc_pred
    }
    rec_gps_pc_error[i] <- sqrt(mean((yy_test[i,] - rec)^2))
    
    # Observed Error
    rec <- yy_train_ave
    for (j in 1:7)
    {
        pc_pred <- yy_test_scores[i, j] * yy_train_loadings[, j]
        rec <- rec + pc_pred
    }
    rec_obs_pc_error[i] <- sqrt(mean((yy_test[i,] - rec)^2))
}

rec_error_df <- data.frame(obs = rec_obs_pc_error, pred = rec_gps_pc_error)

# Make the plot ---------------------------------------------------------------
p <- ggplot(data = rec_error_df, aes(x = obs, y = pred)) +
    geom_point(shape = 4)

# Set plotting canvas
p <- p + labs(x = "Observed Reconstruction Error (RMSE) [K]",
              y = "Predicted Reconstruction Error (RMSE) [K]")
p <- p + scale_y_continuous(limits = y_lims)
p <- p + theme_bw()
p <- p + theme(axis.title.x = element_text(size = 16))
p <- p + theme(axis.title.y = element_text(size = 16, vjust = 1.5))
p <- p + theme(axis.text.x = element_text(size = 14))
p <- p + theme(axis.text.y = element_text(size = 14))
p <- p + geom_abline(slope = 1, intercept = 0)

# Save the plot
pdf(otpfullname, family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
print(p)
dev.off()
embed_fonts(otpfullname, outfile = otpfullname)
