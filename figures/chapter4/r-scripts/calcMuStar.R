#' Compute the conditional mean of multivariate normal distribution
#' 
#' Given the observed data, the select index of the data, the mean vector, and 
#' the covariance matrix, return the contional mean
#' 
#' @param x_obs the values of the observed variables
#' @param index_obs the index of the observed variables
#' @param mu the full mean vector
#' @param covar the full covariance matrix
#' @return a (length(mu)-length(x1)) vector of conditional mean
#' 
calcMuStar <- function(x_obs, index_cond, mu, covar) 
{
    # Set index
    index_all <- seq(1, nrow(covar))            # All variables
    index_int <- setdiff(index_all, index_obs)  # Intersect, variables not obs.
    
    # Slice covar to construct block matrix C
    cc <- rr[index_int, index_obs]
    # Slice covar to construct block matrix B
    bb <- rr[index_obs, index_obs]
    # Compute conditional mean
    mu_star <- as.matrix(mu[index_int]) + 
        cc %*% solve(bb) %*% as.matrix(x_obs - mu[index_obs])    
    
    return(mu_star)
}