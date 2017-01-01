# Getting and Cleaning Data Course Project
This course [project](https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project) for Getting and Cleaning data course of coursera Data Science specialization. Script was developed using R version 3.3.2.

## Folder contents
folder "course project" contains three files: 
1. codebook.md - assignmeng codebook
2. readme.md - this file
3. run_analysis.R - assignment script

## Requirements
In order to make script work some requirements should be met
* R installation should contain `dplyr` and `tidyr` packages installed (run install.packages in order to install)
* working directory should contain folder __./workdata/input__ with assignment [data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) (__UCI HAR Dataset__ folder should replaced into __workdata__ folder and renamed into __input__)

## Running script
Run R session and change working directory to that which contains script and workdata folder. Run script by typing `source("run_analysys.R")`. Script execution result will be stored in __./workdata/output/tidy.txt__ file in your working directory.

