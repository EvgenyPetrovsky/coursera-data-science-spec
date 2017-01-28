# reading datasets
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./workdata/input/summarySCC_PM25.rds")
SCC <- readRDS("./workdata/input/Source_Classification_Code.rds")

# function to calculate total emission
totalEmissions <- function(x) {sum(x$Emissions, na.rm = T)}

# subset data by fips (Baltimore City)
baltimoreCity <- subset(NEI, fips == "24510")

# split data by year
byYear <- split(baltimoreCity, f = baltimoreCity$year)

# mapping list elements into sum of Emissions
emissionsByYear <- sapply(byYear, totalEmissions)

# open png device
png("./workdata/output/plot2.png", width = 800, height = 500)

# plotting
plot(names(emissionsByYear), emissionsByYear, pch = 19, type = "b",
     main = "PM2.5 emission from all sources in Baltimore City",
     xlab = "Year", ylab = "Emissions"
     )

# save and close png
dev.off()
