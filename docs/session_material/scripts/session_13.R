# Load libraries.
library(dplyr)
library(ggplot2)

# Execute prep script. 
source("scripts/session_13_data_prep.R")

# Check class of variables.
mean(df$displ, na.rm = TRUE)

# List approach.
lapply(df, mean, na.rm = TRUE)

# Same but vector output.
sapply(df, mean, na.rm = TRUE )

# We can use this basis to create our own function.

# Create table function.
table1_fun <- function(rawdata){
  data.frame(
    Variable = names(rawdata),
    Mean     = sapply(rawdata, mean  , na.rm = TRUE),
    Median   = sapply(rawdata, median, na.rm = TRUE),
    Min.     = sapply(rawdata, min   , na.rm = TRUE) ,
    Max.     = sapply(rawdata, max   , na.rm = TRUE) ,
    SD       = sapply(rawdata, sd    , na.rm = TRUE),
    # Then we use a new function within this function.
    Missing  = sapply(rawdata, function(x) {sum   (is.na(x))}),
    row.names = NULL
  ) %>% 
    mutate_if(is.numeric, round, 2)
  
}

# Run the function.
table1 <- table1_fun(df)
table1

# Another example of lapply and creating functions.
lapply(df, function(var){
  ggplot(data = df) +
    geom_histogram(mapping = aes(x = var))
})

# A for loop example (covered only if asked).
list_of_means <- list()

for (i in seq_along(df)){
  list_of_means[[i]] <- mean(df[[i]], na.rm = TRUE)
}

list_of_means




