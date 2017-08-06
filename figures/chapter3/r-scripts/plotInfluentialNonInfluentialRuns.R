#
# title     : plotInfluentialNonInfluentialRuns.R
# purpose   : Create an illustration of MC runs using subsets of 12 influential
#           : parameters and 15 non-influential parameters for three types of
#           : outputs: mid-assembly temperature (TC4), mid-assembly pressure 
#           : drop, and liquid carryover
# author    : WD41, LRS/EPFL/PSI
# date      : August 2017
#
# Load the Required Library ---------------------------------------------------
library(fda)
source("./r-scripts/import.R")

# Global variables ------------------------------------------------------------
set.seed(23904)
# Output filename
otpfullname <- "./figures/plotInfluentialNonInfluentialRuns.pdf"

# Input filenames
# TC and CO
trc_runs_influential_fullname <- "../../../postpro/result-compiled/febaTrans216-febaVars12Influential-lhs_1000_12.Rds"
trc_runs_noninfluential_fullname <- "../../../postpro/result-compiled/febaTrans216-febaVars15NonInfluential-lhs_1000_15.Rds"
# Smoothed Pressure Drop
trc_runs_influential_dp_fullname <- "../../../postpro/result-compiled/febaTrans216-febaVars12Influential-lhs_1000_12-dp_mid-fd.Rds"
trc_runs_noninfluential_dp_fullname <- "../../../postpro/result-compiled/febaTrans216-febaVars15NonInfluential-lhs_1000_15-dp_mid-fd.Rds"

# Graphic Parameters
fig_size <- c(14, 4)             # width, height

# Read Data and tidying up things ---------------------------------------------
trc_runs_influential <- readRDS(trc_runs_influential_fullname)
trc_runs_influential_dp <- readRDS(trc_runs_influential_dp_fullname)
trc_runs_noninfluential <- readRDS(trc_runs_noninfluential_fullname)
trc_runs_noninfluential_dp <- readRDS(trc_runs_noninfluential_dp_fullname)

# Subset time, originally it was too dense, slow tidying and huge plot file
idx_time <- seq(1, 5000, by = 25)
t_s <- trc_runs_influential$time[idx_time]
n_ts <- length(t_s) 

# Subset runs, we don't need all the 1000 runs anyway to get the idea
n_runs <- 500
idx_runs <- sample(1:1000, n_runs)

# Pre-allocate data.frame in memory
trc_runs_df <- data.frame(time = numeric(n_ts * 6 * n_runs),
                          value = numeric(n_ts * 6 * n_runs),
                          output = c(replicate(n_ts * 2 * n_runs, "tc"),
                                     replicate(n_ts * 2 * n_runs, "co"),
                                     replicate(n_ts * 2 * n_runs, "dp")),
                          influence = c(replicate(n_ts * n_runs,
                                                  "influential"),
                                        replicate(n_ts * n_runs,
                                                  "non-influential"),
                                        replicate(n_ts * n_runs,
                                                  "influential"),
                                        replicate(n_ts * n_runs,
                                                  "non-influential"),
                                        replicate(n_ts * n_runs,
                                                  "influential"),
                                        replicate(n_ts * n_runs,
                                                  "non-influential")),
                          realization = numeric(n_ts * 6 * n_runs))

output_idx <- c(5, 13)
names(output_idx) <- c("tc", "co") 

# Mid-assembly temperature
i <- 1
for (j in 1:n_runs)
{
    idx <- ((j - 1) * n_ts + 1):(j * n_ts)
    trc_runs_df[idx, "time"] <- t_s
    trc_runs_df[idx, "value"] <- trc_runs_influential$replicates[idx_time, idx_runs[j], output_idx[i]]
    trc_runs_df[idx, "realization"] <- replicate(n_ts, j)
}
for (k in 1:n_runs)
{
    j <- n_runs + k
    idx <- ((j - 1) * n_ts + 1):(j * n_ts)
    trc_runs_df[idx, "time"] <- t_s
    trc_runs_df[idx, "value"] <- trc_runs_noninfluential$replicates[idx_time, idx_runs[k], output_idx[i]]
    trc_runs_df[idx, "realization"] <- replicate(n_ts, j)
}

