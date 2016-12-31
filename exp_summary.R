library(tidyr)
library(purrr)
library(dplyr)

exp_summary <- function(df, summary_var) {
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
  
  df %>% split(.$QUARTER) %>%
    map(~ .x %>% summary_exp(summary_var))
}

