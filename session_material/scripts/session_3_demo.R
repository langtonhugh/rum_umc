# Load packages.
library(readr)
library(dplyr)
library(ggplot2)
library(sf)

# Load in tidytuesday data (manually).
sightings_df <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-06-20/ufo_sightings.csv')
places_df    <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-06-20/places.csv')


