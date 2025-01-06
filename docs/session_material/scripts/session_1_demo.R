# Load libraries.
library(tidytuesdayR)
library(dplyr)

# Load the tidytuesday data in.
tt_raw_df <- tt_load(x = 2024, week = 19)

# Explore the object you've created.
tt_raw_df

# Extract the data.
tt_df <- tt_raw_df$rolling_stone

# Explore the data.
glimpse(tt_df)
head(tt_df)
summary(tt_df)

# Basic tidyverse syntax.
artist_count <- tt_df %>% 
  group_by(clean_name) %>% 
  tally() %>% 
  arrange(n) 
  
  




