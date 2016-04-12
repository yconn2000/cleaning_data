library(plyr)
##set WD to this project
setwd('./cleaningdata/UCI HAR Dataset')

# Read in the data from files
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

##1. Merges the training and the test sets to create one data set.
x_ttl <- rbind(x_train, x_test)
y_ttl <- rbind(y_train, y_test)
subject_ttl <- rbind(subject_train, subject_test)

##2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt")
meanstd <- grep("-(mean|std)\\(\\)", features[, 2])
x_ttl <- x_ttl[, meanstd]
names(x_ttl) <- features[meanstd, 2]

##3. Uses descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")
y_ttl[, 1] <- activities[y_ttl[, 1], 2]
names(y_ttl) <- "activity"

##4. Appropriately labels the data set with descriptive variable names

names(subject_ttl) <- "subject"
all_all <- cbind(x_ttl, y_ttl, subject_ttl)

##5. From the data set in step 4, creates a second, independent tidy data set 
##   with the average of each variable for each activity and each subject

final_table <- ddply(all_all, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(final_table, "averages_data.txt", row.name=FALSE) 

##set WD back to it was before
setwd('c:/users/Admin B/Documents/R')
