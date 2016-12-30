# Download and read Q3 detail files
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