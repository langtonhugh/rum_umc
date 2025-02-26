# Load libraries.
library(sjPlot)
library(dplyr)
library(broom)
library(ggplot2)

# Execute prep script in the background.
source("scripts/session_12_data_prep.R")

# Run the regression model.
fit <- glm(y ~ sex + dep + education + barthel,
           data = df,
           family = binomial(link = "logit"))

# Basic ways of showing results.
fit
summary(fit)

# Print a nicer table to my view pane.
tab_model(fit, transform = NULL)

# Create a plot of the results.
plot_model(fit, transform = NULL) +
  labs(title = "Label for Y variable") +
  theme_bw()

# Extract results using broom.
fit_df <- tidy(fit, conf.int = TRUE)

# Add a flag for statistical sig.
fit_df <- fit_df %>% 
  mutate(stat_sig = if_else(p.value < 0.05,
                            "stat. sig.",
                            "not stat. sig."))

# Manual results plot.
ggplot(data = fit_df,
       mapping = aes(x = estimate, y = term,
                     colour = stat_sig)) +
  geom_point() +
  geom_errorbarh(mapping = aes(xmin = conf.low,
                               xmax = conf.high)) +
  scale_x_continuous(limits = c(-3, 3)) +
  scale_colour_manual(values = c("black", "grey60")) +
  theme_bw() +
  labs(title = "My regression results",
       y = NULL,
       colour = NULL)

# Add two results tables together.
# Run the regression model.
fit1 <- glm(y ~ sex + dep + education + barthel,
           data = df,
           family = binomial(link = "logit"))

fit2 <- glm(y ~ sex + dep + barthel,
            data = df,
            family = binomial(link = "logit"))

# Tidy both up.
fit1_df <- tidy(fit1, conf.int = TRUE) %>% 
  mutate(model_name = "Fit1_model")

fit2_df <- tidy(fit2, conf.int = TRUE) %>% 
  mutate(model_name = "Fit2_model")

# Bind them together.
fit12_df <- bind_rows(fit1_df, fit2_df)



