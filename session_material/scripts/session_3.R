# Load packages.
library(readr)
library(dplyr)
library(cbsdataR)
library(sf)
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



