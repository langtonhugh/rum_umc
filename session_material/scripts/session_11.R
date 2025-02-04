# Load libraries.
library(tidytuesdayR)
library(readr)
library(ggplot2)
library(dplyr)
library(ggridges)

# Load data.
episodes <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-02-04/simpsons_episodes.csv')

# Correlation between views and imdb rating.
episodes %>% 
  filter(views > 1000) %>% # no explanation for those with very few views.
  ggplot(data = .) +
  geom_point(mapping = aes(x = imdb_rating, y = views))

# Distribution of ratings per season.
ggplot(data = episodes) +
  geom_


