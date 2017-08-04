#
# title     : plotExplainedVariance.R
# purpose   : Script to create an illustration plot of the proportion of 
#           : explained variance contained in each principal component
#           : for all output types
# author    : WD41, LRS/EPFL/PSI
# date      : August 2017
#
# Load the Required Library ---------------------------------------------------
library(fda)

# Global variables ------------------------------------------------------------
# Output filenames (three separate pdf files)
otpfullnames <- c("./figures/plotExplainedVarianceTC4.pdf",
                  "./figures/plotExplainedVarianceDPMid.pdf",
                  "./figures/plotExplainedVarianceCO.pdf")

# Input filename
pca_fd_fullnames <- c(
    "../../../analysis/sobol/results/tc_regfd_pcafd-tc_4.Rds",
    "../../../postpro/result-qoi/dp_mid/rds_fd/febaTrans216Ext-febaVars12Influential-sobol_2000_12-dp_mid-fpc.Rds",
    "../../../postpro/result-qoi/co/rds_fd/febaTrans216Ext-febaVars12Influential-sobol_2000_12-co-fpc.Rds")

# Graphic Parameters
fig_size <- c(4, 4)             # width, height

# Loop over all output types --------------------------------------------------
for (i in 1:3)
{
    # Read Data
    pca_fd <- readRDS(pca_fd_fullnames[i])
    
    # Compute the first 10 principal components explained variance proportion
    pca_10_varprop <- pca_fd$values[1:10] / sum(pca_fd$values)
    pca_10_varprop <- data.frame(pca = as.factor(seq(1, 10)),
                                 varprop = pca_10_varprop * 100)
    
    # Make the plot
    p <- ggplot(pca_10_varprop) + 
        geom_bar(aes(x = pca, y = varprop, group = 1),
                 fill = "gray15",
                 stat="identity")
    p <- p + geom_point(aes(x = pca, y = cumsum(varprop), group = 1), size = 3) 
    p <- p + geom_line(aes(x = pca, y = cumsum(varprop), group = 1))
    p <- p + geom_hline(yintercept = sum(pca_10_varprop$varprop[1:2]),
                        size=0.25)
    
    # Set plotting canvas
    p <- p + labs(x = "fPC", y = "Explained Variance [%]")
    p <- p + theme_bw()
    p <- p + annotate("text", x = 7, y = 87.5,
                      label = paste0(
                          round(sum(pca_10_varprop$varprop[1:2]), 0),
                          "% Cumulative Variance by first 2 fPC"),
                      size = 3)
    p <- p + theme(axis.title.x = element_text(size = 18))
    p <- p + theme(axis.title.y = element_text(size = 18, vjust = 1.5))
    p <- p + theme(axis.text.x = element_text(size = 14))
    p <- p + theme(axis.text.y = element_text(size = 14))
    
    # Save the plots
    pdf(otpfullnames[i], family = "CM Roman",
        width = fig_size[1], height = fig_size[2])
    print(p)
    dev.off()
    embed_fonts(otpfullnames[i], outfile=otpfullnames[i])
}
