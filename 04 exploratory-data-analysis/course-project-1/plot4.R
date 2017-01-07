# reading set of common functions
source("common.R")

# reading dataset
epc <- readdata()

# opening PNG device
png(paste(lpar$outfolder, "plot4.png", sep = "/"))

# setting up number of plots
par(mfrow = c(2, 2))

# initialise plot1
plot(epc$Time, epc$Global_active_power, 
     type = "n", xlab = "", ylab = "Global Active Power")

# draw Time ~ Global Active Power line
lines(as.numeric(epc$Time), epc$Global_active_power)

# initialise plot2
plot(epc$Time, epc$Voltage, 
     type = "n", xlab = "Date Time", ylab = "Voltage")

# draw Time ~ Global Active Power line
lines(as.numeric(epc$Time), epc$Voltage)

# initialise plot3
plot(epc$Time, epc$Sub_metering_1, 
     type = "n", xlab = "", ylab = "Energy Sub Metering")

# draw Time ~ Global Active Power line
lines(as.numeric(epc$Time), epc$Sub_metering_1, col = "black")
lines(as.numeric(epc$Time), epc$Sub_metering_2, col = "red")
lines(as.numeric(epc$Time), epc$Sub_metering_3, col = "blue")

# adding legend with colors and captions, line type is necessary to see color
# border is disabled by bty = "n" parameter
legend("topright", bty = "n", col = c("black", "red", "blue"), lty = c(1, 1, 1),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# initialise plot4
plot(epc$Time, epc$Global_reactive_power, 
     type = "n", xlab = "Date Time", ylab = "Global Reactive Power")

# draw Time ~ Global Active Power line
lines(as.numeric(epc$Time), epc$Global_reactive_power)

# closing PNG device (storing file)
dev.off()