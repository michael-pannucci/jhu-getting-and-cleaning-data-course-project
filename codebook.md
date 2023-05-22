# Code Book: JHU Getting and Cleaning Data Course Project

## Source data

The source data for this project can be found at:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

## The run_analysis.R script

The script is organized into six parts:

0. Basic overhead and reading in the various source files
1. Task 1 - merge training and test data sets together into one
2. Task 2 - extract only the measurements containing the mean and standard deviation
3. Task 3 - use descriptive activity names to name the variables 
4. Task 4 - appropriately label each variable with descriptive variable names
5. Task 5 - create a second, independent data set containing the mean of each variable for each subject and activity

The comment blocks within the script detail how and why the various coding steps were taken to produce the desired result.
