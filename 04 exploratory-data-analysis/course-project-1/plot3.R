# reading set of common functions
source("common.R")

# reading dataset
epc <- readdata()

# opening PNG device
png(paste(lpar$outfolder, "plot3.png", sep = "/"))

# take Time (time) and Sub meterings 1..3 from dataset
time <- epc$Time
sub1 <- epc$Sub_metering_1
sub2 <- epc$Sub_metering_2
sub3 <- epc$Sub_metering_3

# initialise plot 
plot(time, sub1, type = "n", xlab = "", ylab = "Energy Sub Metering")

# draw Time ~ Global Active Power line
lines(as.numeric(time), sub1, col = "black")
lines(as.numeric(time), sub2, col = "red")
lines(as.numeric(time), sub3, col = "blue")

# adding legend with colors and captions, line type is necessary to see color
legend("topright", col = c("black", "red", "blue"), lty = c(1, 1, 1),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# closing PNG device (storing file)
dev.off()