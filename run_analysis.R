#
#++++ Download zip file and unzip ++++++++++++++++++++++++++++++++++++++++++++#
#
fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
des <- "a.zip"
download.file(fileUrl,des,mode="wb")
unzip(zipfile = "a.zip")

#++++ Read files                 ++++++++++++++++++++++++++++++++++++++++++++#
xtrain   <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain   <- read.table("./UCI HAR Dataset/train/y_train.txt")
subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

xtest    <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest    <- read.table("./UCI HAR Dataset/test/y_test.txt")
subtest  <- read.table("./UCI HAR Dataset/test/subject_test.txt")

activitylabels  <- read.table("./UCI HAR Dataset/activity_labels.txt")
feature         <- read.table("./UCI HAR Dataset/features.txt")

# 4. Appropriately labels the data set with descriptive variable names.       #
colnames(xtest)   <- feature$V2
colnames(xtrain)  <- feature$V2
colnames(ytrain)  <- "activity"
colnames(ytest)   <- "activity"
colnames(subtrain) <- "subject"
colnames(subtest)  <- "subject"
colnames(activitylabels)  <- c("activity", "action")

# 1. Merges the training and the test sets to create one data set ++++++++++++#

trainmgd<- cbind(ytrain, subtrain, xtrain)
testmgd <- cbind(ytest, subtest, xtest)

data <- rbind(trainmgd, testmgd)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.#                         
datanames <- names(data)
indx <- (grepl("activity", datanames) |
         grepl("subject", datanames)  |
         grepl("mean..", datanames)   |
         grepl("std..", datanames)) 

subdata <- data[, indx==TRUE]

unique(data$activity)   # 6 activities
#   5 4 6 1 3 2
unique(data$subject)     # 30 subjects
#   1  3  5  6  7  8 11 14 15 16 17 19 21 22 23 25 26 27 28 29 30  2  4  9 10 12 13 18 20 24
data1 <- merge(subdata, activitylabels, by='activity', all.x=TRUE)

# 3. Uses descriptive activity names to name the activities in the data set   #
subdata$activity <- factor(subdata$activity, labels = activitylabels$action)

# 5. From the data set in step 4, creates a second, independent tidy data set # 
#   with the average of each variable for each activity and each subject      #
# library(plyr) 
# For each 6 activities there are 30 possible subjects                        #

data2 <- aggregate(. ~subject + activity, subdata, mean)
data2 <- data2[order(data2$subject, data2$activity), ]
write.table(data2, file="tidydataset.txt", row.names=FALSE)
str(data2)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#


