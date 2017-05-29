#' Compute the conditional standard deviation of a multivariate normal dist.
#' 
#' Given the select index of the observed data and the full covariance matrix
#' 
#' @param index_obs the index of the observed variables
#' @param covar the full covariance matrix
#' @return a vector of conditional standard deviation of the non-observed 
#'         variables
#' 
calcStdDevStar <- function(index_obs, covar)
{
    
    covar_star <- calcCovarStar(index_obs, covar)
    
    return(sqrt(diag(covar_star)))
}
