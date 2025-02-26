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

# Example of a 'Table 1'. Note that this is just a generic
# example irrespective of the variable types (e.g., categorical).
# Please verify it!

# Create the function to make a Table 1.
table1_fun <- function(dat){
  data.frame(
    Variable = names(dat),
    Missing  = as.numeric(lapply(dat, function(x) {sum   (is.na(x))})),
    Mean     = as.numeric(lapply(dat, function(x) {mean  (x, na.rm = TRUE)} )),
    Median   = as.numeric(lapply(dat, function(x) {median(x, na.rm = TRUE)} )),
    Min.     = as.numeric(lapply(dat, function(x) {min   (x, na.rm = TRUE)} )),
    Max.     = as.numeric(lapply(dat, function(x) {max   (x, na.rm = TRUE)} )),
    SD       = as.numeric(lapply(dat, function(x) {sd    (x, na.rm = TRUE)} ))
  )

}

# Make all variable numeric. The above will only work for numeric variables.
df_num <- df %>% 
  mutate_all(as.numeric)

# Apply the function to our data. This is a data frame object you can save
# or use in an rmarkdown/quarto file.
table1_fun(df_num)
