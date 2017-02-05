# ingest data 
insdata <- read.csv("./data/payments.csv", header = T)

# store global plotting param
oldpar <- list(mfrow = par("mfrow"), mar = par("mar"), oma = par("oma"))

#set global plotting parameters
par(mfrow = c(1, 1))

# plot 1 - Relationship between Covered Charges and Total Payments NYC
with(
  subset(insdata, Provider.City == "NEW YORK"), 
  plot(
    (Average.Total.Payments) ~ (Average.Covered.Charges), 
    log = "",
    main = "Relationship between Covered Charges and Total Payments \n in New York City",
    xlab = "Average covered charges (USD x 1000)",
    ylab = "Average total payments (USD x 1000)",
    asp = 3,
    pch = 19, col = adjustcolor("darkblue", alpha.f = .6)
  )
)

#set global plotting parameters
par(mfrow = c(6, 6), oma = c(2, 2, 2, 1), mar = c(0, 0, 0, 0))

# find ranges
covrng <- range(insdata$Average.Covered.Charges)
payrng <- range(insdata$Average.Total.Payments)

# iterate 
for (definition in unique(insdata$DRG.Definition)) {
  for (state in unique(insdata$Provider.State)) {
    
    # plot
    with(
      subset(insdata, DRG.Definition == definition & Provider.State == state), {
        plot(
          x = Average.Covered.Charges, y = Average.Total.Payments,
          xlim = covrng, ylim = payrng,
          pch = 19, col = DRG.Definition,
          log = "xy"
        )
        # to-do
        # split plot into operations (start with empty canvas)
        # for first line put states as titles
        # for first col put Y axis and labels
        # for last line put X axis and labels
      }
    )
  }
}

# restoring parameters
par(mfrow = oldpar$mfrow, mar = oldpar$mar, oma = oldpar$oma)
