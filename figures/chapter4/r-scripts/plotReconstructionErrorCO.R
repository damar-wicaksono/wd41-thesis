#
# title     : plotReconstructionErrorCO.R
# purpose   : R script to create a plot of reconstruction error for the 
#           : liquid carryover output using increasing number of principal
#           : components in the reconstruction
#           : 0 PC indicates only the training sample average is used
# author    : WD41, LRS/EPFL/PSI
# date      : Aug. 2017
#
# Load required libraries -----------------------------------------------------
library(ggplot2)

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "figures/plotReconstructionErrorCO.pdf"

# Input data filename
trc_valid_path <- "../../../../wd41-thesis.analysis.new/postpro-gp-training/result-compiled"
trc_valid_filename <- "febaTrans216Ext-febaVars12Influential-lhs_5000_12_valid.Rds"

trc_train_pca_path <- "../../../../wd41-thesis.analysis.new/trace-gp/result-pc"
trc_train_pca_filename <- c(
    "febaTrans216Ext-febaVars12Influential-sobol_1920_12-co-pca.Rds")

n_train <- 1920     # Number of training samples
n_valid <- 5000     # Number of validation samples
n_ts <- 10000       # Number of time steps
n_outp <- 1         # Number of outputs (1 liquid carryover)
idx_outp <- 13      # Index of the output (13 for liquid carryover)

# Graphic Parameters
y_lab <- "RMSE [kg]"
fig_size <- c(4, 4)             # width, height
y_lims <-  c(0, 6.5)

# Read data -------------------------------------------------------------------
trc_valid <- readRDS(paste0(trc_valid_path, "/", trc_valid_filename))
trc_train_pca <- readRDS(
    paste0(trc_train_pca_path, "/", trc_train_pca_filename))

# Pre-process the data --------------------------------------------------------
yy_valid <- matrix(0, n_valid, n_outp * n_ts)
for (i in 1:n_valid) yy_valid[i,] <- trc_valid$replicates[, i, idx_outp]

# Shorten variable names
yy_train_ave <- trc_train_pca$yy_train_ave  # Training samples outputs average
yy_train_scl <- trc_train_pca$yy_train_scl  # Training samples outputs scaler
yy_train_var <- trc_train_pca$yy_train_var  # Training outputs PC variance
yy_train_loadings <- trc_train_pca$yy_train_loadings # Training outputs PC load

# Centered and scaled
yy_valid_ctrd <- sweep(yy_valid, 2, yy_train_ave, `-`)
yy_valid_scld <- sweep(yy_valid_ctrd, 2, (1/yy_train_scl), `*`)

# Project validation data to the training PC coordinate
yy_valid_scores <- yy_valid_scld  %*% yy_train_loadings %*%
    diag(1/yy_train_var / (n_train - 1)) * (n_train - 1)

# Compute the reconstruction error
# Using only the mean training output for reconstruction
rec_error <- matrix(0, nrow = n_valid, ncol = n_outp * n_ts)
for (i in 1:n_valid) rec_error[i, ] <- yy_valid[i, ] - yy_train_ave
rec_error_pca <- sqrt(mean(rec_error^2))

# Using increasing number of PC
for (i in 1:10)
{
    for (j in 1:n_valid) 
    {
        rec <- yy_train_ave
        for (k in 1:i)
        {
            rec <- rec + yy_valid_scores[j, k] * yy_train_loadings[,k]
        }
        rec_error[j,] <- yy_valid[j,] - rec
    }
    rec_error_pca <- c(rec_error_pca, sqrt(mean(rec_error^2)))
}

# Create a dataframe
rec_error_pca <- data.frame(PC = as.factor(seq(0,10)), rmse = rec_error_pca)

# Make the plot ---------------------------------------------------------------
p <- ggplot(rec_error_pca, aes(x = PC, y = rmse, group = 1))
p <- p + geom_point()
p <- p + geom_line()

# Set plotting canvas
p <- p + labs(x = "PC", y = y_lab)
p <- p + scale_y_continuous(limits = c(0, 6.5))
p <- p + theme_bw()
p <- p + theme(axis.title.x = element_text(size = 18))
p <- p + theme(axis.title.y = element_text(size = 18, vjust = 1.5))
p <- p + theme(axis.text.x = element_text(size = 14))
p <- p + theme(axis.text.y = element_text(size = 14))

# Save the plot
pdf(otpfullname, family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
print(p)
dev.off()
embed_fonts(otpfullname, outfile = otpfullname)
