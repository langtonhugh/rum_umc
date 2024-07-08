# Load packages.
library(readr)
library(dplyr)
library(sf)
library(patchwork)
library(ggplot2)

# Load in tidytuesday data (manually).
sightings_df <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-06-20/ufo_sightings.csv')
places_df    <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-06-20/places.csv')

# Filter for Netherlands, and make places spatial.
places_nl_df <- places_df %>% 
  filter(country == "Netherlands") 

# Example plot when ignoring spatial component.
ggplot(data = places_nl_df) +
  geom_point(mapping = aes(x = longitude, y = latitude))

# Make spatial.
places_nl_sf <- places_nl_df %>%  
  st_as_sf(coords = c(x = "longitude", y = "latitude"), crs = 4326)

# Plot it to check.
ggplot(data = places_nl_sf) +
  geom_sf()

# Example of Amersfoort projection transform.
places_nl_sf <- places_nl_sf %>% 
  st_transform(crs = 28992)

# Plot it to check.
ggplot(data = places_nl_sf) +
  geom_sf()

# Filter the sighting according to these cities, then 
# aggregate.
sightings_nl_df <- sightings_df %>% 
  filter(city %in% places_nl_sf$city) %>% 
  group_by(city) %>% 
  tally()

# Join with spatial stuff.
places_sighting_nl_sf <- places_nl_sf %>% 
  left_join(sightings_nl_df)

# Plot.
ggplot(data = places_sighting_nl_sf) +
  geom_sf(mapping = aes(colour = n))

# Load in regional spatial data.
regio_sf <- st_read("https://github.com/langtonhugh/rum_umc/raw/main/session_material/data/geo/B1_Provinciegrenzen_van_Nederland.gpkg")

# Joint plot.
ggplot() +
  geom_sf(data = regio_sf) +
  geom_sf(data = places_sighting_nl_sf)

# Spatial join.
regio_ufo_sf <- regio_sf %>% 
  st_join(places_sighting_nl_sf)

# Aggregate.
regio_ufo_agg_df <- regio_ufo_sf %>% 
  group_by(state) %>% 
  summarize(n_sightings = sum(n))

# Regional plot.
regional_gg <- ggplot(data = regio_ufo_agg_df) +
  geom_sf(mapping = aes(fill = n_sightings),
          colour = "black") +
  scale_fill_viridis_c() +
  theme_bw() +
  labs(title = "Regional frequency counts",
       fill = "Count")

# City plot.
location_gg <- ggplot() +
  geom_sf(data = regio_ufo_agg_df) +
  geom_sf(data = places_sighting_nl_sf) +
  theme_bw() +
  labs(title = "Unique sighting locations")

# Arrange. 
full_plots <- regional_gg + location_gg +
  plot_annotation(title = "UFO sightings in the Netherlands (1925-2023) \n",
                  caption = "Source: National UFO Reporting Center | TidyTuesday",
                  theme = theme(
                    plot.title = element_text(hjust = 0.5)
                    )) 

# Save.
ggsave(plot = full_plots,
       filename = "visuals/session3/ufo_maps.png",
       height = 16, width = 22, unit = "cm", dpi = 300)

