# Load libraries.
library(readr)
library(dplyr)
library(ggplot2)
library(ggridges)

# Load in Simpsons data.
episodes <- read_csv("data/simpsons/SimpsonsData.csv")

# Clean the variable names.
episodes <- episodes %>% 
  janitor::clean_names() %>% 
  mutate(season = as.factor(season))

# Plot basic density plot.
ggplot(data = episodes) +
  geom_density(mapping = aes(x = rating,
                             group = season,
                             fill = season)) +
  theme(legend.position = "none")

# Expand density to a ridges plot.
ggplot(data = episodes) +
  geom_density_ridges(mapping = aes(x = rating,
                                    y = season,
                                    fill = season)) +
  theme_bw() +
  scale_fill_viridis_d() +
  theme(legend.position = "none") 

# Make airdate a date.
episodes <- episodes %>% 
  mutate(airdate_lub = lubridate::dmy(airdate))

# Make plot of individual episode trend.
ggplot(data = episodes) +
  geom_point(mapping = aes(x = airdate_lub, y = rating,
                           colour = season)) +
  theme_bw() +
  scale_colour_viridis_d() +
  theme(legend.position = "none") +
  labs(x = "date episode aired")

# Histogram.
ggplot(data = episodes) +
  geom_boxplot(mapping = aes(x = season, y = rating,
                             fill = season)) +
  theme_bw() +
  scale_fill_viridis_d() +
  theme(legend.position = "none")



