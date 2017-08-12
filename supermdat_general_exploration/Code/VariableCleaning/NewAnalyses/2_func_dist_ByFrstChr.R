


##  This is a function used for exploration of US House Expenditures. Data were
##  obtained from the ProPublica website here: 
##  https://projects.propublica.org/represent/expenditures
##
##  Specifically, the function calculates the distances/similarities of text strings in
##  a variable, utilizing stringdist::stringdistmatrix. It is identical to the function
##  func_dist except that func_dist_ByFrstChr does separate distance calculations for
##  those words that begin with the same character. For example, doing the calculation
##  only for words beginning with "a", then "b", then "c", etc. This is done because
##  some variables have a large amount of unique text entries, and the resources needed
##  to do the calculations on the entire dataset were too large for my laptop.
##
##  NOTE: This makes the implicit assumption that words that do not begin with the same
##        letter are not related.
##
##  The function takes 3 primary inputs:
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
# library("doParallel")         # used for parallel computing of this function



func_dist_ByFrstChr <- function(data2_, var2_, method2_ = "jw", p2_ = 0.1, ...){
  var2_enquo <- enquo(var2_)
  var2_chr <- deparse(substitute(var2_)
                      )
  
  Dstnct_var2 <- select(data2_,
                        !!var2_enquo
                        ) %>%
    distinct() %>% 
    mutate(FrstChr = substr(!!var2_enquo, 1, 1)
           ) %>% 
    filter(!is.na(FrstChr)
           ) %>% 
    arrange(!!var2_enquo)
  
  
  DstnctFrstChr <- Dstnct_var2 %>%
    select(FrstChr) %>%
    distinct() %>%
    mutate(RowNum = row_number()
           )
  
  
  # loop through based on the first letter in each entry for var2_
  FrstChrDistLst <- list()
  
  for(ltr in DstnctFrstChr$FrstChr){
    
    filter_by_ltr <- filter(Dstnct_var2,
                            FrstChr == ltr
                            )
    
    var2_dist <- func_dist(data_ = filter_by_ltr,
                           var_ = !!var2_enquo,
                           method_ = method2_,
                           p = p2_
                           ) 
    
    filter_for_RowNum <- filter(DstnctFrstChr,
                                FrstChr == ltr
                                )
    
    FrstChrDistLst[[filter_for_RowNum$RowNum]] <- var2_dist
  }
  
  
  method_score <- paste0(method2_, "_score")
  
  
  dist_ByFrstChr <- bind_rows(FrstChrDistLst) %>%
    mutate(l1_FrstChr = substr(level1, 1, 1),
           l2_FrstChr = substr(level2, 1, 1),
           l1_nChr = nchar(level1),
           l2_nChr = nchar(level2)
           ) %>% 
    select(-var_og) %>% 
    mutate(var_og = paste0(var2_chr, "_", l1_FrstChr)
           ) %>% 
    select(var_og,
           level1,
           level2,
           method_score,
           l1_FrstChr,
           l2_FrstChr,
           l1_nChr,
           l2_nChr
           )
  
  
  dist_ByFrstChr_arrange <- arrange(dist_ByFrstChr,
                                    dist_ByFrstChr[ , 4]
                                    )
  
  saveRDS(dist_ByFrstChr_arrange,
          paste0(var2_chr, "_", method2_, "_", "dist_ByFrstChr.Rds")
          )
  
  
  return(dist_ByFrstChr_arrange)
  
}


