# Change this path where value with the 
setwd("/home/gbartolotta/Coursera/cleaning_data/project")

filename <- "getdata_dataset.zip"
today <- format(Sys.Date(), "%Y-%m-%d")
# directory where to store the datasets to analyze
directoryName <- paste(today, "data", sep = "_")

## Download file
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
        download.file(fileURL, filename, method="curl")
}

# unzip the dataset
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}

# Rename the directory accordigly with the date
if(!dir.exists(directoryName)){
        file.rename("UCI HAR Dataset", directoryName)
}

# Load activity labels and features
activityLbl <- read.table(paste(directoryName, "activity_labels.txt", sep = "/"))
activityLbl[,2] <- as.character(activityLbl[,2])
features <- read.table(paste(directoryName, "features.txt", sep = "/"))

# Extract and clean the data containing mean and standard deviation
featuresReq <- grep(".*mean.*|.*std.*", as.character(features[,2]))
featuresReq.names <- features[featuresReq,2]
featuresReq.names = gsub('-mean', 'Mean', featuresReq.names)
featuresReq.names = gsub('-std', 'Std', featuresReq.names)
featuresReq.names <- gsub('[-()]', '', featuresReq.names)

# Load the train dataset
trainDS <- read.table(paste(directoryName, "train", "X_train.txt", sep = "/"))[featuresReq]
trainAct <- read.table(paste(directoryName, "train", "y_train.txt", sep = "/"))
trainSubj <- read.table(paste(directoryName, "train", "subject_train.txt", sep = "/"))
trainDS <- cbind(trainSubj, trainAct, trainDS)

# load test dataset 
testDS <- read.table(paste(directoryName, "test", "X_test.txt", sep = "/"))[featuresReq]
testAct <- read.table(paste(directoryName, "test", "y_test.txt", sep = "/"))
testSubj <- read.table(paste(directoryName, "test", "subject_test.txt", sep = "/"))
testDS <- cbind(testSubj, testAct, testDS)

# merge datasets and add labels
allData <- rbind(trainDS, testDS)
colnames(allData) <- c("subject", "activity", featuresReq.names)

# turn activities and subjects into factors
# map activities into the data set
allData$activity <- factor(allData$activity, levels = activityLbl[,1], labels = activityLbl[,2])
# mapping the subject
allData$subject <- as.factor(allData$subject)

write.table(allData, "tidy_dataset.txt", row.names = FALSE, quote = FALSE)

library(plyr)
# Evaluate the mean for all columns but the subject and activity
allDataColMeans <- function(df){ 
        colMeans(df[,-c(1,2)]) 
}

tidyMeans <- ddply(allData, c("subject", "activity"), allDataColMeans)
names(tidyMeans)[-c(1,2)] <- paste("Mean", names(tidyMeans)[-c(1,2)], sep = "")

# Write file
write.table(tidyMeans, "tidy_dataset_with_mean.txt", row.names = FALSE, quote = FALSE)
