# reads data from file
readdata <- function() {
  # file location
  fileloc <- "./workdata/input/household_power_consumption.txt"
  
  # reading file
  data <- read.table(fileloc, header = T, sep = ";", na.strings = "?",
                     colClasses = c("character", "character", replicate(7, "numeric")))
  # substetting required period
  data <- subset(data, Date == "1/2/2007" | Date == "2/2/2007")
  
  # returning resulting dataset
  data
}