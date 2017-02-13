# Reproducible Research: Peer Assessment 1
Evgeny Petrovsky  


## Loading and preprocessing the data


Data provided with assignment was unzipped into `./workdata/input` folder. Data resides in a file of CSV format with header. Data elements are: `steps`, `date`, `interval`. 
Loading the data using `read.csv()` and transforming object into table for firther manupulations

```r
activity <- read.csv(
  file = "./workdata/input/activity.csv", header = T, quote = "\"", 
  colClasses = c("numeric", "character", "character")
)
```

Here is how first records of data look like

```r
head(activity)
```

```
##   steps       date interval
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
## 3    NA 2012-10-01       10
## 4    NA 2012-10-01       15
## 5    NA 2012-10-01       20
## 6    NA 2012-10-01       25
```

Next step is to process/transform the data (if necessary) into a format suitable for analysis. 
columns 2 and 3 contain Date and Time, so we need to combine them into 1 value.
First let's translate time into HHMM format by adding leading zeros. Then create new attribute that contains time series in POSIXct format

```r
activity <- tbl_df(activity)

activity$date <- as.Date(activity$date)
```

## What is mean total number of steps taken per day?

Our dataset already has column with date, called `date`. Let's group by date and summarize steps within date just ignoring NA values. After that we can find average number of steps across all days.

```r
daysummary <- 
  activity %>% 
  group_by(date) %>% 
  summarize(stepsum = sum(steps, na.rm = T)) %>%
  select(stepsum)
```

This is histogram of the total number of steps taken each day.

```r
qplot(
  data = daysummary, x = stepsum, bins = 15,
  main = "Total number of steps taken each day",
  xlab = "Total number of steps", ylab = "Number of days"
)
```

![](pa1_files/figure-html/total steps hist-1.png)<!-- -->

Mean and Median values are

```r
daysummary %>% 
summarize(mean = mean(stepsum, na.rm = T), median = median(stepsum, na.rm = T))
```

```
## # A tibble: 1 × 2
##      mean median
##     <dbl>  <dbl>
## 1 9354.23  10395
```

## What is the average daily activity pattern?

In order to get average daily activity pattern we need to find interval averages across all days.
First we group data by interval, then we calculate averages removing all NA values, finally we build plot that shows average number of steps by intervals

```r
pattern <- 
  activity %>%
  group_by(interval) %>%
  summarize(avgsteps = mean(steps, na.rm = T))

qplot(
  data = pattern, x = as.numeric(interval), y = avgsteps, geom = "line", 
  main = "Dailty activity pattern", 
  xlab = "Interval", ylab = "Average number of steps"
)
```

![](pa1_files/figure-html/average steps by interval-1.png)<!-- -->

Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
arrange(pattern, desc(avgsteps))[1, ]
```

```
## # A tibble: 1 × 2
##   interval avgsteps
##      <chr>    <dbl>
## 1      835 206.1698
```

## Imputing missing values

Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

Let's calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)


```r
sum(is.na(activity$steps))
```

```
## [1] 2304
```

We will use a simple strategy for filling in all of the missing values in the dataset. Substitute **median** value for that 5-minute interval. Here we create a new dataset that is equal to the original dataset but with the missing data filled in.


```r
activity <- activity %>%
  inner_join(
    activity %>% 
      group_by(interval) %>% 
      summarize(mediansteps = median(steps, na.rm = T)) %>%
      select(interval, mediansteps)
  ) %>%
  mutate(impsteps = ifelse(is.na(steps), mediansteps, steps))
```

```
## Joining, by = "interval"
```

Let's look at histogram of the total number of steps taken each day ...


```r
impdaysummary <- 
  activity %>% 
  group_by(date) %>% 
  summarize(impstepsum = sum(impsteps, na.rm = T)) %>%
  select(impstepsum)

qplot(
  data = impdaysummary, x = impstepsum, bins = 15,
  main = "Total number of steps taken each day",
  xlab = "Total number of steps", ylab = "Number of days"
)
```

![](pa1_files/figure-html/imputed steps by day-1.png)<!-- -->

...and Calculate and report the mean and median total number of steps taken per day. 


```r
impdaysummary %>% 
summarize(mean = mean(impstepsum, na.rm = T), median = median(impstepsum, na.rm = T))
```

```
## # A tibble: 1 × 2
##       mean median
##      <dbl>  <dbl>
## 1 9503.869  10395
```

Do these values differ from the estimates from the first part of the assignment. Because we substitute missing values with median value for specific period. Median and mean values are close to each other. There is no impact of imputing missing data on the estimates of median value of the total daily number of steps and slight impact on mean value (because we used median for imputing)?

## Are there differences in activity patterns between weekdays and weekends?

We create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.

```r
activity <- activity %>%
  mutate(weekday = as.factor(ifelse(
    weekdays(activity$date) %in% c("Saturday", "Sunday"), 
    "weekend", "weekday"))
  )
```

We make a panel plot containing a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).


```r
wdpattern <- 
  activity %>%
  group_by(interval, weekday) %>%
  summarize(avgsteps = mean(impsteps, na.rm = T))

qplot(
  data = wdpattern, x = as.numeric(interval), y = avgsteps, geom = "line",
  facets = weekday ~ .,
  main = "Weekday / weekend activity pattern", 
  xlab = "Interval", ylab = "Average number of steps"
)
```

![](pa1_files/figure-html/wd pattern-1.png)<!-- -->
