# Create corner plot for the 5-parameter model (only for illustration)
plot_ensemble_illustrate <- function(ens_rds, burnin, param_names,
                                     param_ranges, n_bins = 100)
{
    ens_samples <- readRDS(ens_rds)
    
    ens_samples <- ens_samples[,,(burnin+1):2000]
    
    ens_samples_burned <- t(ens_samples[,1,1:dim(ens_samples)[3]])
    
    for (i in 2:dim(ens_samples)[2])
    {
        ens_samples_burned <- rbind(ens_samples_burned,
                                    t(ens_samples[,i,1:dim(ens_samples)[3]]))
    }
    
    # Rescale model parameters and save to a file
    ens_samples_rescaled <- ens_samples_burned
    # x5 : Grid HT Enhancement [0.5, 2.0] logunif
    k <- 1
    ens_samples_rescaled[, k] <- 4^ens_samples_rescaled[,k] * 0.5
    # x6 : iafbWallHTC [0.5, 2.0] logunif
    k <- 2
    ens_samples_rescaled[, k] <- 4^ens_samples_rescaled[,k] * 0.5
    # x7 : dffbWallHTC [0.5, 2.0] logunif
    k <- 3
    ens_samples_rescaled[, k] <- 4^ens_samples_rescaled[,k] * 0.5
    # x8 : dffbVIHTC [0.25, 4.0] logunif
    k <- 4
    ens_samples_rescaled[, k] <- 16^ens_samples_rescaled[,k] * 0.25
    # x9 : iafbIntDrag [0.25, 4.0] logunif
    k <- 5
    ens_samples_rescaled[, k] <- 16^ens_samples_rescaled[,k] * 0.25
    # x10: dffbIntDrag [0.25, 4.0] logunif
    k <- 6
    ens_samples_rescaled[, k] <- 16^ens_samples_rescaled[,k] * 0.25
    # x11: dffbWallDrag [0.5, 2.0] logunif
    k <- 7
    ens_samples_rescaled[, k] <- 4^ens_samples_rescaled[,k] * 0.5
    # x12: Tminfb [-50, 50] unif
    k <- 8
    ens_samples_rescaled[, k] <- 100 * ens_samples_rescaled[,k] - 50
    
    # Make the corner plot
    p <- list()
    k <- 1
    for (i in 1:5)
    {
        for (j in 1:5)
        {
            if (i == j)
            {
                # Diagonal elements, 1-dimensional marginals
                p[[k]] <- ggplot(data.frame(x = ens_samples_rescaled[,i]),
                                 aes(x = x))
                p[[k]] <- p[[k]] + stat_bin(aes(y = ..count../sum(..count..)),
                                            geom = "step",
                                            bins = n_bins)
                p[[k]] <- p[[k]] + theme_bw()
                p[[k]] <- p[[k]] + theme(axis.text.x = element_blank())
                p[[k]] <- p[[k]] + theme(axis.ticks.x = element_blank())
                p[[k]] <- p[[k]] + theme(axis.title.x = element_blank())
                p[[k]] <- p[[k]] + theme(axis.text.y = element_blank())
                p[[k]] <- p[[k]] + theme(axis.ticks.y = element_blank())
                p[[k]] <- p[[k]] + theme(axis.title.y = element_blank())
                p[[k]] <- p[[k]] + ggtitle(param_names[j])
                p[[k]] <- p[[k]] + theme(plot.title = element_text(hjust = 0.5,
                                                                   size = 14,
                                                                   face = "bold"))
                p[[k]] <- p[[k]] + geom_vline(
                    xintercept = quantile(ens_samples_rescaled[,i],
                                          probs = c(0.025, 0.975)))
                p[[k]] <- p[[k]] + geom_vline(xintercept = nom_params[i],
                                              linetype = 2)
                p[[k]] <- p[[k]] + scale_x_continuous(limits = param_ranges[[i]])
                p[[k]] <- p[[k]] + geom_vline(
                    xintercept = median(ens_samples_rescaled[,i]),
                    color = "black", linetype = "dotted")
            } else if (j > i)
            {
                # Upper off-diagonal elements
                p[[k]] <- NA
            } else
            {
                # Lower off-diagonal elements, 2-dimensional marginals
                p[[k]] <- ggplot(data.frame(x = ens_samples_rescaled[,j],
                                            y = ens_samples_rescaled[,i]),
                                 aes(x, y))
                p[[k]] <- p[[k]] + geom_hex(show.legend = F)
                p[[k]] <- p[[k]] + theme_bw()
                p[[k]] <- p[[k]] + scale_fill_viridis(option = "magma")
                p[[k]] <- p[[k]] + theme(axis.title.x = element_blank())
                p[[k]] <- p[[k]] + theme(axis.ticks.x = element_blank())
                p[[k]] <- p[[k]] + theme(axis.text.x = element_blank())
                p[[k]] <- p[[k]] + theme(axis.text.y = element_blank())
                p[[k]] <- p[[k]] + theme(axis.ticks.y = element_blank())
                p[[k]] <- p[[k]] + theme(axis.title.y = element_blank())
                p[[k]] <- p[[k]] + scale_x_continuous(limits = param_ranges[[j]])
                p[[k]] <- p[[k]] + scale_y_continuous(limits = param_ranges[[i]])
            }
            k <- k + 1
        }
    }
    
    multiplot(p[[1]], p[[6]], p[[11]], p[[16]], p[[21]],
              p[[2]], p[[7]], p[[12]], p[[17]], p[[22]],
              p[[3]], p[[8]], p[[13]], p[[18]], p[[23]],
              p[[4]], p[[9]], p[[14]], p[[19]], p[[24]],
              p[[5]], p[[10]], p[[15]], p[[20]], p[[25]],
              cols = 5)
    
}