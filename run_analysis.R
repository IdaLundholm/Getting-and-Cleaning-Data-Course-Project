library(plyr)
library(data.table)

download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', 'Dataset.zip')
unzip('Dataset.zip')

#Read the feature names to use as column names
column_labels <- read.table('UCI HAR Dataset/features.txt')

#Combine test and training set for all features and add column names
test_set_x <- read.table('UCI HAR Dataset/test/X_test.txt')
train_set_x <- read.table('UCI HAR Dataset/train/X_train.txt')
x_set <- rbind(test_set_x, train_set_x)
colnames(x_set) <- column_labels[,2]

#Select only features of mean and standard deviation
logical_vector <- grepl('mean\\(\\)|std\\(\\)', column_labels[,2])
selected_x_set <- x_set[logical_vector]

#Read and merge activities data
test_set_y <- read.table('UCI HAR Dataset/test/y_test.txt')
train_set_y <- read.table('UCI HAR Dataset/train/y_train.txt')
y_set <- rbind(test_set_y, train_set_y)
colnames(y_set) <- c('activity')

#Convert from numerical data to factor
y_set[[1]] <- factor(y_set[[1]])

#Rename the factors to activity names
y_set[[1]] <- mapvalues(y_set[[1]], from = as.character(1:6), to = c('walking', 'walkingupstairs', 'walkingdownstairs', 'sitting', 'standing', 'laying'))

#Read and merge subject data
subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt')
subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt')
subject <- rbind(subject_test, subject_train)
colnames(subject) <- 'subject'

#Merge features, activities and subject data into one dataset
merged_data <- cbind(y_set, subject, selected_x_set)

#Reshape into a new tidy dataset with each subject and activity and mean of every feature variable
melted_data <- melt(merged_data, id=c('subject', 'activity'))
cast_data <- dcast(melted_data, subject + activity ~ variable, mean)

