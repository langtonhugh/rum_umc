# Load libraries.
library(readr)
library(dplyr)
library(ggplot2)

# Execute prep script.
source("scripts/session_13_data_prep.R")

# Calculate the mean of hwy
mean(df$hwy)
mean(df$displ)
mean(df$cyl)
mean(df$cty)

# Calculate the mean of every variable (using lapply).
lapply(df, mean)

# Calculate the same thing using sapply.
sapply(df, mean)

# Calculate other stuff.
sapply(df, median)
sapply(df, class)

# Create a table of descriptive.
table1 <- data.frame(
  Variable = names(df),
  Mean     = sapply(df, mean),
  Median   = sapply(df, median),
  Min      = sapply(df, min),
  Max      = sapply(df, max),
  SD       = sapply(df, sd),
  row.names = NULL
)

# Save the table.
write_csv(x = table1,
          file = "data/session13/table1_example.csv")

# Check count loop.
sapply(df, table)

# Explore tableone package.
library(tableone)

# Try table one function.
CreateTableOne(data = df)





