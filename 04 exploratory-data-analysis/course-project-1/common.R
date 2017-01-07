# reads data from file
readdata <- function() {
  # file location
  fileloc <- "./workdata/input/household_power_consumption.txt"
  
  # reading file
  data <- read.table(fileloc, header = T, sep = ";", na.strings = "?",
                     colClasses = c("Date", "character", replicate(7, "numeric")))
  # substetting required period
  data <- subset(data, Date == "2007-02-01" | Date == "2007-02-02")
  
  # returning resulting dataset
  data
}