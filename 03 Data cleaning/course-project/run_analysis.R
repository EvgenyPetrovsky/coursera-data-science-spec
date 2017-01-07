# this script processes data according to "Getting and Cleaning Data Course Project"
# (https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project)
# steps of assignment implemented in different order. Step results are highlighted by 
# " STEP N - ... " comment

# Data files are already extracted into "workdata" folder.
# script should be executed from working directory containing "workdata".

# loading libraries: dplyr for manipulation and tidyr for reshaping
library(dplyr)

# defining file paths
featfile      <- "./workdata/input/features.txt"
actlblfile    <- "./workdata/input/activity_labels.txt"
trainfile     <- "./workdata/input/train/X_train.txt"
testfile      <- "./workdata/input/test/X_test.txt"
acttestfile   <- "./workdata/input/test/y_test.txt"
acttrainfile  <- "./workdata/input/train/y_train.txt"
subjtestfile  <- "./workdata/input/test/subject_test.txt"
subjtrainfile <- "./workdata/input/train/subject_train.txt"
tidyfile      <- "./workdata/output/tidy.txt"

# reading feature names from file and storing them as vector
feature <- read.delim(
  featfile, sep = " ", header = F, colClasses = "character"
  )[[2]]

# reading activity labels
actlabel <- read.table(
  file = actlblfile,
  sep = "",
  header = F,
  col.names = c("activity_id", "activity")
)
# reading train data
train <- read.table(file = trainfile, header = F, sep = "", 
                    colClasses = "numeric", col.names = feature)
# reading test data
test <- read.table(file = testfile, header = F, sep = "",
                   colClasses = "numeric", col.names = feature)
# STEP 1 - merge training and test datasets
data <- rbind(train, test)

# adding activity labels and persons
acttrain <- read.table(file = acttrainfile, header = F,
                       col.names = "activity_id")
acttest <- read.table(file = acttestfile, header = F,
                       col.names = "activity_id")
# combine activity data
activity <- rbind(acttrain, acttest)

# STEP3 - use descriptive activity names megre activity data and labels
activity <- merge(x = activity, y = actlabel)[2]

# reading subjects data
subjtrain <- read.table(file <- subjtrainfile, header = F, 
                        col.names = "subject_id")
subjtest  <- read.table(file <- subjtestfile, header = F, 
                        col.names = "subject_id")
# merge subjects data
subject <- rbind(subjtrain, subjtest)

# STEP4 - use all variables in dataset are labeled. 
# put activities subjects and measurements together
data <- cbind(activity, subject, data)

# convert data to tbl class
data <- tbl_df(data)


# STEP2 - extract only means and standard deviations
data1 <- data %>% 
  select( activity, subject_id, contains(".mean"), contains(".std") )


# STEP5
# find summaries for measurement values
# melt dataset
molten <- tidyr::gather(data, measurement, value, -activity, -subject_id, na.rm = T)
# assign group condition and summarize
data2 <- molten %>% 
  group_by(activity, subject_id, measurement) %>%
  summarise(mean(value))

# writing data2 to file for submission
if (file.exists(tidyfile)) file.remove(tidyfile)
write.table(data2, file = tidyfile, col.names = T, row.names = F)