# Load packages.
library(tidytuesdayR)
library(dplyr)
library(ggplot2)
library(patchwork)

# Set theme
theme_set(theme_bw())

# Load the dataset from a recent week.
tt_raw_df <- tt_load(x = 2024, week = 19)

# Run the object for explanation.
tt_raw_df

# Extract the data.
tt_df <- tt_raw_df$rolling_stone

# Relationship between spotify popularity and billboard (basic).
scat_gg <- ggplot(data = tt_df) +
  geom_point(mapping = aes(x = weeks_on_billboard, y = spotify_popularity,
                           colour = release_year) ) +
  scale_colour_viridis_c() +
  labs(title = "Popularity (scatter)",
       x = "Weeks on billboard", y = "Spotify popularity",
       colour = "Release year") +
  # Rough fix for patchwork alignment.
  theme(axis.title.y = element_text(vjust = -15))

# Box.
box_gg <- tt_df %>% 
  filter(!is.na(artist_gender)) %>% 
  ggplot() +
  geom_boxplot(mapping = aes(x = ave_age_at_top_500,
                             y = artist_gender,
                             fill = artist_gender),
               alpha = 0.5) +
  labs(title = "Age distribution (boxplot)",
       x = NULL, y = NULL) +
  theme(legend.position = "none")

# Density.
dens_gg <- ggplot(data = tt_df) +
  geom_density(mapping = aes(x = ave_age_at_top_500,
                             fill = artist_gender),
               alpha = 0.5) +
  labs(title = "Age distribution (density)",
       fill = NULL, x = NULL, y = NULL) +
  theme(legend.position = "bottom")


# Bar plot.
bar_gg <- tt_df %>% 
  group_by(type) %>% 
  tally() %>% 
  ggplot() +
  geom_col(mapping = aes(x = reorder(type, n), y = n),
           fill = "grey20") +
  coord_flip() +
  labs(title = "Album type (bar)", y = NULL, x = NULL)
  

# Arrange them.
full_plot <- dens_gg + box_gg + bar_gg + scat_gg +
  plot_annotation(tag_levels = "A")

# Save.
ggsave(plot = full_plot,
       filename = "visuals/session2/viz_examples.png",
       height = 15, width = 22, unit = "cm", dpi = 300)
