# Data prep script for session 12. This is just replicating
# the data handling in the vignette.
# https://cran.r-project.org/web/packages/sjPlot/vignettes/blackwhitefigures.html

# Load libraries.
library(sjPlot)
library(dplyr)

# Load example data.
data(efc)

# Create a binary response Y variable.
df <- efc %>% 
  mutate(y = if_else(neg_c_7 < median(neg_c_7, na.rm = TRUE), 0, 1),
         sex = as.factor(c161sex),
         dep = as.factor(e42dep),
         education = as.factor(c172code),
         barthel = as.numeric(barthtot)
         ) %>% 
  select(y, sex, dep, education, barthel)

# Remove the original dataframe.
rm(efc)
