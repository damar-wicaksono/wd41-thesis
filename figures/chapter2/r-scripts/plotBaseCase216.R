#
# title     : plotTraceUQPriorTC.R
# purpose   : R script to plot the 95% uncertainty band of the prior
#           : Clad temperature (TC) predictions
# author    : WD41, LRS/EPFL/PSI
# date      : Dec. 2017
#
# Global variables ------------------------------------------------------------
set.seed(23890)
n <- 50 # number of selected realizations for illustration of dispersion
runs <- sample(seq(1,1000), n)
n_sub <- 10  # Sub sample points (each point would make the file too large)

# Input filenames
rds_fullname <- "F:/wd41-thesis/results-compiled/srs/febaTrans216-febaVars12Influential-srs_1000_12.Rds"
rds_dp_fullname <- "F:/wd41-thesis/results-compiled/srs/febaTrans216-febaVars12Influential-srs_1000_12-dp_smoothed.Rds"

# Output filenames
otpfullnames <- c("./figures/plotBaseCase216TC.pdf",
                  "./figures/plotBaseCase216DP.pdf",
                  "./figures/plotBaseCase216CO.pdf")

# Graphic Parameters
fig_size <- c(5., 5.)                 # width, height
margin <- c(4.5, 5.5, 2.2, 1) + 0.1   # canvas margin (bot, left, top, right)
cex_axis <- 1.5         # Axis marker size
cex_lab  <- 2.0         # Axis label size
cex_main <- 2.5         # Main title size
tck_len  <- -0.35       # Tick length
cex_lab_shift <- 1.0    # Shift of the axis label from the axis

# Read the data ---------------------------------------------------------------
trc_run_df <- readRDS(rds_fullname)
trc_run_dp_df <- readRDS(rds_dp_fullname)
n_sub <- 10
t_idx <- seq(1, length(trc_run_df$time), n_sub)

# Make the plot 1 -------------------------------------------------------------
pdf(otpfullnames[1], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0),
    bty = "n")
# Set plotting canvas
plot(0, 0, xlim = c(0, 400), ylim = c(400, 1400), type = "n",
     yaxt = "n",
     xaxt = "n",
     xlab = "",
     ylab = "")

# Plot the reflood curve at the middle
for(i in 1:n) lines(trc_run_df$time[t_idx],
                    trc_run_df$replicates[t_idx,runs[i],5],
                    col = rgb(0, 0, 0, 0.25))
lines(trc_run_df$time[t_idx], trc_run_df$nominal[t_idx,5], lwd  = 2)
points(trc_run_df$exp_data[[1]][,1], trc_run_df$exp_data[[1]][,6] + 273.15,
       pch = 4, lwd = 2)

# x-axis
axis(side = 1, lwd = 1.5,
     at = c(0, 200, 400),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len, cex.axis = cex_axis)
title(xlab = "Time [s]", mgp = c(2.5, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(400, 900, 1400),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len,
     cex.axis = cex_axis)
title(ylab = "Clad Temperature [K]", mgp = c(4, 0, 0), cex.lab = cex_lab)

# Close the device
dev.off()
embed_fonts(otpfullnames[1], outfile = otpfullnames[1])

# Make the plot 2 -------------------------------------------------------------
pdf(otpfullnames[2], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0),
    bty = "n")
# Set plotting canvas
plot(0, 0, xlim = c(0, 510), ylim = c(0, 0.1), type = "n",
     yaxt = "n",
     xaxt = "n",
     xlab = "",
     ylab = "")

# Plot the reflood curve at the middle
for(i in 1:n) lines(trc_run_dp_df$time[t_idx],
                    trc_run_dp_df$replicates[t_idx,runs[i],2]/1e5,
                    col = rgb(0, 0, 0, 0.25))
lines(trc_run_dp_df$time[t_idx], trc_run_dp_df$nominal[t_idx,2]/1e5,
      lwd  = 2)
points(trc_run_df$exp_data[[2]][,1], trc_run_df$exp_data[[2]][,3],
       pch = 4, lwd = 2)

# x-axis
axis(side = 1, lwd = 1.5,
     at = c(0, 250, 500),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len, cex.axis = cex_axis)
title(xlab = "Time [s]", mgp = c(2.5, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(0, 0.05, 0.1),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len,
     cex.axis = cex_axis)
title(ylab = "Pressure drop [bar]", mgp = c(4, 0, 0), cex.lab = cex_lab)

# Close the device
dev.off()
embed_fonts(otpfullnames[2], outfile = otpfullnames[2])

# Make the plot 3 -------------------------------------------------------------
pdf(otpfullnames[3], family = "CM Roman",
    width = fig_size[1], height = fig_size[2])
par(mfrow = c(1, 1), mar = margin, las = 1, oma = c(0, 0, 0, 0),
    bty = "n")
# Set plotting canvas
plot(0, 0, xlim = c(0, 220), ylim = c(0, 15), type = "n",
     yaxt = "n",
     xaxt = "n",
     xlab = "",
     ylab = "")

# Plot the reflood curve at the middle
for(i in 1:n) lines(trc_run_df$time[t_idx],
                    trc_run_df$replicates[t_idx,runs[i],13],
                    col = rgb(0, 0, 0, 0.25))
lines(trc_run_df$time[t_idx], trc_run_df$nominal[t_idx,13], lwd  = 2)
points(trc_run_df$exp_data[[3]][,1], trc_run_df$exp_data[[3]][,2],
       pch = 4, lwd = 2)

# x-axis
axis(side = 1, lwd = 1.5,
     at = c(0, 220),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len, cex.axis = cex_axis)
title(xlab = "Time [s]", mgp = c(2.5, 0, 0), cex.lab = cex_lab)
# y-axis
axis(side = 2, lwd = 1.5,
     at = c(0, 5, 10, 15),
     mgp = c(3, cex_lab_shift, 0),
     tcl = tck_len,
     cex.axis = cex_axis)
title(ylab = "Liquid carryover [kg]", mgp = c(4, 0, 0), cex.lab = cex_lab)

# Close the device
dev.off()
embed_fonts(otpfullnames[3], outfile = otpfullnames[3])
