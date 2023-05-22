################################################################################
# JHU Getting and Cleaning Data Course Project
################################################################################

# Load needed libraries and set up environment

library(data.table)
library(dplyr)

setwd("/Users/mpannucc/Documents/R/DS112/Project")
filename <- "project_data.zip"

# Checking if zip file alrady exists in the environment

if(!file.exists(filename)) {
    dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(dataURL, filename, method = "curl")
}

# Unzip

if(!file.exists("UCI HAR Dataset")) {
    unzip(filename)
}

# Load data sets, disable automatic naming of variables via HEADER = FALSE
# since the names contain many special characters

feature_names <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activity_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
features_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activity_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
features_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

################################################################################
# Task 1. Merge the training and test sets to create one data set.
################################################################################

# RBIND (row bind) function will concatenate each of the train and test data set pairs

subject <- rbind(subject_train, subject_test)
activity <- rbind(activity_train, activity_test)
features <- rbind(features_train, features_test)

# The column names for the subject and activity data sets are straightforward
# The column names for the features dataset are taken from the transposed figures_names.txt

colnames(subject) <- "Subject"
colnames(activity) <- "Activity"
colnames(features) <- t(feature_names[2])

# CBIND (column bind) everything into one data set

main <- cbind(subject, activity, features)

################################################################################
# Task 2. Extract only the measurements on the mean and standard deviation for 
# each measurement.
################################################################################

# The requested tidy data set will contain the key variables Subject and Activity
# as well as all columns that contain the mean and standard deviation for each
# measurement

tidy_data <- main %>%
    select(Subject, Activity, contains("mean"), contains("std"))

################################################################################
# Task 3. Use descriptive activity names to name the activities in the data set.
################################################################################

# We will treat Activity as a factor variable, so we proceed as follows:
#   (1) coerce it to character
#   (2) use the decodes provided in the activity_labels data set
#   (3) coerce the updated variable to a factor variable

# For good measure, we will also treat Subject as a factor variable

tidy_data$Activity <- as.character(tidy_data$Activity)
tidy_data$Activity <- activity_labels[tidy_data$Activity, 2]
tidy_data$Activity <- as.factor(tidy_data$Activity)
tidy_data$Subject <- as.factor(tidy_data$Subject)

################################################################################
# Task 4. Appropriately labels the data set with descriptive variable names.
################################################################################

# Per the provided data description, we replace the various abbreviations with 
# more understandable variable names

names(tidy_data) <- gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data) <- gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data) <- gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data) <- gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data) <- gsub("^t", "Time", names(tidy_data))
names(tidy_data) <- gsub("^f", "Frequency", names(tidy_data))
names(tidy_data) <- gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data) <- gsub("-mean()", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("-std()", "STD", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("-freq()", "Frequency", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("angle", "Angle", names(tidy_data))
names(tidy_data) <- gsub("gravity", "Gravity", names(tidy_data))

################################################################################
# Task 5. Create a second, independent tidy data set with the average of each 
# variable for each activity and each subject.
################################################################################

# The summarize_all function from {dplyr} will apply the mean function to all 
# variables in the data set (other than the group_by variables)

summary_data <- tidy_data %>%
    group_by(Subject, Activity) %>%
    summarize_all(.funs = mean)

################################################################################
# Write out the final datasets.
################################################################################

write.table(tidy_data, "tidy_data.txt", row.names = FALSE)
write.table(summary_data, "summary_data.txt", row.names = FALSE)