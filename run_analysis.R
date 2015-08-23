# Initial setup, download and unzip data set
setwd("./getting_data/")
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists("dataset.zip")) {
    download.file(fileURL, "dataset.zip", method = "curl")
}

unzip("dataset.zip")

# Loading training data
train_X <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train_Y <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
train_subjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Feature names
features <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = F)

# assemble training data set
train <- train_X
names(train) <- features$V2
train$subject <- train_subjects[[1]]
train$activity <- train_Y[[1]]

#cleanup
rm(train_Y)
rm(train_subjects)
rm(train_X)

# assemble test data
test_X <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test_Y <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
test_subjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# putting test data together
test <- test_X
names(test) <- features$V2
test$subject <- test_subjects[[1]]
test$activity <- test_Y[[1]]

# cleanup
rm(test_X)
rm(test_Y)
rm(test_subjects)
rm(features)

# put everything together
dataset <- rbind(train, test, make.row.names= T)

library(dplyr)

# Make syntactically valid column names, otherwise we get duplicate columns error
names <- make.names(names(dataset), unique = T)
names(dataset) <- names

# create data frame table
clean <- tbl_df(dataset)

# reorder columns, keep only mean and std columns
clean <- select(clean, subject, activity, contains("mean"), contains("std"))

# Activity labels
activity <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# Join data with activity labels
clean <- merge(clean, activity, by.x = "activity", by.y= "V1")

# Rename activity_label column, reorder,  and remove extra columns
clean <- rename(clean, activity_label = V2)
clean <- select(clean, subject, activity_label, -activity, 3:89)

# Create grouped data set by subject and activity
clean_grouped <- group_by(clean, subject, activity)
avg <- summarize(clean_grouped, mean(3:89))

# Write output
write.table(avg, "avg.txt", row.names = F)
