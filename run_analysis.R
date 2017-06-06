
library(dplyr)
library(tidyr)

filename <- "UCI_HAR_dataset.zip"

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzips the dataSet to the data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Reading the data into tables
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./data/UCI HAR Dataset/features.txt')
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

# Assinging the column names
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activityLabels) <- c('activityId','activityType')

# Merging the data into one complete data set
merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
total_data <- rbind(merge_train, merge_test)

# Assiging a column name object
colNames <- colnames(total_data)

# Find mean and standard deviation
mean_and_std <- (grepl("activityId" , colNames) | 
                     grepl("subjectId" , colNames) | 
                     grepl("mean.." , colNames) | 
                     grepl("std.." , colNames) 
)

mean_std_subset <- total_data[ , mean_and_std == TRUE]

merged_subset <- merge(mean_std_subset, activityLabels,
                              by='activityId',
                              all.x=TRUE)
second_tidySet <- aggregate(. ~subjectId + activityId, merged_subset, mean)
second_tidySet <- second_tidySet[order(second_tidySet$subjectId, second_tidySet$activityId),]

write.table(second_tidySet, "second_tidySet.txt", row.name=FALSE)
