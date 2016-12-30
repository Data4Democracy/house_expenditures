# If a folder called data doesn't exist, download create the folder and download
# the Q3 files from ProPublica.
if (file.exists("data") == FALSE) {
  dir.create("data")
  # Download Q3 detail files
  file_downloads <- c("https://pp-projects-static.s3.amazonaws.com/congress/staffers/2016Q3-house-disburse-detail.csv", 
                      "https://pp-projects-static.s3.amazonaws.com/congress/staffers/2015Q3-house-disburse-detail.csv", 
                      "https://pp-projects-static.s3.amazonaws.com/congress/staffers/2014Q3-house-disburse-detail.csv", 
                      "https://pp-projects-static.s3.amazonaws.com/congress/staffers/2013Q3-house-disburse-detail.csv", 
                      "https://pp-projects-static.s3.amazonaws.com/congress/staffers/2012Q3-house-disburse-detail.csv",
                      "https://pp-projects-static.s3.amazonaws.com/congress/staffers/2011Q3-house-disburse-detail.csv",
                      "https://pp-projects-static.s3.amazonaws.com/congress/staffers/2010Q3-house-disburse-detail.csv",
                      "https://pp-projects-static.s3.amazonaws.com/congress/staffers/2009Q3-house-disburse-detail.csv"
  )
  for (i in 1:length(file_downloads)) {
    download.file(file_downloads[i], paste0("data/", i, ".csv"), method = "curl")
  }
}

# Read files
files <- list.files("data", full.names = T, pattern = "*.csv")
df <- do.call(rbind, lapply(files, function(x) {read.csv(x, stringsAsFactors = FALSE)}))