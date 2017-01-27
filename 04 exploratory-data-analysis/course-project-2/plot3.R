# loading libraries
library(dplyr)
library(ggplot2)

# reading datasets
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./workdata/input/summarySCC_PM25.rds")
SCC <- readRDS("./workdata/input/Source_Classification_Code.rds")

allYears <- 
    # converting to tbl_df object of dplyr library and chaining
    tbl_df(NEI) %>% 
    # filtering data for Baltimore City by fips = 24510
    filter(fips == "24510") %>%
    # split data by year
    group_by(year, type) %>%
    # calculate summaries
    summarize(Emissions = sum(Emissions, na.rm = T))

limYears <- allYears %>%
    # filter by 1999 and 2008 years only
    filter(year %in% c(1999, 2008))
  

# open png device
png("./workdata/output/plot3.png", width = 800, height = 500)

# plotting
plotObject <- 
    # initialize
    ggplot(allYears, aes(x = year, y = Emissions)) + 
    # add points for all years
    geom_point() + 
    # add lines connecting 1999 and 2008
    geom_line(data = limYears, aes(x = year, y = Emissions), color = 2, lwd = 1) + 
    # break plot into facets by emission type
    facet_grid(. ~ type) + 
    # add title
    labs(title = "Emmissions by type in Baltimore City")
print(plotObject)

# save and close png
dev.off()
