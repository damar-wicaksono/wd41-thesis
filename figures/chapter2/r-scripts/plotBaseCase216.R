set.seed(23890)
n <- 50
runs <- sample(seq(1,1000), n)

# Input filename
rds_fullname <- "../../../../wd41-thesis.analysis.new/simulation/mcmc-uq/result-compiled/febaTrans216-febaVars12Influential-srs_1000_12.Rds"
rds_dp_fullname <- "../../../../wd41-thesis.analysis.new/simulation/mcmc-uq/result-compiled/febaTrans216-febaVars12Influential-srs_1000_12-dp_smoothed.Rds"

n_sub <- 5  # Sub sample points (each point would make the file too large)
trc_run_df <- readRDS(rds_fullname)

# Make the plot ---------------------------------------------------------------
plot(trc_run_df$time, trc_run_df$nominal[,5], type = "l")
for(i in 1:n) lines(trc_run_df$time, trc_run_df$replicates[,runs[i],5])

n_t <- dim(trc_uq_df)[1]
trc_uq_df <- readRDS(rds_tidy_fullname)[[1]][seq(1, n_t, n_sub),]
trc_exp_df <- readRDS(rds_tidy_fullname)[[2]]

#