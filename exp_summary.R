library(tidyr)
library(purrr)
library(dplyr)
#NOTE: this function takes a while (i think because of the max_exp_cat variable)

# Function to summarise house expenditure data
# 3 Arguments:
### df: data frame of expenditures in the format as supplied by the load.R & clean.R files
### summary_var: the variable which to group on (i.e. PAYEE or OFFICE)
### as.df: default is set to true. If FALSE, a list for each quarter will be created.

# Create summary statistics for dispursements by quarter
# Finds total expenditures for the quarter
# Finds largest & smallest single expenditures
# Finds category of largest expenditure
# Finds standard deviation of expenditures
# Finds average expenditure amount


exp_summary <- function(df, summary_var, as.df = TRUE) {
  summarise_exp <- function(data_frame = NULL, ...) {
    data_frame %>% 
      group_by_(..., 'QUARTER') %>%
      summarise(qrtly_exp = sum(AMOUNT),
                max_exp_cat = data_frame[which.max(data_frame[, 'AMOUNT']), "CATEGORY"],
                max_exp = max(AMOUNT),
                min_exp = min(AMOUNT),
                sd_exp = sd(AMOUNT),
                avg_exp = mean(AMOUNT)
      )
  }
  
  if(as.df == TRUE){
    df %>% split(.$QUARTER) %>%
      map(~ .x %>% summarise_exp(summary_var)) %>% bind_rows()
  } else {
    df %>% split(.$QUARTER) %>%
      map(~ .x %>% summarise_exp(summary_var))
  }
}
