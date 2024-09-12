# Load packages.
library(tidytuesdayR)
library(dplyr)
library(ggplot2)

# Load the dataset from a recent week.
tt_raw_df <- tt_load(x = 2024, week = 19)

# Run the object for explanation.
tt_raw_df

# Extract the data.
tt_df <- tt_raw_df$rolling_stone

# Explore it.
glimpse(tt_df)
head(tt_df)
summary(tt_df)

# Frequency counts of artists.
tt_df %>% 
  group_by(clean_name) %>% 
  tally() %>%  
  ungroup() %>%  
  arrange(desc(n)) %>% 
  slice(1:20) 

# Relationship between spotify popularity and billboard.
ggplot(data = tt_df) +
  geom_point(mapping = aes(x = weeks_on_billboard, y = spotify_popularity) )

# Use a flag for outliers.
tt_df <- tt_df %>% 
  mutate(outlier_flag = if_else(spotify_popularity < 20 | weeks_on_billboard > 300,
                                "yes", "no"))

# Annotated plot.
ggplot() +
  geom_point(data = tt_df, 
             mapping = aes(x = weeks_on_billboard, y = spotify_popularity,
                           colour = release_year), size = 3) +
  geom_text(data = tt_df %>% 
              filter(outlier_flag == "yes"),
            mapping = aes(x = weeks_on_billboard, y = spotify_popularity,
                          label = clean_name), hjust = -0.1, vjust = 0.5) +
  labs("Spotify & billboard popularity.", colour = "Release \nyear",
       x = "Weeks on billboard", y = "Spotify popularity") +
  scale_colour_viridis_c() +
  theme_bw()
  
# Save.
ggsave(filename = "visuals/session1/scatterplot.png",
       height = 12, width = 15, unit = "cm", dpi = 300)


