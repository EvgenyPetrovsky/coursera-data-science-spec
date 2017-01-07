# reading set of common functions
source("common.R")

# reading dataset
epc <- readdata()

# opening PNG device
png(paste(lpar$outfolder, "plot1.png", sep = "/"))

#building histogram and annotating it
hist(epc$Global_active_power, col = "red", main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)")

# closing PNG device (storing file)
dev.off()