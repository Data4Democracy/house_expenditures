


##  This is a function used for exploration of US House Expenditures. Data were
##  obtained from the ProPublica website here: 
##  https://projects.propublica.org/represent/expenditures
##
##  Specifically, the function calculates the distances/similarities of text strings in
##  a variable, utilizing stringdist::stringdistmatrix. It takes 3 primary inputs:
##        data_:    a dataframe
##        var_:     the variable with the text/character inputs
##        method_:  the distance calculation method to use (e.g., Jaro-Winker, cosine, etc);
##
##  The function will return a dataframe as an output.



##  Load packages to be used
library("tidyverse")          # data manipulation
library("lazyeval")           # writing functions
library("rlang")              # writing functions
library("stringr")            # string manipulation
library("stringdist")         # calculating string (character) distances



func_dist <- function(data_, var_, method_ = "jw", ...){
  var_enquo <- enquo(var_)
  
  distinct_var <- select(data_,
                         !!var_enquo
                         ) %>% 
    distinct() %>%
    as.data.frame()
  
  distinct_var[is.na(distinct_var)
               ] <- "--"
  
  
  distance <- stringdistmatrix(distinct_var[ , 1],
                               useNames = "strings",
                               method = method_
                               )
  
  distance_matrix <- as.matrix(distance)
  
  distance_matrix[upper.tri(distance_matrix, diag = TRUE)
                  ] <- NA
  
  distance_matrix <- as.data.frame(distance_matrix) %>%
    mutate(level2 = rownames(distance_matrix)
           )
  
  
  score <- paste0(method_, "_score")
  var_chr <- deparse(substitute(var_)
                     )
  
  
  gather_data <- gather_(distance_matrix,
                         key_col = "level1",
                         value_col = score,
                         gather_cols = colnames(distance_matrix)[1:nrow(distinct_var)]
                         ) %>%
    mutate(var_og = var_chr) %>%
    select(var_og,
           level1,
           level2,
           score
           )
  
  
  filter_no_na <- filter(gather_data,
                         !is.na(gather_data[ ,4])
                         )
  
  
  return(filter_no_na)
}


