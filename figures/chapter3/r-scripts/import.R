library(ggplot2)
library(extrafont)
#font_install("fontcm")
#font_import()
loadfonts(device="win")
Sys.setenv(R_GSCMD = "C:/Program Files/gs/gs9.21/bin/gswin64c.exe")

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
