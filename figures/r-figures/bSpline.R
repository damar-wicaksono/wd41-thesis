spline_function <- function(x, knots, i, p)
{
    # number of basis functions
    if (p == 0)
    {
        print(paste(knots[i], x, knots[i+1]))
        if (knots[i] <= x && x < knots[i+1])
        {
            #print(paste(knots[i], x, knots[i+1]))
            return(1)
        } else {
            return(0)
        }
    }
    
    else
    {
        y <- alpha(x, knots, i, p) * spline_function(x, knots, i, p - 1) +
            (1 - alpha(x, knots, i+1, p)) * spline_function(x, knots, i+1, p - 1)
        print(paste(x, i, p, y, alpha(x, knots, i, p)))
        return(y) 
    }
}

alpha <- function(x, knots, i, p) {
    if (knots[i] == knots[i+p])
    {
        return(0)
    } else
    {
        return((x - knots[i]) / (knots[i+p] - knots[i]))
    }
}


# Set up knots
png("bSpline.png", width=22, height=11, units="cm", res=600, bg = "transparent")
par(mfrow=c(1, 2), mar=c(4,4,1,1) + 0.1, las = 1, oma = c(0,0,0,0) + 0.1)
knots_interior <- seq(0,1,length.out = 11)
knots <- c(0, knots_interior, 1.0)
x_tests <- c()
for (j in seq(0,0.999,length.out = 1000)) {
    x_tests <- c(x_tests, spline_function(j, knots, 1, 1))
}
plot(seq(0,1,length.out = 1000), x_tests, type = "l",
     xlab = "",
     ylab = "B(t)",
     xlim = c(0,1),
     ylim = c(0,1))
title(xlab = "t", mgp = c(1.5,1,0))
for (i in 2:11) {
    x_tests <- c()
    for (j in seq(0,0.999,length.out = 1000)) {
        x_tests <- c(x_tests, spline_function(j, knots, i, 1))
    }
    lines(seq(0,1,length.out = 1000), x_tests)    
}
for (i in 1:11)
{
    abline(v=knots_interior, lty = 5)
}

png("bSpline.png", width=22, height=11, units="cm", res=600, bg = "transparent")
par(mfrow=c(1, 2), mar=c(4,4,1,1) + 0.1, las = 1, oma = c(0,0,0,0) + 0.1)
# Set up knots
knots_interior <- seq(0,1,length.out = 11)
knots <- c(0, 0, 0, knots_interior, 1.0, 1.0, 1.0)
x_tests <- c()
for (j in seq(0,0.999,length.out = 1000)) {
    x_tests <- c(x_tests, spline_function(j, knots, 1, 3))
}
plot(seq(0,1,length.out = 1000), x_tests, type = "l",
     xlab = "",
     ylab = "B(t)",
     xlim = c(0,1),
     ylim = c(0,1))
title(xlab = "t", mgp = c(1.5,1,0))
for (i in 2:13) {
    x_tests <- c()
    for (j in seq(0,0.999,length.out = 1000)) {
        x_tests <- c(x_tests, spline_function(j, knots, i, 3))
    }
    lines(seq(0,1,length.out = 1000), x_tests)    
}
for (i in 1:11)
{
    abline(v=knots_interior, lty = 5)
}

# Set up knots
knots_interior <-  c(seq(0, 0.5, length.out = 5), 
                     seq(0.6, 1.0, length.out = 8))
knots <- c(0, 0, 0, knots_interior, 1.0, 1.0, 1.0)
x_tests <- c()
for (j in seq(0,0.999,length.out = 1000)) {
    x_tests <- c(x_tests, spline_function(j, knots, 1, 3))
}
plot(seq(0,1,length.out = 1000), x_tests, type = "l",
     xlab = "t",
     ylab = "B(t)",
     xlim = c(0,1),
     ylim = c(0,1))
title(xlab = "t", mgp = c(1.5,1,0))
for (i in 2:15) {
    x_tests <- c()
    for (j in seq(0,0.999,length.out = 1000)) {
        x_tests <- c(x_tests, spline_function(j, knots, i, 3))
    }
    lines(seq(0,1,length.out = 1000), x_tests)    
}
for (i in 1:13)
{
    abline(v=knots_interior[i+1])
}

dev.off()