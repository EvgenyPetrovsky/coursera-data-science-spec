# reading set of common functions
source("common.R")

# reading dataset
epc <- readdata()

# opening PNG device
png(paste(lpar$outfolder, "plot2.png", sep = "/"))

# take Time (time) and Global Active Power (gap) from dataset
time <- epc$Time
gap  <- epc$Global_active_power

# initialise plot 
plot(time, gap, type = "n", xlab = "", ylab = "Global Active Power (kilowatts)")

# draw Time ~ Global Active Power line
lines(as.numeric(time), gap)

# closing PNG device (storing file)
dev.off()