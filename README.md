#Read Me

The purpose of these scripts is to download third quarter data describing the 
House of Representative's expenditures. Running do.R will load, combine, and clean
all Q3 data.

You'll need to set your working directory.

These data and the remaining quarters can be found here: 

[https://projects.propublica.org/represent/expenditures](https://projects.propublica.org/represent/expenditures)

You can read more about this data set on [ProPublica's post](https://www.propublica.org/article/update-on-house-disbursements-a-few-notes-on-how-to-use-the-data).  

##Cleaning 

I removed commas from the dollar amounts and converted the start and end dates to the date 
format.  

##Next Steps
  
- I'll be working on functions that will identify basic statistics.  
- The office, payee, and recipient fields aren't standardized so unique entities 
that are spelled differently need to be collapsed into one value. You 
can read more about that problem under the "How We Collect the Data" section of 
[ProPublica's post](https://projects.propublica.org/represent/expenditures).