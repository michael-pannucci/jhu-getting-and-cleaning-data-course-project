# Code Book: JHU Getting and Cleaning Data Course Project

## Source data

The source data for this project can be found at:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

## The run_analysis.R script

The script is organized into six parts:

### 0. Basic overhead and reading in the various source files

This section activates the needed libraries and reads in the various source files. The automatic naming of the variables is disabled via HEADER = FALSE since the names contain many special characters.

### 1. Task 1 - merge training and test data sets together into one

RBIND (row bind) function will concatenate each of the train and test data set pairs. The column names for the subject and activity data sets are straightforward. The column names for the features dataset are taken from the transposed figures_names.txt. CBIND (column bind) will merge everything into one data set.

### 2. Task 2 - extract only the measurements containing the mean and standard deviation

A straightforward use of the select() function from {dplyr} will keep only the Subject and Activity variables as well as any containing "mean" or "std" (via the contains() function.

### 3. Task 3 - use descriptive activity names to name the variables 

We will treat Activity as a factor variable, so we proceed as follows:
  - coerce it to character
  - use the decodes provided in the activity_labels data set
  - coerce the updated variable to a factor variable

For good measure, we will also treat Subject as a factor variable.

### 4. Task 4 - appropriately label each variable with descriptive variable names

Per the provided data description, we replace the various abbreviations with more understandable variable names:

- Acc --> Accelerometer
- Gyro --> Gyroscope
- BodyBody --> Body
- Mag --> Magnitude
- t --> Time (only when at the beginning, hence ^t)
- f --> Frequency (only when at the beginning, hence ^f)
- tBody --> TimeBody
- -mean() --> Mean
- -std() --> STD
- -freq() --> Frequency
- angle --> Angle
- gravity --> Gravity

### 5. Task 5 - create a second, independent data set containing the mean of each variable for each subject and activity

The summarize_all function from {dplyr} will apply the mean function to all variables in the data set (other than the group_by variables).
