# Load libraries.
library(readr)
library(dplyr)
library(ggplot2)
library(ggridges)

# Kaggle data csv (free but requires login).
# https://www.kaggle.com/datasets/hod101s/simpsons-imdb-ratings?resource=download
episodes <- read_csv("data/simpsons/SimpsonsData.csv")

# Clean names.
episodes <- episodes %>% 
  janitor::clean_names()

# Initial density plot.
ggplot(data = episodes) +
  geom_density(mapping = aes(x = rating, group = season, fill = season))

# Ridges density plot.
ggplot(data = episodes) +
  geom_density_ridges(mapping )

