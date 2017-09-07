#' Compile the GP validation runs (computing error) for all possible options
#' 
#'
#' @param output_type The output type ("tc" | "dp_smoothed" | "co")
#' @param data_path The path where the error Rds files are located
#' @param feba_case The feba case name, base input deck (without extension)
#' @param param_file The list of parameters filename (without extension)
#' @param n_params Number of parameters
#' @return A dataframe with all the computed validation metric for different
#'     metamodel construction options (different covariance, desing types, 
#'     number of samples, and replications)
compileGPError <- function(output_type, data_path, feba_case, param_file, n_params)
{
    cov_types <- c("gauss", "matern3_2", "matern5_2", "powexp")
    doe_types <- c("srs", "lhs", "lhs_opt", "sobol")
    n_samples <- c(120, 240, 480, 960)
    n_reps <- 5 # number of replications
    
    # Compile all data
    gp_err <- data.frame(error = c(),
                         type = c(),
                         cov_type = c(),
                         n_train = c(),
                         doe_name = c(),
                         n_rep = c())
    
    # Loop over all cases
    for (n_rep in 1:n_reps)
    {
        for (cov_type in cov_types)
        {
            for (doe_type in doe_types)
            {
                for (n_sample in n_samples)
                {
                    err_filename <- paste0(feba_case, "-", 
                                           param_file, "-", 
                                           doe_type, "_", 
                                           n_sample, "_", 
                                           n_params, "_", 
                                           n_rep, "-", 
                                           output_type, "-", 
                                           "pca-gp", "-", 
                                           cov_type, "-er.Rds")
                    err_fullname <- paste0(data_path, "/", err_filename)
                    err_temp <- readRDS(err_fullname)
                    err_temp$n_rep <- n_rep
                    gp_err <- rbind(gp_err, err_temp) 
                }
            }
        }
    }
    return(gp_err)
}
