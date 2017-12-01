#
# title     : plotIllustrateBias.R
# purpose   : R script to create an illustration of a Bias model.
# author    : WD41, LRS/EPFL/PSI
# date      : Sept. 2017
#
# Custom Function -------------------------------------------------------------
y_model <- function(x, theta)
{
  return(0.5 * x^2 + theta)
}
y_model_bias <- function(x, theta)
{
  return(0.35 * x^1.85 - 0.5 + theta)
}

# Global variables ------------------------------------------------------------
otpfullnames <- c("./figures/plotIllustrateBias_1.pdf",
                  "./figures/plotIllustrateBias_2.pdf")

# Graphic Parameters
fig_size <- c(7, 7)                     # width, height
margin <- c(5.25, 6.25, 2.2, 1) + 0.1   # canvas margin (bot, left, top, right)
cex_axis <- 2.5     # Axis marker size
cex_lab  <- 3.0     # Axis label size
cex_main <- 3.0     # Main title size
cex_ann  <- 2.0     # Annotation text
tck_len  <- -0.35   # Tick length
leg_cex <- 2.0      # Legend size
cex_lab_shift <- 1.25   # Shift of the axis label from the axis
cex_ttl_shift <- 3.25   # Shift of the axis title from the axis

# Set up case -----------------------------------------------------------------
x_calib <- c(0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0)
x_valid <- c(3.5, 4.0, 4.5)
y_calib <- y_model(x_calib, 1)
y_valid <- y_model(x_valid, 1)
fit <- nls(y ~ y_model(x, theta), data=data.frame(y = y_calib, x = x_calib),
           start = list(theta=0.0), algorithm = "port", lower = 0.0, upper = 2.0)
fit <- nls(y ~ y_model_bias(x, theta),
           data=data.frame(y = y_calib, x = x_calib),
           algorithm = "port", start = list(theta=0.0),
           lower = 0.0, upper = 5.0)
fit <- nls(y ~ y_model_bias(x, theta),
           data=data.frame(y = y_calib-0.5, x = x_calib),
           algorithm = "port", start = list(theta=0.0),
           lower = 0.0, upper = 5.0)
fit <- nls(y ~ y_model_bias(x, theta),
           data=data.frame(y = y_calib+0.5, x = x_calib),
           algorithm = "port", start = list(theta=0.0),
           lower = 0.0, upper = 5.0)

# Make the plot, unbiased case ------------------------------------------------
pdf(otpfullnames[1], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")
plot(0, 0, type = "n",
     xlim = c(0.0, 4.5), ylim = c(-2.0, 12),
     axes = TRUE,
     ylab = "", xlab = "",
     xaxt = "n", yaxt = "n")

# Add points for the calibration data
points(x_calib, y_calib, pch = 4, lwd = 2, cex = 1.5)

# Add points for the prediction
points(x_valid, y_valid, pch = 1, lwd = 2, cex = 1.5)

# Add error bar
for (i in 1:length(x_calib))
{
  segments(x_calib[i], y_calib[i] - 0.5, x_calib[i], y_calib[i] + 0.5,
           lwd = 1.5)
}
for (i in 1:length(x_valid))
{
  segments(x_valid[i], y_valid[i] - 0.5, x_valid[i], y_valid[i] + 0.5,
           lwd = 1.5)
}

# Add simulator predictions
lines(seq(0.0, 3.0, by = 0.1), y_model(seq(0.0, 3.0, by = 0.1), -2.0), lwd = 2)
lines(seq(0.0, 3.0, by = 0.1), y_model(seq(0.0, 3.0, by = 0.1), +3.0), lwd = 2)
for (i in seq(-2, 3.0, by = 0.25))
{
  lines(seq(0.0, 3.0, by = 0.1), y_model(seq(0.0, 3.0, by = 0.1), i),
        col = rgb(0, 0, 0, 0.5))
}
# Calibrated model
for (i in seq(0.5, 1.5, by = 0.25))
{
  lines(seq(0.0, 4.5, by = 0.1), y_model(seq(0.0, 4.5, by = 0.1), i),
        lty = 3,
        lwd = 2.0,
        col = rgb(0, 0, 0, 1.0))
}

# Set Axis, Ticks and Labels
# x-axis
title(xlab = expression(x[c]), mgp = c(cex_ttl_shift - 1.5, 0, 0),
      cex.lab = cex_lab)
# y-axis
title(ylab = "y", mgp = c(cex_ttl_shift - 1.5, 0, 0), cex.lab = cex_lab)

# Save the plot
dev.off()
embed_fonts(otpfullnames[1], outfile = otpfullnames[1])

# Make the plot, biased case --------------------------------------------------
pdf(otpfullnames[2], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0), bty = "l")
plot(0, 0, type = "n",
     xlim = c(0.0, 4.5), ylim = c(-2.0, 12.0),
     axes = TRUE,
     ylab = "", xlab = "",
     xaxt = "n", yaxt = "n")

# Add points for the calibration data
points(x_calib, y_calib, pch = 4, lwd = 2, cex = 1.5)

# Add points for the prediction
points(x_valid, y_valid, pch = 1, lwd = 2, cex = 1.5)

# Add error bar
for (i in 1:length(x_calib))
{
  segments(x_calib[i], y_calib[i] - 0.5, x_calib[i], y_calib[i] + 0.5,
           lwd = 1.5)
}
for (i in 1:length(x_valid))
{
  segments(x_valid[i], y_valid[i] - 0.5, x_valid[i], y_valid[i] + 0.5,
           lwd = 1.5)
}

# Add simulator predictions
lines(seq(0.0, 3.0, by = 0.1), y_model_bias(seq(0.0, 3.0, by = 0.1), -2.0),
      lwd = 2)
lines(seq(0.0, 3.0, by = 0.1), y_model_bias(seq(0.0, 3.0, by = 0.1), +3.0),
      lwd = 2)
for (i in seq(-2, 3.0, by = 0.25))
{
  lines(seq(0.0, 3.0, by = 0.1), y_model_bias(seq(0.0, 3.0, by = 0.1), i),
        col = rgb(0, 0, 0, 0.5))
}
# Calibrated model
for (i in seq(1.621, 2.621, by = 0.25))
{
  lines(seq(0.0, 4.5, by = 0.1), y_model_bias(seq(0.0, 4.5, by = 0.1), i),
        lty = 3,
        lwd = 2.0,
        col = rgb(0, 0, 0, 1.0))
}

# Set Axis, Ticks and Labels
# x-axis
title(xlab = expression(x[c]), mgp = c(cex_ttl_shift - 1.5, 0, 0),
      cex.lab = cex_lab)
# y-axis
title(ylab = "y", mgp = c(cex_ttl_shift - 1.5, 0, 0), cex.lab = cex_lab)

# Save the plot
dev.off()
embed_fonts(otpfullnames[2], outfile = otpfullnames[2])