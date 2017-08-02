#' Create a plot of perturbing a mean function with a given PC
#' 
#' @param pca_fd fd object. Functional data object with PCA results
#' @param harmonic integer. The harmonics to be plotted (the principal comp.)
#' @result ggplot2 object.
plotPCPerturbation <- function(pca_fd, harmonic)
{
    # Take the functional object argument
    unif_time <- as.numeric(pca_fd$meanfd$fdnames$time)
    harmonics <- eval.fd(unif_time, pca_fd$harmonics[harmonic])

    # Create a dataframe containing the mean, the lower, and upper bound
    # Mean function
    mean_function <- eval.fd(unif_time, pca_fd$meanfd)
    df_fd <- data.frame(time = unif_time, value = mean_function, 
                        type = rep("mean", length(mean_function)))
    names(df_fd) <- c("time", "value", "type")
    
    value <- eval.fd(unif_time, pca_fd$harmonics[harmonic])
    dev_function <- 2 * sd(pca_fd$scores[, harmonic]) * value
    
    # Lower
    df_fd1 <- data.frame(time = unif_time, 
                         value = mean_function - dev_function,
                         type = rep("lower", length(dev_function)))
    names(df_fd1) <- c("time", "value", "type")
    df_fd <- rbind(df_fd, df_fd1)
    
    # Upper
    df_fd1 <- data.frame(time = unif_time, 
                         value = mean_function + dev_function, 
                         type = rep("upper", length(dev_function)))
    names(df_fd1) <- c("time", "value", "type")
    df_fd <- rbind(df_fd, df_fd1)
    
    # Plot the Effect of fPC perturbation on the mean function
    p <- ggplot(df_fd, aes(x = time, y = value, shape = type))
#        geom_point(size = 0)

    # Mean Function
    p <- p + geom_line(data = subset(df_fd, type == "mean"),
                       aes(x = time, y = value),
                       linetype = "solid",
                       colour = "black",
                       size = 0.75)

    # Positive Perturbation (we use select points not to overcrowd plot symbol)
    select_points <- seq(0, length(unif_time), by = 200)
    p <- p + geom_point(data = subset(df_fd, type == "upper")[select_points, ],
                        aes(x = time, y = value),
                        colour = "black",
                        shape = 3,
                        size = 3)

    # Negative Perturbation
    p <- p + geom_point(data = subset(df_fd, type == "lower")[select_points, ],
                        aes(x = time, y = value),
                        colour = "black",
                        shape = 95,
                        size = 3)

    # Set the theme, generic font size, and axis labels
    p <- p + theme_bw(base_size = 14)

    # Set the plotting canvas
    p <- p + theme(panel.grid.major = element_line(size = 0.5, color = "grey"),
                   text = element_text(size = 14))

    # Set the setting for x axis
    p <- p + theme(axis.ticks.x = element_line(size=1),
                   axis.text.x = element_text(size = 14),
                   axis.title.x = element_text(size = 16))

    # Set the setting for y axis
    p <- p + theme(axis.ticks.y = element_line(size=1),
                   axis.text.y = element_text(size = 14),
                   axis.title.y = element_text(vjust = 1.2, size = 16))
    
    p <- p + theme(legend.position = "")

    return(p)
}
