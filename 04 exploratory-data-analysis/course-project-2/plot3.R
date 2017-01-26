# loading libraries
library(dplyr)
library(ggplot2)

# reading datasets
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./workdata/input/summarySCC_PM25.rds")
SCC <- readRDS("./workdata/input/Source_Classification_Code.rds")

# subset data by fips (Baltimore City)
baltimoreCity <- subset(NEI, fips == "24510")

byYearSource <- 
    # converting to tbl_df object of dplyr library and chaining
    tbl_df(baltimoreCity) %>% 
    # split data by year
    group_by(year, type) %>%
    # calculate summaries
    summarize(Emissions = sum(Emissions, na.rm = T))

# open png device
png("./workdata/output/plot3.png", width = 800, height = 500)

# plotting
plotObject <- qplot(
    year, Emissions, data = byYearSource, 
    geom = "line", facets = . ~ type, 
    main = "Emmissions by type in Baltimore City by type"
)
print(plotObject)

# save and close png
dev.off()
