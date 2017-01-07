# some variables
lpar = list()
lpar$infolder   = "./workdata/input"
lpar$outfolder  = "./workdata/output"
lpar$epcfileloc = paste(lpar$infolder, "household_power_consumption.txt", sep = "/")
lpar$zipfileloc = paste(lpar$infolder, "household_power_consumption.zip", sep = "/")
lpar$epcdataurl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"


# reads data from file
readdata <- function() {
  # file location
  # check if file exists and if not .... create folders, download file, unzip
  if (!file.exists(lpar$epcfileloc)) {createfolders(); downloaddata()}
    
  # reading file
  data <- read.table(lpar$epcfileloc, header = T, sep = ";", na.strings = "?",
                     colClasses = c(replicate(2, "character"), 
                                    replicate(7, "numeric")))
  # substetting required period
  data <- subset(data, Date == "1/2/2007" | Date == "2/2/2007")
  
  # returning resulting dataset
  data
}

# creates folder structure
createfolders <- function() {
  if (dir.exists("./workdata")) unlink("./workdata", recursive = T)
  sapply(c(lpar$infolder, lpar$outfolder), dir.create, recursive = T)
  TRUE
}

# downloads assignment datafile
downloaddata <- function() {
  download.file(url = lpar$epcdataurl, destfile = lpar$zipfileloc)
  unzip(zipfile = lpar$zipfileloc, exdir = lpar$infolder, overwrite = T)
}
