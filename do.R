# Set up your working directory
#setwd("~/Documents/github/house_expenditures")
 
rm(list = ls())

source("load.R") # Load all Q3 data from ProPublica and combine into one dataset
source("clean.R") # Clean dataset
source("func.R") # Load functions