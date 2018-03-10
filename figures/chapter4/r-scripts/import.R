
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

# Testing plot with extra font embedded
pdf("test_font.pdf", family = "CM Roman", width = 4.33, height = 4.33)
plot(mtcars$mpg, mtcars$drat)
dev.off()
embed_fonts("test_font.pdf", outfile="test_font_embed.pdf")
