
# Initiate Packrat
packrat::init()
packrat::snapshot()
packrat::on()

library(DiceKriging)
# Install additional packages
install.packages("extrafont")
install.packages("plot3D")

library(plot3D)
library(extrafont)
font_install("fontcm")
font_import()
loadfonts(device="win")
pdf("test_font.pdf", family = "CM Roman", width = 4.33, height = 4.33)
plot(mtcars$mpg, mtcars$drat)
dev.off()
embed_fonts("test_font.pdf", outfile="test_font_embed.pdf")
# Base graphics
# First, register the fonts with R's PDF output device
# First, register the fonts with R's PDF output device
loadfonts()

png("plot_cm.png", family="CM Sans") #, width=5, height=5)

plot(c(1,5), c(1,5), main="Made with CM fonts")
text(x=3, y=3, cex=1.5,
     expression(italic(sum(frac(1, n*'!'), n==0, infinity) ==
                           lim(bgroup('(', 1 + frac(1, n), ')')^n, n %->% infinity))))

dev.off()
embed_fonts("plot_cm.pdf", outfile="plot_cm_embed.pdf")

Plot_cm_embed
Sys.setenv(R_GSCMD = "C:/Program Files/gs/gs9.21/bin/gswin64c.exe")
fonts()


pdf("plot_cm.pdf", family="CM Roman", width=5.5, height=5) #, units="in", res=600)

curve(dnorm, from=-3, to=3, main="Normal Distribution")
text(x=0, y=0.1, cex=1.5, expression(italic(y == frac(1, sqrt(2 * pi)) *
                                                e ^ {-frac(x^2, 2)} )))

dev.off()
embed_fonts("plot_cm.pdf", outfile="plot_cm_embed.pdf")