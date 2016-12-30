# Change class and remove commas
df$AMOUNT <- as.numeric(gsub(",", "", df$AMOUNT))

# Convert date variables to dates
df$START.DATE <- as.Date(df$START.DATE, format = "%m/%d/%y")
df$END.DATE <- as.Date(df$END.DATE, format = "%m/%d/%y")