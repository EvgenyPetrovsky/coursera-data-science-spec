# ingest data 
data <- read.csv("./data/payments.csv", header = T)

# NY data
ny_data <- subset(data, Provider.City == "NEW YORK")

# plot
with(
  ny_data, 
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