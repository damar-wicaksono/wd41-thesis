#
# title     : plotSIEvol.R
# purpose   : Script to create an illustration plot of cladding temperature
#           : evolution in a reflood transient
# author    : WD41, LRS/EPFL/PSI
# date      : August 2016
#
# Load the Required Libraries -------------------------------------------------
source("./r-scripts/import.R")
source("./r-scripts/multiplot.R")

# Global variables ------------------------------------------------------------
# Output filename
otpfullname <- "./figures/plotSIEvol.pdf"

# Input filenames
data_path <- "../../../analysis/sobol/results"
pca_fd_fullname <- paste0(data_path, "/", "tc_warpfd_pcafd-tc_4.Rds")
std_evol_fullname <- paste0(data_path, "/", "std_evol-tc_4.csv")
si_evol_fullname <- paste0(data_path, "/", "si_evol-tc_4-janon.csv")

# Use concise ID to code parameter names due to space constrained
param_names <- c("breakP",    # break_ptb     1
                 "fillT",     # fill_tltb     2
                 "fillV",     # fill_vmtbm    3
                 "pwr",       # pwr_rpwtbr    4
                 "gridHT",    # gridHTEnh     15
                 "iafbWHT",   # iafbWallHTC   16
                 "dffbWHT",   # dffbWallHTC   17
                 "dffbVIHT",  # dffbVIHTC     20
                 "iafbIntDr", # iafbIntDrag   22
                 "dffbIntDr", # dffbIntDrag   23
                 "dffbWDr",   # dffbWallDrag  25
                 "tQuench")   # tempQuench    27

# Graphic Parameters
fig_size <- c(12, 7)             # width, height

# Read Sobol Indices Evolution Data -------------------------------------------
unif_time <- readRDS(pca_fd_fullname)
unif_time <- as.numeric(unif_time$meanfd$fdnames$time)

std_evol <- read.csv(std_evol_fullname, header = FALSE)
si_evol <- read.csv(si_evol_fullname, header = FALSE)

# Create a tidy dataframe, select only view points
time_subset <- unif_time[seq(10, length(unif_time), by = 150)]
df <- data.frame(time = time_subset,
                 value = si_evol[seq(10, length(unif_time), by = 150), 1],
                 parameter = rep(param_names[1], length(time_subset)))
for (i in 2:12)
{
    df1 <- data.frame(time = time_subset,
                      value = si_evol[seq(10, length(unif_time), by = 150), i],
                      parameter = rep(param_names[i], length(time_subset)))
    df <- rbind(df, df1)
}

tidy_df <- df
tidy_df$value[tidy_df$value < 0] <- 0.0

# Create the Plot of Main-effect Indices Evolution  ---------------------------
p1 <- ggplot(tidy_df, aes(x = time, y = value, shape = parameter)) + 
    geom_point(size = 3)
p1 <- p1 + scale_shape_manual(values = c(16, 0, 1, 2, 7, 4, 3, 15, 5, 17, 6, 8))

# Set the plotting canvas
p1 <- p1 + theme_bw()
p1 <- p1 + theme(legend.position = "top",
                 legend.text = element_text(size = 13)) + 
    guides(shape = guide_legend(nrow=1))
p1 <- p1 + theme(panel.grid.major = element_line(size = 0.5, color = "grey"))
p1 <- p1 + labs(y = "Index Value [-]")
p1 <- p1 + theme(axis.title.y = element_text(vjust = 1.2, size = 20),
                 axis.title.x = element_text(size = 20))
p1 <- p1 + theme(axis.text.x = element_text(size = 14),
                 axis.text.y = element_text(size = 14))
p1 <- p1 + scale_x_continuous(limit = c(-1., 400.))
p1 <- p1 + labs(shape = "", x = "")

# Create the Plot of Clad Temperature Standard Deviation Evolution ------------
std_evol$time <- unif_time
names(std_evol) <- c("std_dev", "time")

p2 <- ggplot(std_evol, aes(x = time, y = std_dev)) + geom_line()


# Set the plotting canvas
p2 <- p2 + theme_bw()
p2 <- p2 + labs(x = "Time [s]", 
                y = expression(paste("Temp. Std. Dev. [K]")))
p2 <- p2 +theme(panel.grid.major = element_line(size = 0.5, color = "grey"))
p2 <- p2 + scale_x_continuous(limit = c(-1., 400.))
# Increase y-axis ticks and labels size
p2 <- p2 + theme(axis.title.y = element_text(vjust = 1.2, size = 20),
                 axis.title.x = element_text(size = 20))
p2 <- p2 + theme(axis.text.x = element_text(size = 14),
                 axis.text.y = element_text(size = 14))

# Save the plot ---------------------------------------------------------------
pdf(otpfullname, family = "CM Roman", 
    width = fig_size[1], height = fig_size[2], useDingbats = F)
print(multiplot(p1, p2))
dev.off()
