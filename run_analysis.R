## DOWNLOAD THE FILES

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")


## OPEN THE FILES

y_test  <- read.table("y_test.txt" ,header = FALSE)
y_train <- read.table("y_train.txt",header = FALSE)
subject_train <- read.table("subject_train.txt",header = FALSE)
subject_test  <- read.table("subject_test.txt",header = FALSE)
x_test  <- read.table("X_test.txt",header = FALSE)
x_train <- read.table("X_train.txt",header = FALSE)

## MERGE THE TRAIN AND TEST FILES

subject <- rbind(subject_train, subject_test)
y<- rbind(y_train, y_test)
x<- rbind(x_train, x_test)

## GIVE THE NAMES 

names(subject)<-c("subject")
names(y)<- c("activity")
x_names <- read.table("features.txt",head=FALSE)
names(x)<- x_names$V2

## SELECT THE VARIABLES IN FEATURES

selected <-x_names$V2[grep("mean\\(\\)|std\\(\\)", x_names$V2)]
data1<-x[,c(as.character(selected))]

## MERGE THE FEATURE, SUBJECT AND ACTIVITY FILES

data2 <- cbind(data1, subject, y)

## GIVE THE LABELS TO ACTIVITY

descriptive_activity_names<- read.table("activity_labels.txt",head=FALSE)
names(descriptive_activity_names)<-c("activity","describeactivity")
data3 <- merge(data2, descriptive_activity_names , by="activity", all.x=TRUE)

## ADJUST THE NAMES OF THE COLUMNS

names(data3)<-gsub("std()", "SD", names(data3))
names(data3)<-gsub("mean()", "Mean", names(data3))
names(data3)<-gsub("^t", "Time", names(data3))
names(data3)<-gsub("^f", "Frequency", names(data3))
names(data3)<-gsub("Acc", "Accelerometer", names(data3))
names(data3)<-gsub("Gyro", "Gyroscope", names(data3))
names(data3)<-gsub("Mag", "Magnitude", names(data3))
names(data3)<-gsub("BodyBody", "Body", names(data3))

## CREATE A TIDY DATA WITH AVERAGE OF VARIABLES, ACTIVITY AND SUBJECTS

library(dplyr)
data4<-aggregate(. ~subject + describeactivity, data3, mean)
write.table(data4, file = "tidydata.txt",row.name=FALSE)
