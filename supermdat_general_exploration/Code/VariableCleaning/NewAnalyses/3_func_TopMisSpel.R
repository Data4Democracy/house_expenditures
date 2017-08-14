


##  This is a function used for exploration of US House Expenditures. Data were
##  obtained from the ProPublica website here: 
##  https://projects.propublica.org/represent/expenditures
##
##  Specifically, the function uses hunspell::hunspell_check to identify mis-spellings
##  and/or spelling variations of any of the words in a character variable. This can then
##  be used to manually make spelling adjustments.
##
##  The function takes 2 primary inputs:
##        data_:    a dataframe
##        var_:     the variable with the text/character inputs
##
##  The function will return a dataframe as an output.



##  Load packages to be used
library("tidyverse")          # data manipulation
library("lazyeval")           # writing functions
library("rlang")              # writing functions
library("stringr")            # string manipulation
library("tidytext")           # text manipulation
library("hunspell")           # used for spell checking



func_TopMisSpel <- function(data_, var_){
  var_enquo <- enquo(var_)


  distinct_var <- select(data_,
                         !!var_enquo
                         ) %>%
    distinct() %>%
    mutate(RowNum = row_number()
           )


  var_chr <- deparse(substitute(var_)
                     )


  unnest_words <- unnest_tokens_(tbl = distinct_var,
                                 input = var_chr,
                                 output = "word"
                                 )


  word_stats <- group_by(unnest_words,
                         word
                         ) %>%
    summarise(RowNum_Min = min(RowNum),
              WordCnt_Num = n()
              )


  word_details <- select(unnest_words,
                         word
                         ) %>%
    distinct() %>%
    left_join(word_stats,
              by = c("word" = "word")
              ) %>%
    left_join(distinct_var,
              by = c("RowNum_Min" = "RowNum")
              )


  spell_check <- mutate(word_details,
                        Correct = hunspell_check(toupper(word)
                                                 )
                        ) %>%
    filter(Correct == FALSE) %>%
    arrange(desc(WordCnt_Num)
            )


  all_word_stats <- spell_check %>%
    mutate(WordCnt_Pct = WordCnt_Num / sum(WordCnt_Num) * 100,
           WordCnt_NumCum = cumsum(WordCnt_Num),
           WordCnt_PctCum = cumsum(WordCnt_Pct)
           ) %>%
    select(word,
           WordCnt_Num,
           WordCnt_NumCum,
           WordCnt_Pct,
           WordCnt_PctCum,
           RowNum_Min,
           !!var_enquo,
           Correct
           )


  return(all_word_stats)
}


