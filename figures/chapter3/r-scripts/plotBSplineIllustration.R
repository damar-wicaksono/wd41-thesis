#
# title     : plotBSplineIllustration.R
# purpose   : Create an illustration plot of the B-splines, 3-rd degree
# author    : WD41, LRS/EPFL/PSI
# date      : September 2017
#
# Custom function -------------------------------------------------------------
spline_function <- function(x, knots, i, p)
{
    # number of basis functions
    if (p == 0)
    {
        if (knots[i] <= x && x < knots[i+1])
        {
            return(1)
        } else {
            return(0)
        }
    }
    else
    {
        y <- alpha(x, knots, i, p) * spline_function(x, knots, i, p - 1) +
            (1 - alpha(x, knots, i + 1, p)) * 
            spline_function(x, knots, i + 1, p - 1)
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

# Global Variables ------------------------------------------------------------
otpfullname <- c("./figures/plotBSplineIllustration.pdf")

# Graphic Parameters
fig_size <- c(10, 5)                    # width, height
margin   <- c(4, 6.5, 2.2, 1) + 0.1     # canvas margin (bot, left, top, right)
cex_axis <- 2.0     # Axis marker size
cex_lab  <- 2.0     # Axis label size
cex_main <- 3.0     # Main title size
tck_len  <- -0.35   # Tick length
cex_text <- 1.5     # Text annotation size
cex_lab_shift <- 1.25   # Shift of the axis label from the axis

# Set up knots ----------------------------------------------------------------
pdf(otpfullname, family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0),
    bty = "n")
# Set up knots
knots_interior <- seq(0,1,length.out = 12)
knots <- c(0, 0, 0, knots_interior, 1.0, 1.0, 1.0)

# Set plotting canvas
plot(-1, -1, xlab = "", ylab = "",
     type = "n", axes = FALSE, ylim = c(0, 1), xlim = c(0, 1))
# Set Axis, Ticks and Labels
# x-axis
axis(side = 1, lwd = 1.5,
     at = c(0, 0.2, 0.4, 0.6, 0.8, 1.0), 
     mgp = c(3, cex_lab_shift, 0), 
     tcl = tck_len, cex.axis = cex_axis)
title(xlab = "t", mgp = c(2.5, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(0, 0.2, 0.4, 0.6, 0.8, 1.0), 
     mgp = c(2, cex_lab_shift, 0), 
     tcl = tck_len, 
     cex.axis = cex_axis)
title(ylab = "B(t)", mgp = c(4.0, 0, 0), cex.lab = cex_lab)
# Plot each B-Spline function
for (i in 1:14)
{
    x_tests <- c()
    for (j in seq(0,0.999,length.out = 1000))
    {
        x_tests <- c(x_tests, spline_function(j, knots, i, 3))
    }
    lines(seq(0,1,length.out = 1000), x_tests)    
}
# Plot vertical lines indicating knots
for (i in 2:11)
{
    abline(v=knots_interior[i], lty = 5, lwd = 0.5)
}
abline(v=knots_interior[1], lty = 5, lwd = 1)
abline(v=knots_interior[12], lty = 5, lwd = 1)
# Text Annotation
text(0.03, 0.8, expression(B[1]), cex = cex_text)
text(0.04, 0.65, expression(B[2]), cex = cex_text)
text(0.10, 0.65, expression(B[3]), cex = cex_text)
expression(substitute("B[",i,"]"))
for (i in 4:11)
{
    text(knots_interior[i-1], 0.72, bquote(B[.(i)]), cex = cex_text)
}
text(0.9, 0.65, expression(B[12]), cex = cex_text)
text(0.96, 0.65, expression(B[13]), cex = cex_text)
text(0.97, 0.8, expression(B[14]), cex = cex_text)

dev.off()