# Liquid Carryover
i <- 2
for (k in 1:n_runs)
{
    j <- 2 * n_runs + k
    idx <- ((j - 1) * n_ts + 1):(j * n_ts)
    trc_runs_df[idx, "time"] <- t_s
    trc_runs_df[idx, "value"] <- trc_runs_influential$replicates[idx_time, idx_runs[k], output_idx[i]]
    trc_runs_df[idx, "realization"] <- replicate(n_ts, j)
}
for (k in 1:n_runs)
{
    j <- 3 * n_runs + k
    idx <- ((j - 1) * n_ts + 1):(j * n_ts)
    trc_runs_df[idx, "time"] <- t_s
    trc_runs_df[idx, "value"] <- trc_runs_noninfluential$replicates[idx_time, idx_runs[k], output_idx[i]]
    trc_runs_df[idx, "realization"] <- replicate(n_ts, j)
}

# Mid-assembly Pressure Drop
for (k in 1:n_runs)
{
    j <- 4 * n_runs + k
    idx <- ((j - 1) * n_ts + 1):(j * n_ts)
    trc_runs_df[idx, "time"]   <- t_s
    trc_runs_df[idx, "value"]  <- unname(
        eval.fd(t_s, trc_runs_influential_dp$fd[idx_runs[k]]) / 1e5)
    trc_runs_df[idx, "realization"] <- replicate(n_ts, j)
}
for (k in 1:n_runs)
{
    j <- 5 * n_runs + k
    idx <- ((j - 1) * n_ts + 1):(j * n_ts)
    trc_runs_df[idx, "time"] <- t_s
    trc_runs_df[idx, "value"] <- unname(
        eval.fd(t_s, trc_runs_noninfluential_dp$fd[idx_runs[k]]) / 1e5)
    trc_runs_df[idx, "realization"] <- replicate(n_ts, j)
}

# Relabel the output types
trc_runs_df$output <- factor(trc_runs_df$output, levels = c("tc", "dp", "co"))
levels(trc_runs_df$output) <- c("Mid-assembly Temperature [K]",
                                "Mid-assembly Pressure Drop [bar]",
                                "Liquid Carryover [kg]")

# Make plot -------------------------------------------------------------------
p <- ggplot(trc_runs_df, 
            aes(x = time, y = value, colour = influence, group = realization)) +
    facet_wrap(~ output, scales = "free_y", nrow = 1)
p <- p + geom_line()

# Set the plotting canvas
p <- p + theme_bw()
p <- p + theme(panel.grid.major = element_line(size = 0.5, color = "grey"))

# Set axis label
p <- p + labs(y = "", x = "Time [s]")
p <- p + theme(axis.title.x = element_text(size = 16))
p <- p + theme(axis.text.x = element_text(size = 14),
               axis.text.y = element_text(size = 14))

# Set the axis limits
p <- p + scale_x_continuous(limit = c(-1., 500.))

# Set facet label
p <- p + theme(strip.text.x = element_text(size = 14, face = "bold"))
##6C7A7D
# Scale colors
p <- p + scale_color_manual(values = c("darkgrey", "black"),
                            name = "Parameter Subsets",
                            breaks = c("influential", "non-influential"),
                            labels = c("12 Influential", "15 Non-influential"))

# Customize the Legend
p <- p + theme(legend.position = "top",
               legend.text = element_text(size = 16),
               legend.title = element_text(size = 16))
p <- p + guides(colour = guide_legend("Parameter Subsets"))

# Save the plot to a file -----------------------------------------------------
pdf(otpfullname, family = "CM Roman", 
    width = fig_size[1], height = fig_size[2])
print(p)
dev.off()
embed_fonts(otpfullname, outfile=otpfullname)
