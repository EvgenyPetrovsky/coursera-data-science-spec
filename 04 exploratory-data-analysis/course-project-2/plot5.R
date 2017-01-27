# loading libraries
library(dplyr)
library(ggplot2)

# reading datasets
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./workdata/input/summarySCC_PM25.rds")
SCC <- readRDS("./workdata/input/Source_Classification_Code.rds")

motor <- 
  tbl_df(SCC) %>%
  # contains VEHICLE
  filter(grepl(pattern = "vehicle", x = SCC.Level.Two, ignore.case = TRUE)) %>%
  # if vehicle uses GASOLINE or DIESEL - it has motor
  filter(grepl(pattern = "gasoline|diesel", x = Short.Name, ignore.case = TRUE))

allYears <- 
  # converting to tbl_df object of dplyr library and chaining
  tbl_df(NEI) %>% 
  # filtering data for Baltimore City by fips = 24510
  filter(fips == "24510") %>%
  # filtering data by motor vehicle related sources
  filter(SCC %in% motor$SCC) %>%
  # split data by year
  group_by(year) %>%
  # calculate summaries
  summarize(Emissions = sum(Emissions, na.rm = T))

# open png device
png("./workdata/output/plot5.png", width = 800, height = 500)

# plotting
plot(allYears$year, allYears$Emissions, pch = 19, type = "b", 
     ylim = c(0, max(allYears$Emissions, na.rm = T)),
     main = "Emissions from motor vehicle sources in Baltimore City",
     xlab = "Year", ylab = "Emissions"
)

# save and close png
dev.off()
