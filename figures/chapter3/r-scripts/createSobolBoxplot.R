#' Create the boxplot of Sobol indices based on the bootstrap samples
#'
#' @param bootstrap_df
#' @param list_labels
#' @
createSobolBoxplot <- function(bootstrap_df)
{
    # Create a facetted boxplot based with parameter as the pivot
    # Note that the definition of the whisker has been changed by 2.5 to 97.5
    # percentiles
    p <- ggplot(bootstrap_df, aes(x = index, y = value, fill = index)) +
        stat_summary(fun.data = f, geom="boxplot", lwd=0.35, fatten=1.0) +
        facet_wrap(~ parameter, nrow = 1)
    
    # Set the theme and fill color for the boxplot
    p <- p + theme_bw(base_size = 16)
    p <- p + scale_fill_manual(values = c("white", "darkgrey"))
    p <- p + theme(strip.text.x = element_text(size = 11.0, face = "bold"),
                   strip.background = element_rect(fill = "grey", 
                                                   colour = "black"))

    # Set the axis labels
    p <- p + labs(x = "Model Parameter", y = "Index Value [-]")
    
    # Add horizontal line at 0 as a guideline
    p <- p + geom_hline(yintercept = 0, lty = 3)
    
    # Increase y-axis ticks and labels size
    p <- p + theme(axis.text.x = element_text(vjust = 1.2),
                   axis.title.x = element_text(size = 24),
                   axis.ticks.x = element_line(size = 0.75),
                   axis.text.y = element_text(size = 22),
                   axis.title.y = element_text(vjust = 1.2, size = 24))
    
    # Customize the Legend
    p <- p + theme(legend.position = "bottom",
                   legend.text = element_text(size = 20),
                   legend.title = element_text(size = 20))
    p <- p + guides(fill = guide_legend("Sensitivity Index"))
    
    # Remove x-axis ticks
    p <- p + theme(axis.text.x = element_blank(),
                   axis.ticks.x = element_blank())
}
