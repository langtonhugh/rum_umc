# Load libraries.
library(readr)
library(dplyr)
library(ggplot2)
library(ggridges)
library(patchwork)

# Set theme.
theme_set(theme_bw())

# Kaggle data csv (free but requires login).
# https://www.kaggle.com/datasets/hod101s/simpsons-imdb-ratings?resource=download
episodes <- read_csv("data/simpsons/SimpsonsData.csv")

# Explore.
summary(episodes)
glimpse(episodes)

# Sort out names.
episodes <- episodes %>% 
  janitor::clean_names() %>% 
  mutate(season = as.factor(season))

# Basic distribution of ratings per season.
ggplot(data = episodes) +
  geom_density(mapping = aes(x = rating,
                             group = season, fill = season),
               alpha = 0.5) +
  theme(legend.position = "none")

# Ridges plot.
ridges <- ggplot(data = episodes) +
  geom_density_ridges_gradient(mapping = aes(x = rating,
                                    y = season, fill = season)) +
  theme(legend.position = "none") +
  scale_fill_viridis_d() 

# Extract proper date.
episodes <- episodes %>% 
  mutate(date_lub = lubridate::dmy(airdate))

# Visualise long-term individual trend.
points <- ggplot(data = episodes) +
  geom_point(mapping = aes(x = date_lub, y = rating, colour = season)) +
  labs(x = "date episode aired") +
  scale_colour_viridis_d() +
  theme(legend.position = "none") 

# Visualise distribution trend.
boxplots <- ggplot(data = episodes) +
  geom_boxplot(mapping = aes(x = season, y = rating, fill = season)) +
  scale_fill_viridis_d() +
  labs(x = "seasons over time") +
  theme(legend.position = "none",
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.x = element_text(vjust = 5)) 

# Arrange plots and add caption.
(ridges) + (points / boxplots) +
  plot_annotation(title = "Is 'The Simpsons' really getting worse?",
                  caption = "Data source: IMDB ratings compiled by Manas Acharya (Kaggle)") &
  theme(plot.title = element_text(hjust = 0.5))

# Save.
ggsave(filename = "visuals/session11/simpsons_rating_plot.png",
       height = 20, width = 20, unit = "cm", dpi = 300)
