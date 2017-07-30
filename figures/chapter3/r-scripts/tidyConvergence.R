#' Create a tidy dataframe of estimator convergence
#'
tidyConvergence <- function(bootstrap_df, num_samples, estimator, 
                            index = "main") 
{
    # infer the model parameters name and loop over them
    params <- names(bootstrap_df)
    num_params <- ncol(bootstrap_df)
    
    # Calculate the 95% confidence interval length
    ci_length <- c()
    
    for (i in 1:num_params) {
        bottom <- quantile(bootstrap_df[, i], 2.5/100)
        top <- quantile(bootstrap_df[, i], 97.5/100)
        ci_length <- rbind(ci_length, top-bottom)
    }
    
    convergence_df <- data.frame(samples = rep(num_samples, num_params), 
                                 ci_length = unname(ci_length),
                                 parameter = params,
                                 index = index,
                                 estimator = estimator)
    
    return(convergence_df)
}