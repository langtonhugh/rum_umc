# Load libraries.
library(ggplot2)
library(dplyr)

# Load example data.
data(mpg)

# Make selection.
df <- mpg %>% 
  select(displ, cyl, cty, hwy)

# Remove original.
rm(mpg)
