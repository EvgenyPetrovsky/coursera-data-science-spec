# Project codebook
This codebook describes dataset produced according to project requirements of __Getting and Cleaning Data Course__ and stored as __tidy.txt__ file.

## Set of attributes
there are only 4 attributes in dataset
1. __activity__ - activity name according to provided specification. Datatype is `CHARACHTER`. Possible values are: "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING".
2. __subject_id__ - person who performed activities. Datatype is `INTEGER`. There are 30 persons who recorded their activities - they are represented by numbers from 1 to 30.
3. __measurement__ - measurement that was taken during activity monitoring. Datatype is `CHARACTER`. Full list of measurements in [original data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) included 561 different values but only __mean__ and __std__ and measurements.
4. __mean(value)__ - mean value of measurement specified in previous column. Datatype is `NUMERIC`. Original data was summarized using MEAN function

## Transformations
Original data was downoladed from [link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), extracted from ZIP archive. Folder was into "workdata" and renamed into "input" so script uses this folder to reach data. Only few of many files are processed by script: 
* ./workdata/input/features.txt - feature (measurement) names
* ./workdata/input/activity_labels.txt - activity names
* ./workdata/input/train/X_train.txt - train data
* ./workdata/input/test/X_test.txt - test data
* ./workdata/input/train/y_train.txt - train data activities
* ./workdata/input/test/y_test.txt - test data activities
* ./workdata/input/train/subject_train.txt - train data subjects
* ./workdata/input/test/subject_test.txt - test data subjects

These files were processed in a following way
1. data from features.txt file is loaded and 2nd column taken as measurement names
2. test (X_test.txt) and train (X_train.txt) files are loaded and combined (train on top of test) using `rbind`. measurement names are loaded from eatures.txt file and assigned to dataset columns.
3. activity IDs from y\_test.txt and y\_train.txt files are loaded and combined after that they are joined (using `merge`) with activity labels (from activity\_labels.txt) file in order to get descriptive values instead of IDs 
4. information about subjects is loaded from subject\_test.txt and subject\_train.txt and combined into one dataset
5. data from 2 .. 4 is put together in following order: activity, subject, data.
6. after that only activity, subject and measurements that have __mean__ and __std__ in their name are selected
7. In order to produce tidy dataset required by assignment data from 6 is molten: all measurements variables are transormed into rows (from wide to long) using `gather` function of `tidyr` package. Measurement column received name __measurement__ and column containing numeric data is called __value__.
8. data from step 7 is grouped by (using `group_by`) __activity__, __subject__ and __measurement__ (kind) and mean of __values__ is calculated to `summarize` results.
9. produced dataset is stored as tidy.txt using `write.table`