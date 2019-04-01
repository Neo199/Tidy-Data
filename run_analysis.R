library(plyr)

# Download and unzip the file:
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, "finaldata.zip", method="curl")
if(!file.exists("./UCI HAR Dataset")) {
    unzip("finaldata.zip")
}
dateDownloaded <- now()

# Reading Files:
x_train    <- read.table("./UCI HAR Dataset/train/X_train.txt")
x_test     <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_train    <- read.table("./UCI HAR Dataset/train/Y_train.txt")
y_test     <- read.table("./UCI HAR Dataset/test/Y_test.txt")
sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
sub_test  <- read.table("./UCI HAR Dataset/test/subject_test.txt")
actl <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

# Merging the Data
xFeaD <- rbind(x_train, x_test)
yActD <- rbind(y_train, y_test)
subd <- rbind(sub_train, sub_test)

# set names to variables
names(subd)   <- "subject"
names(yActD) <- "activity"
names(xFeaD) <- featuresNames$V2

# Merging all datas in one
nd <- cbind(xFeaD, yActD, subd)

#cols with mean & std
ms_features <- featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]

# subset the desired columns
selcol <- c(as.character(ms_features), "subject", "activity" )
nd <- subset(nd, select=selcol)

# update values
nd$activity <- actl[nd$activity, 2]

names(nd) <-gsub("^t", "time", names(nd))
names(nd) <-gsub("^f", "frequency", names(nd))
names(nd) <-gsub("Acc", "Accelerometer", names(nd))
names(nd) <-gsub("Gyro", "Gyroscope", names(nd))
names(nd) <-gsub("Mag", "Magnitude", names(nd))
names(nd) <-gsub("BodyBody", "Body", names(nd))

fd <- ddply(nd, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(finalData, "tidy.txt", row.name=FALSE)
