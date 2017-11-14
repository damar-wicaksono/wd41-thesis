# Create corner plot for the 8-parameter model
plot_ensemble <- function(ens_rds, burnin, param_names, param_ranges,
                          n_bins = 100)
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
  for (i in 1:8)
  {
    for (j in 1:8)
    {
      if (i == j)
      {
        # Diagonal elements, 1-dimensional marginals
        p[[k]] <- ggplot(data.frame(x = ens_samples_rescaled[,i]), aes(x = x))
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
          xintercept = HPDI(ens_samples_rescaled[,i]))
        p[[k]] <- p[[k]] + geom_vline(xintercept = nom_params[i], linetype = 2)
        p[[k]] <- p[[k]] + scale_x_continuous(limits = param_ranges[[i]])
        p[[k]] <- p[[k]] + geom_vline(
          xintercept = median(ens_samples_rescaled[,i]),
          color = "black", linetype = "dotted")
        # Plot the tick labels in bottom-most part of the plot
        if (i == 1)
        {
          p[[k]] <- p[[k]] + ylab("Test")
          p[[k]] <- p[[k]] + theme(axis.title.y = element_text(colour = "white"))
        }
        if (i == 8)
        {
          p[[k]] <- p[[k]] + theme(axis.text.x = element_text(size = 13))
          if (param_ranges[[j]][1] == 0.25)
          {
            p[[k]] <- p[[k]] + scale_x_continuous(breaks = c(0.25, 1, 2, 3, 4),
                                                  limits = c(0.25, 4.0))
          }
        }

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
        # Plot the tick labels in bottom-most part of the plot
        if (i == 8)
        {
          p[[k]] <- p[[k]] + theme(axis.text.x = element_text(size = 13))
          if (param_ranges[[j]][1] == 0.25)
          {
            p[[k]] <- p[[k]] + scale_x_continuous(breaks = c(0.25, 1, 2, 4),
                                                  labels = c("1/4", "1", "2", "4"),
                                                  limits = c(0.25, 4.0))
          } else if (param_ranges[[j]][1] == 0.50)
          {
            p[[k]] <- p[[k]] + scale_x_continuous(breaks = c(0.5, 1, 2),
                                                  labels = c("1/2", "1", "2"),
                                                  limits = c(0.5, 2.0))
          }
        }
        if (j == 1)
        {
          p[[k]] <- p[[k]] + theme(axis.text.y = element_text(size = 13))
          if (param_ranges[[i]][1] == 0.25)
          {
            p[[k]] <- p[[k]] + scale_y_continuous(breaks = c(0.25, 1, 2, 4),
                                                  labels = c("1/4", "1", "2", "4"),
                                                  limits = c(0.25, 4.0))
          } else if (param_ranges[[i]][1] == 0.50)
          {
            p[[k]] <- p[[k]] + scale_y_continuous(breaks = c(0.5, 1, 2),
                                                  labels = c("1/2", "1", "2"),
                                                  limits = c(0.5, 2.0))
          }
        }
      }
      k <- k + 1
    }
  }

  multiplot(p[[1]], p[[9]], p[[17]], p[[25]], p[[33]], p[[41]], p[[49]], p[[57]],
            p[[2]], p[[10]], p[[18]], p[[26]], p[[34]], p[[42]], p[[50]], p[[58]],
            p[[3]], p[[11]], p[[19]], p[[27]], p[[35]], p[[43]], p[[51]], p[[59]],
            p[[4]], p[[12]], p[[20]], p[[28]], p[[36]], p[[44]], p[[52]], p[[60]],
            p[[5]], p[[13]], p[[21]], p[[29]], p[[37]], p[[45]], p[[53]], p[[61]],
            p[[6]], p[[14]], p[[22]], p[[30]], p[[38]], p[[46]], p[[54]], p[[62]],
            p[[7]], p[[15]], p[[23]], p[[31]], p[[39]], p[[47]], p[[55]], p[[63]],
            p[[8]], p[[16]], p[[24]], p[[32]], p[[40]], p[[48]], p[[56]], p[[64]],
            cols = 8)

}

#          geom_vline(xintercept = quantile(ens_samples_rescaled[,i],
#                                           probs = c(0.025, 0.975)), linetype = 3) +
