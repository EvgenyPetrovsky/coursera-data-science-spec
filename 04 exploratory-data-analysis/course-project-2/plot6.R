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

fipsList <- data.frame(
  fips = c("06037", "24510"),
  State.Label = c("Los Angeles County", "Baltimore City")
)

allYears <- 
  # converting to tbl_df object of dplyr library and chaining
  tbl_df(NEI) %>% 
  # filtering data for Baltimore City by fips = 24510
  filter(fips %in% c("24510", "06037")) %>%
  # filtering data by motor vehicle related sources
  filter(SCC %in% motor$SCC) %>%
  # split data by year
  group_by(year, fips) %>%
  # calculate summaries
  summarize(Emissions = sum(Emissions, na.rm = T)) %>%
  # join with fipsList in order to have fips labels
  inner_join(y = tbl_df(fipsList))


# open png device
png("./workdata/output/plot6.png", width = 800, height = 500)

# plotting
plotObject <- 
  # initialize
  ggplot(allYears, aes(x = year, y = Emissions)) + 
  # add points for all years
  geom_point() + 
  # break plot into facets by emission type
  facet_grid(. ~ State.Label) + 
  # add title
  labs(title = "Emmissions from motor vehicle sources")
print(plotObject)

# save and close png
dev.off()
