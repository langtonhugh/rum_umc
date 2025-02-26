# Load libraries.
library(sjPlot)
library(dplyr)
library(broom)
library(ggplot2)

# Execute my prep script in the background.
source(file = "scripts/session_12_data_prep.R")

# Explore data.
glimpse(df)
head(df)

# Fit a model (caveat: this is an example only).
fit <- glm(y ~ sex + dep + education + barthel,
           data = df,
           family = binomial(link = "logit"))

# Typical way of looking at the results.
fit
summary(fit)

# Plot table nicely.
tab_model(fit, transform = NULL)

# Make a forest plot.
plot_model(fit, transform = NULL)

# Manual table.
fit1_df <- tidy(fit)
fit2_df <- tidy(fit,conf.int = TRUE)
View(fit_df)

fit2_df %>% 
  mutate(
    sig   = if_else(p.value <= 0.05, "p < 0.05", "p > 0.05")
  ) %>%
  ggplot(data = ., mapping = aes(y = term,
                     x = estimate,
                     colour = sig)) +
  geom_point() +
  geom_errorbarh(mapping = aes(xmin = conf.low,
                               xmax = conf.high)) +
  scale_x_continuous(limits = c(-1, 2)) +
  scale_colour_manual(values = c("black","grey60")) +
  labs(title = "Plot of regression results",
       x = NULL, colour = NULL) +
  theme_bw()
