# Load libraries.
library(readr)
library(dplyr)
library(lubridate)
library(forcats)
library(ggplot2)
library(patchwork)

# Load in data.
subset_df <- read_csv('https://github.com/langtonhugh/p2000_data/raw/refs/heads/main/data/p2000_july2023.csv')

  