spline_function <- function(t, knots, i, p)
{
    if (p == 0)
    {
        if (knots[i] <= t && t < knots[i+1])
        {
            return(1)
        } else {
            return(0)
        }
    }
    
    else
    {
        y <- alpha(t, knots, i, p) * spline_function(t, knots, i, p - 1) +
            (1 - alpha(t, knots, i+1, p)) * spline_function(t, knots, i+1, p - 1)
        return(y) 
    }
}
