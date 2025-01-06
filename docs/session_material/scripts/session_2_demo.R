# Load packages.
library(readr)
library(dplyr)
library(ggplot2)

# Extract the data.
tt_df <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-05-07/rolling_stone.csv')

# Explore.
glimpse(tt_df)

# Plot basic scatterplot, between billboard-spotify pop.
ggplot(data = tt_df,
       mapping = aes(x = weeks_on_billboard,
                     y = spotify_popularity)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

# Same plot in a different way.
ggplot(data = tt_df) +
  geom_point(mapping = aes(x = weeks_on_billboard,
                           y = spotify_popularity)) +
  geom_smooth(mapping = aes(x = weeks_on_billboard,
                            y = spotify_popularity))

# Make more complex.
ggplot(data = tt_df,
       mapping = aes(x = weeks_on_billboard,
                     y = spotify_popularity,
                     colour = release_year)) +
  geom_point() +
  labs(x = "Billboard rank", y = "Spotify pop.",
       title = "Relationship between billboard & spotify",
       subtitle = "Just a demo",
       caption = "Data from tidytuesday") +
  scale_colour_viridis_c()

# Boxplot.
ggplot(data = tt_df) +
  geom_boxplot(mapping = aes(x = ave_age_at_top_500,
                             # y = artist_gender,
                             fill = artist_gender)) +
  scale_fill_brewer(palette = "Set2") +
  labs(x = "whatever it might be",
       fill = "Gender")











