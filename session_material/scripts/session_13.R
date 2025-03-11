# Load libraries.
library(dplyr)

# Execute prep script. It's the same data is last workshop.
source("scripts/session_13_data_prep.R")

# Check class of variables.
mean(df$y, na.rm = TRUE)

lapply(df, mean, na.rm = TRUE)
sapply(df, mean, na.rm = TRUE )

# Create table function.
table1_fun <- function(rawdata){
  data.frame(
    Variable = names(rawdata),
    Mean     = sapply(rawdata, mean  , na.rm = TRUE),
    Median   = sapply(rawdata, median, na.rm = TRUE),
    Min.     = sapply(rawdata, min   , na.rm = TRUE) ,
    Max.     = sapply(rawdata, max   , na.rm = TRUE) ,
    SD       = sapply(rawdata, sd    , na.rm = TRUE),
    Missing  = sapply(rawdata, function(x) {sum   (is.na(x))}),
    row.names = NULL
  ) %>% 
    mutate_if(is.numeric, round, 2)
  
}

# Run the function.
table1 <- table1_fun(df)
table1

# A for loop example (covered only if asked).
list_of_means <- list()

for (i in seq_along(df)){
  list_of_means[[i]] <- mean(df[[i]], na.rm = TRUE)
}

list_of_means




