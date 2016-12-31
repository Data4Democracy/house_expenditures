library(tidyr)
library(purrr)
library(dplyr)

# Function to summarise house expenditure data
# 3 Arguments:
### df: data frame of expenditures in the format as supplied by the load.R & clean.R files
### summary_var: the variable which to group on (i.e. PAYEE or OFFICE)
### as.df: default is set to true. If FALSE, a list for each quarter will be created.

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
  
  temp <- df %>% split(.$QUARTER) %>%
    map(~ .x %>% summary_exp(summary_var))
  
  if(as.df == TRUE) {
    do.call("rbind", temp)
  } else {
      temp
    }
  
}



