ens_prior_rescaled <- matrix(replicate(8, runif(1e3)), ncol = 8)
# x5 : Grid HT Enhancement [0.5, 2.0] logunif
k <- 1
ens_prior_rescaled[, k] <- 4^ens_prior_rescaled[,k] * 0.5
# x6 : iafbWallHTC [0.5, 2.0] logunif
k <- 2
ens_prior_rescaled[, k] <- 4^ens_prior_rescaled[,k] * 0.5
# x7 : dffbWallHTC [0.5, 2.0] logunif
k <- 3
ens_prior_rescaled[, k] <- 4^ens_prior_rescaled[,k] * 0.5
# x8 : dffbVIHTC [0.25, 4.0] logunif
k <- 4
ens_prior_rescaled[, k] <- 16^ens_prior_rescaled[,k] * 0.25
# x9 : iafbIntDrag [0.25, 4.0] logunif
k <- 5
ens_prior_rescaled[, k] <- 16^ens_prior_rescaled[,k] * 0.25
# x10: dffbIntDrag [0.25, 4.0] logunif
k <- 6
ens_prior_rescaled[, k] <- 16^ens_prior_rescaled[,k] * 0.25
# x11: dffbWallDrag [0.5, 2.0] logunif
k <- 7
ens_prior_rescaled[, k] <- 4^ens_prior_rescaled[,k] * 0.5
# x12: Tminfb [-50, 50] unif
k <- 8
ens_prior_rescaled[, k] <- 100 * ens_prior_rescaled[,k] - 50

ens_hpdi <- apply(ens_samples_rescaled, 2, HPDI, prob = 0.95)
ens_med <- apply(ens_samples_rescaled, 2, median)
ens_prior_pct <- apply(ens_prior_rescaled, 2, quantile, probs = c(0.025, 0.975))

for (i in 1:8)
{
  x <- sprintf("[%.2f,%.2f,%.2f]", ens_prior_pct[1,i], ens_med[i], ens_prior_pct[2,i])
  print(x)
}
