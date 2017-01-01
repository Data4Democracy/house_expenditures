library(dplyr)

# What is the total yearly expenditure for an office during the Q3 measurement?
by_office <- df %>%
  group_by(OFFICE, QUARTER) %>%
  summarise("yearly_exp" = sum(AMOUNT))

officeYearly <- function(office) {
  by_office[by_office$OFFICE == office, ]
}

# What is the total yearly expenditure paid to a payee during the Q3 measurement?
by_payee <- df %>%
  group_by(PAYEE, QUARTER) %>%
  summarise("yearly_exp" = sum(AMOUNT))

# The payee field needs to be cleaned up before this becomes useful
#payeeYearly <- function(payee) {
#  by_payee[by_payee$PAYEE == payee, ]
#}