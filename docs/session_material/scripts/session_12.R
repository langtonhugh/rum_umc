# Load libraries.
library(sjPlot)
library(dplyr)
library(broom)
library(ggplot2)

# Execute the prep script in the background.
source("scripts/session_12_data_prep.R")

# Explore data.
glimpse(df)
head(df)

# Fit a model.
fit <- glm(y ~ sex + dep + education + barthel,
           data = df, family = binomial(link = "logit"))

# Base R summary of the results.
summary(fit)

# Create a default plot.
plot_model(fit, transform = NULL) 

# Table of results.
tab_model(fit, transform = NULL)

# Manual (tidy) results using broom package.
fit_df <- tidy(fit)
fit_df

# Additional steps before plot.
fit_extras_df <- fit_df %>% 
  filter(term != "intercept") %>%
  mutate(upper = estimate+(std.error*1.96),
         lower = estimate-(std.error*1.96),
         direc = if_else(estimate > 0, "postive", "negative"),
         sig   = if_else(p.value <= 0.05, "p < 0.05", "p > 0.05"))

# Plot those results using ggplot2.
ggplot(data = fit_extras_df,
         mapping = aes(y = term,
                       x = estimate,
                       colour = sig)) +
  geom_point() +
  geom_errorbarh(mapping = aes(xmin = lower,
                               xmax = upper,)) +
  scale_x_continuous(limits = c(-1, 2)) +
  scale_colour_manual(values = c("black","grey60")) +
  labs(title = "Plot of regression results",
       x = NULL, colour = NULL) +
  theme_bw()
