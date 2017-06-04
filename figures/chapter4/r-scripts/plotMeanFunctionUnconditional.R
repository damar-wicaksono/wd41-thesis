#
# title     : plotMeanFunctionUnconditional.R
# purpose   : R script to create an illustration of the effect of using 
#           : different mean function, unconditional
# author    : WD41, LRS/EPFL/PSI
# date      : June 2017
#
# Set Random Number -----------------------------------------------------------
set.seed(234513790)

# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotMeanFunctionUnconditional_1.pdf",
                  "./figures/plotMeanFunctionUnconditional_2.pdf",
                  "./figures/plotMeanFunctionUnconditional_3.pdf")
# Graphic Parameters
fig_size <- c(5, 5)                 # width, height
margin <- c(4, 5, 2.2, 1) + 0.1     # canvas margin (bot, left, top, right)
cex_axis <- 2.5     # Axis marker size
cex_lab  <- 3.0     # Axis label size
cex_main <- 3.0     # Main title size
tck_len  <- -0.35   # Tick length
cex_lab_shift <- 1.25   # Shift of the axis label from the axis

# Construct the illustrative case ---------------------------------------------
D <- 50
x <- seq(0, 8, length.out = D)
n_sim <- 5 # Number of simulated draws

# Define constant mean case ---------------------------------------------------
km_model_constant <- km(~0, 
                        design = data.frame(x = x), 
                        response = rep(0, D),
                        covtype = "gauss", 
                        coef.trend = c(10.0),
                        coef.cov = c(1.0), 
                        coef.var = 100, 
                        nugget = 1e-4)

# Conditional draws
y_sim_constant <- simulate(km_model_constant, nsim = n_sim, 
                           newdata = data.frame(x = x), cond = F)

# Define linear mean case -----------------------------------------------------
km_model_linear <- km(~., 
                      design = data.frame(x = x), 
                      response = rep(3.0, D), 
                      covtype = "gauss", 
                      coef.trend = c(1, 4),
                      coef.cov = c(1.0), 
                      coef.var = 100, 
                      nugget = 1e-4)

# Conditional draws
y_sim_linear <- simulate(km_model_linear, nsim = n_sim, 
                         newdata = data.frame(x = x), cond = F)

# Define quadratic case -------------------------------------------------------
km_model_quadratic <- km(~1 + x + I(x^2), 
                         design = data.frame(x = x), 
                         response = rep(0.0, D), 
                         covtype = "gauss", 
                         coef.trend = c(1, 2, -2),
                         coef.cov = c(1.0), 
                         coef.var = 100, 
                         nugget = 1e-4)

# Conditional draws
y_sim_quadratic <- simulate(km_model_quadratic, nsim = n_sim, 
                            newdata = data.frame(x = x), cond = F)

# Make the plots --------------------------------------------------------------
# 1st Plot, constant mean
pdf(otpfullnames[1], family = "CM Roman", 
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1,1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

plot(x, rep(10.0, D), type = "l", lwd = 2, lty = 3, 
     xlim  = c(0, 8), ylim = c(-50, 50),
     xlab = "", xaxt = "n",
     ylab = "", yaxt = "n")  # The mean
for (i in 1:n_sim) lines(x, y_sim_constant[i,], lwd = 0.5)
# Set Axis, Ticks and Labels
# x-axis
title(xlab = expression(x), mgp = c(1.5, 0, 0), cex.lab = cex_lab)
# y-axis
title(ylab = expression(y), mgp = c(1.5, 0, 0), cex.lab = cex_lab)
# Save the plot
dev.off()
embed_fonts(otpfullnames[1], outfile = otpfullnames[1])

# 2nd Plot, linear mean
pdf(otpfullnames[2], family = "CM Roman", 
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1,1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

plot(x, 1 + 4 * x, type = "l", lwd = 2, lty = 3, 
     xlim  = c(0, 8), ylim = c(-50, 50),
     xlab = "", xaxt = "n",
     ylab = "", yaxt = "n")  # The mean
for (i in 1:n_sim) lines(x, y_sim_linear[i,], lwd = 0.5)
# Set Axis, Ticks and Labels
# x-axis
title(xlab = expression(x), mgp = c(1.5, 0, 0), cex.lab = cex_lab)
# y-axis
title(ylab = expression(y), mgp = c(1.5, 0, 0), cex.lab = cex_lab)
# Save the plot
dev.off()
embed_fonts(otpfullnames[2], outfile = otpfullnames[2])

# 3rd Plot, quadratic mean
pdf(otpfullnames[3], family = "CM Roman", 
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1,1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")

plot(x, 1 + 2 * x - 2 * x^2, type = "l", lwd = 2, lty = 3,
     xlim  = c(0, 8), ylim = c(-40, 40),
     xlab = "", xaxt = "n",
     ylab = "", yaxt = "n")  # The mean
for (i in 1:n_sim) lines(x, y_sim_quadratic[i,], lwd = 0.5)
# Set Axis, Ticks and Labels
# x-axis
title(xlab = expression(x), mgp = c(1.5, 0, 0), cex.lab = cex_lab)
# y-axis
title(ylab = expression(y), mgp = c(1.5, 0, 0), cex.lab = cex_lab)
# Save the plot
dev.off()
embed_fonts(otpfullnames[3], outfile = otpfullnames[3])