#' Create a convergence slope as a new column in the convergence dataframe
#' 
#' @param df_convergence A character vector. The filename of file being copied
#' @param param_names A character vector. Complete directory name of the target 
#' @param estimators Flag to remove file after copying. Default to TRUE.
#'
calcConvergenceSlope <- function(df_convergence, param_names, estimators)
{
    model <- list()

    # number of model parameters
    num_params <- length(param_names)

        # Evaluate a linear model based on Regression through the Origin
    for (i in 1:num_params) {
        df <- subset(df_convergence,
                     parameter == param_names[i] & estimator == estimators[1])
        x <- 1/sqrt(df$samples)
        y <- df$ci_length
        model[[i]] <- lm(y ~ 0 + x)
        model[[i]]
    }
    # Assign slope to the convergence dataframe
    for (i in 1:num_params)
    {
        df_convergence$slope[df_convergence$parameter == param_names[i] &
                                 df_convergence$estimator == estimators[1]] <- model[[i]]$coefficients[1]
    }

    for (i in 1:num_params)
    {
        df <- subset(df_convergence,
                     parameter == param_names[i] & estimator == estimators[2])
        x <- 1/sqrt(df$samples)
        y <- df$ci_length
        model[[i]] <- lm(y ~ 0 + x)
        model[[i]]
    }

    # Assign slope to the convergence dataframe
    for (i in 1:num_params)
    {
        df_convergence$slope[df_convergence$parameter == param_names[i] &
                                 df_convergence$estimator == estimators[2]] <- model[[i]]$coefficients[1]
    }

    return(df_convergence)
}
