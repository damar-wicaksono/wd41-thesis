#' Create a plot of a Principal Component (aka Harmonic)
#' 
#' @param pca_fd fd object. Functional data object with PCA results
#' @param harmonic integer. The harmonics to be plotted (the principal comp.)
#' @result ggplot2 object.
plotHarmonic <- function(pca_fd, harmonic)
{
    # Take the functional data object argument
    unif_time <- as.numeric(pca_fd$meanfd$fdnames$time)
    harmonics <- eval.fd(
        unif_time, 
        pca_fd$harmonics[harmonic]*sqrt(pca_fd$values[harmonic]))
    # Create a new dataframe for plotting with ggplot2
    df_harmonics <- data.frame(time = unif_time, value = harmonics)
    names(df_harmonics) <- c("time", "value")
    
    # Plot the harmonic
    p <- ggplot(df_harmonics, aes(x = time, y = value)) + 
        geom_line(size = 0.5)

    # Set theme
    p <- p + theme_bw(base_size = 16)

    # Set the plotting canvas
    p <- p + theme(panel.grid.major = element_line(size = 0.5, color = "grey"),
                   text = element_text(size = 14))
    
    # Set axis ticks size
    p <- p + theme(axis.ticks.y = element_line(size = 1),
                   axis.ticks.x = element_line(size = 1),
                   axis.text.x = element_text(size = 14),
                   axis.text.y = element_text(size = 14),
                   axis.title.y = element_text(vjust = 1.2, size = 16),
                   axis.title.x = element_text(size = 16))

    return(p)
}
