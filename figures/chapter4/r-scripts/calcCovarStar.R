#' Compute the conditional covariance matrix of a multivariate normal dist.
#' 
#' Given the select index of the observed data and the full covariance matrix
#' 
#' @param index_obs the index of the observed variables
#' @param covar the full covariance matrix
#' @return conditional variance-covariance matrix
#' 
calcCovarStar <- function(index_obs, covar)
{
    # Set index
    index_all <- seq(1, nrow(covar))            # All variables
    index_int <- setdiff(index_all, index_obs)  # Intersect, variables not obs.
    
    # Slice covar to construct block matrix C
    cc <- covar[index_int, index_obs]
    # Slice covar to construct block matrix B
    bb <- covar[index_obs, index_obs]
    # Slice covar to construct block matrix A
    aa <- covar[index_int, index_int]
    covar_star <- aa - cc %*% solve(bb) %*% t(cc)
    
    return(covar_star)
}
