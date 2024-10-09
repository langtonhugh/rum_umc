# Load libraries.
library(readr)
library(dplyr)
library(lubridate)
library(forcats)
library(ggplot2)
library(patchwork)

# Note caveats about data! Incomplete scrapes, and assumptions made about
# data that might inflate ambulance counts (MKA coded at Ambulance).
# Demonstration only.

# Load in data.
subset_df <- read_csv('https://github.com/langtonhugh/p2000_data/raw/refs/heads/main/data/p2000_july2023.csv')

# Create (potentially) useful variables.
clean_df <- subset_df %>% 
  mutate(date_time_r  = round_date(timestamp, "hour"),
         hour_of_day  = hour(date_time_r),
         week_day     = wday(timestamp , abbr = FALSE, label = TRUE),
         # hour_of_week = hour_of_day + (24 * (wday(timestamp, week_start = 1)-1)), # Create an hour of the week (0-167 hours).
         month_naam   = month(timestamp, abbr = FALSE, label = TRUE),
         # week_year    = week(timestamp),
         week_day_f   = fct_relevel(week_day,
                                    "Monday"  , "Tuesday" , "Wednesday",
                                    "Thursday", "Friday" , "Saturday", "Sunday")
  ) 

# Service counts.
ggplot(data = clean_df) +
  geom_bar(mapping = aes(x = service, fill = service))

# Based on that, define factor levels.
clean_df <- clean_df %>% 
  mutate(service = fct_relevel(service, "Fire","Ambulance","Police"))

# Service counts (again).
p1 <- ggplot(data = clean_df) +
  geom_bar(mapping = aes(x = service, fill = service)) +
  labs(x = NULL) +
  theme_bw() +
  theme(legend.position = "none")

# Plot it.
p1

# Nationwide hourly frequencies by hour (mainly to show study period and gaps).
p2 <- clean_df %>% 
  group_by(date_time_r, service) %>% 
  summarise(counts = n()) %>% 
  ungroup() %>% 
  ggplot() +
  geom_line(mapping = aes(x = date_time_r, y = counts, colour = service)) +
  facet_wrap(~service, scales = "free", ncol = 1) +
  theme_bw() +
  theme(legend.position = "none") 

# Plot it.
p2

# Hourly counts of incidents.
hourly_counts_df <- clean_df %>% 
  group_by(hour_of_day, service, dates) %>% 
  summarise(counts = n()) %>% 
  ungroup() 

# Point plot.
p3 <- hourly_counts_df %>%
  ggplot(mapping = aes(x = hour_of_day, y = counts, col = service),
         shape = 21, fill = "black", colour = NA) +
  geom_point(alpha = 0.4) +
  stat_summary(fun = mean, geom = "line" , col = "grey20", group = 1, linewidth = 0.6) +
  facet_wrap(~service, scales = "free_y", nrow = 1) +
  labs(x = "hour of day", y = NULL) +
  theme_bw() +
  theme(legend.position = "none") 

# Plot it.
p3

# # Boxplot.
# p4 <- hourly_counts_df %>% 
#   ggplot(mapping = aes(x = hour_of_day, y = counts, group = hour_of_day, fill = service)) +
#   geom_boxplot(outlier.shape = NA) + # this removes outlier points.
#   stat_summary(fun = mean, geom = "point", group = 1) +
#   facet_wrap(~service, scales = "free_y", nrow = 1) +
#   labs(x = "hour of day") +
#   theme_bw() +
#   theme(legend.position = "none")

# Arrange.
full_plot <- (p1 + p3) +
  plot_layout(widths = c(1, 2)) +
  plot_annotation(tag_levels = 'A',
                  title = "Counts of 112 meldingen nationwide, July 2023.",
                  caption = "Data source: P2000 communications (not complete!)") 
  
# Save.
ggsave(plot = full_plot,
       filename = "visuals/session6/p2000_example.png",
       height = 7, width = 24, unit = "cm")

  