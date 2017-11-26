#' Compute Calibration Score
#'
#' @param exp_val Experimental value
#' @param ref_val Reference value
#' @param lb_val  Lower bound value
#' @param ub_val  Upper bound value
cal_score <- function(exp_val, ref_val, lb_val, ub_val)
{
  if (exp_val < lb_val | exp_val > ub_val)
  {
    # Outside the interval
    cal <- 0.
  } else if (exp_val < ref_val)
  {
    # Between LB and Ref. Value.
    cal <- (exp_val - lb_val) / (ref_val - lb_val)
  } else if (exp_val > ref_val)
  {
    # Between Ref. Value and UB
    cal <- (ub_val - exp_val) / (ub_val - ref_val)
  }
  return(cal)
}