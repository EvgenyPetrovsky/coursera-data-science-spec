# load libraries
library(dplyr)
library(ggplot2)

# read datasets
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./workdata/input/summarySCC_PM25.rds")
SCC <- readRDS("./workdata/input/Source_Classification_Code.rds")

# select all categories that belong to motor vehicle
motor <- 
  tbl_df(SCC) %>%
  # contains VEHICLE
  filter(grepl(pattern = "vehicle", x = SCC.Level.Two, ignore.case = TRUE)) %>%
  # if vehicle uses GASOLINE or DIESEL - it has motor
  filter(grepl(pattern = "gasoline|diesel", x = Short.Name, ignore.case = TRUE))

# list of fips required for plot
fipsList <- data.frame(
  fips = c("06037", "24510"),
  County = c("Los Angeles County", "Baltimore City")
)

allYears <- 
  # convert to tbl_df object of dplyr library and chaining
  tbl_df(NEI) %>% 
  # filter data for Baltimore City by fips = 24510
  filter(fips %in% fipsList$fips) %>%
  # filter data by motor vehicle related sources
  filter(SCC %in% motor$SCC) %>%
  # split data by year
  group_by(year, fips) %>%
  # calculate summaries
  summarize(Emissions = sum(Emissions, na.rm = T)) %>%
  # join with fipsList in order to have fips labels
  inner_join(y = tbl_df(fipsList))

# add 1999 year measurements values
firstYear <- allYears %>% 
  group_by(fips) %>% arrange(year) %>% slice(1) %>% ungroup %>%
  select(fips, First.Meas = Emissions) %>%
  inner_join(y = allYears, by = "fips")

# extend data with changes over time comparing to initial value
extended <- firstYear %>%
  mutate(Change = Emissions - First.Meas) %>%
  mutate(Change.in.Percent = (1 + (Emissions - First.Meas) / First.Meas) * 100) %>%
  select(year, County, Emissions, Change, Change.in.Percent)

# reshape data - gathering columns into rows
tidy <- tidyr::gather(extended, "Meas.Type", "Value", c(Emissions, Change, Change.in.Percent))
# reorder Measurement Types for plot
tidy$Meas.Type <- factor(tidy$Meas.Type, levels = c("Emissions", "Change", "Change.in.Percent"))

# open png device
png("./workdata/output/plot6.png", width = 500, height = 800)

# plotting
plotObject <- 
  # initialize, draw County with its own line
  ggplot(tidy, aes(x = year, y = Value, group = County, color = County)) + 
  # add lines
  geom_line() + 
  # break plot into facets by emission type and "free up" scale for different plots
  facet_grid(Meas.Type ~ ., scales = "free") + 
  # add title
  labs(title = "Emmissions from motor vehicle sources")
print(plotObject)

# save and close png
dev.off()
