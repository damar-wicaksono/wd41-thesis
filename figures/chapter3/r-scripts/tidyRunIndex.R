#' Create a tidy dataframe out of runindices dataframe
#' 
tidyRunIndex <- function(filename_1, estimator_1, filename_2, estimator_2, 
                         n_min = 100)
{
    # Read the 1st running index file, postprocessed by Python script
    runindices_filename <- filename_1
    df_runindices <- read.csv(runindices_filename, header = FALSE)
    # Infer the number of parameters and samples from the indices dataframe
    n <- dim(df_runindices)[1]
    k <- dim(df_runindices)[2]
    
    # Create a tidy data out of runindices dataframe
    col_names <- c()
    for (i in 1:k) {
        col_names[i] <- paste("S", i, sep = "")
    }

    df_runindex <- data.frame(value = df_runindices$V1,
                              index = col_names[1], 
                              samples = seq(n_min, n + n_min - 1), 
                              estimator = estimator_1)
    
    for (i in 2:k){
        df_runindex <- rbind(df_runindex, 
                             data.frame(value = df_runindices[, i], 
                                        index = col_names[i], 
                                        samples = seq(n_min, n + n_min - 1), 
                                        estimator = estimator_1))
    }
    
    # Read the 2nd running index file, postprocessed by Python script
    runindices_filename <- filename_2
    df_runindices <- read.csv(runindices_filename, header = FALSE)
    
    for (i in 1:k){
        df_runindex <- rbind(df_runindex, 
                             data.frame(value = df_runindices[, i], 
                                        index = col_names[i], 
                                        samples = seq(n_min, n + n_min - 1), 
                                        estimator = estimator_2))
    }
    
    return(df_runindex)
}