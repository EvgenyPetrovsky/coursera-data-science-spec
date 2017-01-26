# reading datasets
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./workdata/input/summarySCC_PM25.rds")
SCC <- readRDS("./workdata/input/Source_Classification_Code.rds")

# function to calculate total emission
totalEmissions <- function(x) {sum(x$Emissions, na.rm = T)}

# split data by year
byYear <- split(NEI, f = NEI$year)

# mapping list elements into sum of Emissions
emissionsByYear <- sapply(byYear, totalEmissions)

# open png device
png("./workdata/output/plot1.png", width = 800, height = 500)

# plotting
plot(names(emissionsByYear), emissionsByYear, pch = 19, type = "b",
     main = "Total PM2.5 emission from all sources",
     xlab = "Year", ylab = "Emissions"
     )

# save and close png
dev.off()
