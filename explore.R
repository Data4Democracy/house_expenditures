#Functions from repo
#Download repo
file_downloads <- c("https://pp-projects-static.s3.amazonaws.com/congress/staffers/2016Q3-house-disburse-detail.csv", 
                    "https://pp-projects-static.s3.amazonaws.com/congress/staffers/2015Q3-house-disburse-detail.csv", 
                    "https://pp-projects-static.s3.amazonaws.com/congress/staffers/2014Q3-house-disburse-detail.csv", 
                    "https://pp-projects-static.s3.amazonaws.com/congress/staffers/2013Q3-house-disburse-detail.csv", 
                    "https://pp-projects-static.s3.amazonaws.com/congress/staffers/2012Q3-house-disburse-detail.csv",
                    "https://pp-projects-static.s3.amazonaws.com/congress/staffers/2011Q3-house-disburse-detail.csv",
                    "https://pp-projects-static.s3.amazonaws.com/congress/staffers/2010Q3-house-disburse-detail.csv",
                    "https://pp-projects-static.s3.amazonaws.com/congress/staffers/2009Q3-house-disburse-detail.csv"
)

alldata <- lapply(file_downloads, function(x) {read.csv(x, stringsAsFactors = F)})

df <- do.call(rbind, alldata) # Combine into one dataset

#Clean data funciton
# Change class and remove commas
df$AMOUNT <- as.numeric(gsub(",", "", df$AMOUNT))

# Convert date variables to dates
df$START.DATE <- as.Date(df$START.DATE, format = "%m/%d/%y")
df$END.DATE <- as.Date(df$END.DATE, format = "%m/%d/%y")



library(dplyr)



# Create summary statistics for dispursements by quarter
summary_exp <- function(data_frame = NULL, ...) {
  # Create function for finding modal value
  modal <- function(x) {
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
  }
  data_frame %>% group_by_(..., 'QUARTER') %>%
    summarise(qrtly_exp = sum(AMOUNT),
            min_exp = min(AMOUNT), 
            max_exp = max(AMOUNT),
            sd_exp = sd(AMOUNT),
            avg_exp = mean(AMOUNT),
            modal_cat = modal(CATEGORY))
}

summarise_payee <- function(data_frame) {
  data_frame %>% group_by_('PAYEE', 'QUARTER') %>%
    summarise(yearly_exp = sum(AMOUNT),
               min_exp = min(AMOUNT), 
               max_exp = max(AMOUNT),
               sd_exp = sd(AMOUNT),
               avg_exp = mean(AMOUNT),
               modal_cat = modal(CATEGORY))
}
x <- summary_exp(df, "OFFICE")

x <- summary_by_quarter(data_frame = df, 'PAYEE')


by_office <- df %>%
  group_by(OFFICE, QUARTER) %>%
  summarise(yearly_exp = sum(AMOUNT),
            min_exp = min(AMOUNT), 
            max_exp = max(AMOUNT),
            sd_exp = sd(AMOUNT),
            avg_exp = mean(AMOUNT),
            modal_cat = modal(CATEGORY))



library(purrr)
library(tidyr)
