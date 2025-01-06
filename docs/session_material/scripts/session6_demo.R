# Load libraries.
library(readr)
library(dplyr)
library(lubridate)
library(forcats)
library(ggplot2)
library(patchwork)

# Load in data.
subset_df <- read_csv('https://github.com/langtonhugh/p2000_data/raw/refs/heads/main/data/p2000_july2023.csv')

# Create some useful time variables.
clean_df <- subset_df %>% 
  mutate(date_time_round = round_date(timestamp, "hour"),
         hour_of_day     = hour(date_time_round),
         week_day        = wday(timestamp, abbr = FALSE, label = TRUE),
         month_name      = month(timestamp, abbr = FALSE, label = TRUE))

# Frequency counts for services.
ggplot(data = clean_df) +
  geom_bar(mapping = aes(x = service, fill = service))

# Reorder the factors.
clean_df <- clean_df %>% 
  mutate(service = fct_relevel(service,
                               "Fire", "Ambulance","Police"))

# Frequency counts for services.
p1 <- ggplot(data = clean_df) +
  geom_bar(mapping = aes(x = service, fill = service)) +
  theme_bw() +
  theme(legend.position = "none")

# Plot the entire scrape period.
clean_df %>% 
  group_by(date_time_round, service) %>% 
  summarise(counts = n()) %>% 
  ungroup() %>% 
  ggplot() +
  geom_line(mapping = aes(date_time_round, y = counts, colour = service)) +
  facet_wrap(~service, ncol = 1)

# Create hourly frequency counts.
hourly_dist_df <- clean_df %>% 
  group_by(hour_of_day, service, dates) %>% 
  summarise(counts = n()) %>% 
  ungroup()

# Create distribution plot.
p2 <- ggplot(data = hourly_dist_df) +
  geom_point(mapping = aes(x = hour_of_day, y = counts, col = service)) +
  facet_wrap(~service, scales = "free_y") +
  labs(x = "Hour of the day",
       # title = "P2000 counts for June, 2023.",
       caption = "This data is flawed!") +
  theme_bw() +
  theme(legend.position = "none")

# Arrange plots.
full_plot <- (p1 + p2) +
  plot_layout(widths = c(1,2)) +
  plot_annotation(tag_levels = "A")

# Save the plot.
ggsave(plot = full_plot,
       filename = "my_demo_plot.png",
       dpi = 300, width = 16, height = 10, units = "cm")







