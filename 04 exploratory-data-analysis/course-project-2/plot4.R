# loading libraries
library(dplyr)
library(ggplot2)

# reading datasets
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./workdata/input/summarySCC_PM25.rds")
SCC <- readRDS("./workdata/input/Source_Classification_Code.rds")

SCCcoal <- 
  tbl_df(SCC) %>%
  # contains COAL
  filter(grepl(pattern = "coal", x = Short.Name, ignore.case = TRUE)) %>%
  # contains COMBUSTION
  filter(grepl(pattern = "comb", x = Short.Name, ignore.case = TRUE))

allYears <- 
  # converting to tbl_df object of dplyr library and chaining
  tbl_df(NEI) %>% 
  # filtering data by coal combustion related sources
  filter(SCC %in% SCCcoal$SCC) %>%
  # split data by year
  group_by(year) %>%
  # calculate summaries
  summarize(Emissions = sum(Emissions, na.rm = T))

# open png device
png("./workdata/output/plot4.png", width = 800, height = 500)

# plotting
plot(allYears$year, allYears$Emissions, pch = 19, type = "b",
     main = "Emissions from coal combustion-related sources across the United States",
     xlab = "Year", ylab = "Emissions"
)

# save and close png
dev.off()
