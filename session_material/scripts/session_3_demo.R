# Load packages.
library(readr)
library(dplyr)
library(ggplot2)
library(sf)

# Load in tidytuesday data (manually).
sightings_df <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-06-20/ufo_sightings.csv')
places_df    <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-06-20/places.csv')

# Subset places data frame for the Netherlands.
places_nl_df <- places_df %>% 
  filter(country == "Netherlands")

# Plot out the coordinates.
ggplot(data = places_nl_df) +
  geom_point(mapping = aes(x = longitude, y = latitude))

# Create spatial object.
places_nl_sf <- places_nl_df %>% 
  st_as_sf(coords = c(x = "longitude", y = "latitude"), crs = 4326)

# Plot it as map.
ggplot(data = places_nl_sf) +
  geom_sf()

# Transform from WGS84 to Amersfoort projection.
places_nl_sf <- places_nl_sf %>% 
  st_transform(crs = 28992)

# Filter sightings data by the NL cities.
sightings_nl_df <- sightings_df %>% 
  filter(city %in% places_nl_sf$city,
         country_code == "NL") %>% 
  group_by(city) %>% 
  tally()

# We have places_nl_sf and sightings_nl_df.
# Join them together.
places_sightings_nl_sf <- places_nl_sf %>% 
  left_join(sightings_nl_df)

# Expand our plot.
ggplot(data = places_sightings_nl_sf) +
  geom_sf(mapping = aes(colour = n))

# Load in regional data.
regio_sf <- st_read("https://github.com/langtonhugh/rum_umc/raw/main/session_material/data/geo/B1_Provinciegrenzen_van_Nederland.gpkg")

# Joint plot.
ggplot() +
  geom_sf(data = regio_sf) +
  geom_sf(data = places_sightings_nl_sf)

# Spatial of points to polygons.
regio_ufo_sf <- regio_sf %>% 
  st_join(places_sightings_nl_sf)

# More aggregation.
regio_ufo_agg_df <- regio_ufo_sf %>% 
  group_by(state) %>% 
  summarise(n_sightings = sum(n))

# Make a plot of the regional sightings.
ggplot(data = regio_ufo_agg_df) +
  geom_sf(mapping = aes(fill = n_sightings)) +
  scale_fill_viridis_c() +
  labs(title = "Regional counts UFO sightings",
       fill  = "Count") +
  theme_bw()

