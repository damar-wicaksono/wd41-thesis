#' Compute Calibration Score
#'
#' Unlike the original paper, it is assumed here that the reference interval
#' does not represent complete (rectangular) possibilistic ignorance.
#' Instead, coming from the prior distribution, the reference itself is a
#' triangle with nominal parameter value on the center.
#'
#' @param lb_ref  Reference lower bound value
#' @param ub_ref  Reference upper bound value
#' @param lb_val  Lower bound value
#' @param ub_val  Upper bound value
inf_score <- function(lb_ref, ub_ref, lb_val, ub_val)
{
  inf <- ((ub_ref - lb_ref) - (ub_val - lb_val)) / (ub_ref - lb_ref)

  return(inf)
}