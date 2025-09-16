setwd("C:/Users/P076169/OneDrive - Amsterdam UMC/!Oude N schijf/merel/RDM/Codechecks/certificates/")

#install.packages("remotes")
#remotes::install_github("codecheckers/codecheck")
library(codecheck)
?codecheck

codecheck::create_cert_md
get_codecheck_yml()
latex_codecheck_logo
