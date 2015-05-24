library(data.table)
# 0. load test and training sets and the activities

ileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(fileUrl, destfile = "getdata-projectfiles-UCI HAR Dataset.zip")
setwd("D:/My RDocuments/coursera/cour3quiz3/getdata-projectfiles-UCI HAR Dataset")
unzip("getdata-projectfiles-UCI HAR Dataset.zip", exdir = "getdata-projectfiles-UCI HAR Dataset")
list.files("getdata-projectfiles-UCI HAR Dataset")
test_x <- read.table("D:/My RDocuments/coursera/cour3quiz3/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("D:/My RDocuments/coursera/cour3quiz3/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
test_sub <- read.table("D:/My RDocuments/coursera/cour3quiz3/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
train_x <- read.table("D:/My RDocuments/coursera/cour3quiz3/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("D:/My RDocuments/coursera/cour3quiz3/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
train_sub <- read.table("D:/My RDocuments/coursera/cour3quiz3/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
test <- read.table("D:/My RDocuments/coursera/cour3quiz3/getdata-projectfiles-UCI HAR Dataset/X_test.txt")
train <- read.table("D:/My RDocuments/coursera/cour3quiz3/getdata-projectfiles-UCI HAR Dataset/X_train.txt")

# 3. Uses descriptive activity names to name the activities in the data set
activities <- read.table("D:/My RDocuments/coursera/cour3quiz3/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", colClasses = "character")
test_y$V1 <- factor(test_y$V1, levels = activities$V1, labels = activities$V2)
train_y$V1 <- factor(train_y$V1, levels = activities$V1,labels = activities$V2)

# 4. Appropriately label the data set with descriptive activity names
features <- read.table("D:/My RDocuments/coursera/cour3quiz3/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt", colClasses = "character")
colnames(test_x) <- features$V2
colnames(train_x) <- features$V2
colnames(test_y) <- "Activity"
colnames(train_y) <- "Activity"
colnames(test_sub) <- "Subject"
colnames(train_sub) <- "Subject"

# 1. merge test and training sets into one data set, including the activities
testData <- cbind(test_y, test_sub, test_x)
trainData <- cbind(train_y, train_sub, train_x)
allData <- rbind(testData,trainData)

# 2. extract only the measurements on the mean and standard deviation for each measurement
extract_col <- grepl("Activity|Subject|mean|std", names(allData))
extAllData <- allData[ , extract_col]


# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.
DT <- data.table(extAllData)
tidyData <- DT[ , lapply(.SD, mean), by = "Activity,Subject"]
write.table(tidyData, file = "tidy_data.txt", row.names = FALSE)
