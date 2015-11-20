# Getting_Cleaning_Data
##Course Project

## DOWNLOAD THE FILES
-The comands below will download the Course Projet file and save in your working directory

* fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
* download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

## OPEN THE FILES
-The comands below will read all the 6 files

* y_test  <- read.table("y_test.txt" ,header = FALSE)
* y_train <- read.table("y_train.txt",header = FALSE)
* subject_train <- read.table("subject_train.txt",header = FALSE)
* subject_test  <- read.table("subject_test.txt",header = FALSE)
* x_test  <- read.table("X_test.txt",header = FALSE)
* x_train <- read.table("X_train.txt",header = FALSE)

## MERGE THE TRAIN AND TEST FILES
-The comands below will merge the train file and the test file in one file

* subject <- rbind(subject_train, subject_test)
* y<- rbind(y_train, y_test)
* x<- rbind(x_train, x_test)

## GIVE THE NAMES 
-The comands below will give a name for the variables of dataframes

* names(subject)<-c("subject")
* names(y)<- c("activity")
* x_names <- read.table("features.txt",head=FALSE)
* names(x)<- x_names$V2

# SELECT THE VARIABLES IN FEATURES
-The first comand will list all the observaion in x_name list and return which one the word mean or sd (standard deviation) appears
-The second comand will subset the original dataframe only in the columns where those words appears
* selected <-x_names$V2[grep("mean\\(\\)|std\\(\\)", x_names$V2)]
* data1<-x[,c(as.character(selected))]

# MERGE THE FEATURE, SUBJECT AND ACTIVITY FILES
-The comand below will marge the 3 file to have just one big file with informations about the subject, the activity and the feature
* data2 <- cbind(data1, subject, y)

# GIVE THE LABELS TO ACTIVITY
-The comand below read a table with the describe of activity numbers, and the it will merge the first file with the describe activity file
-Based on activity number it will possible to joint the two files
* descriptive_activity_names<- read.table("activity_labels.txt",head=FALSE)
* names(descriptive_activity_names)<-c("activity","describeactivity")
* data3 <- merge(data2, descriptive_activity_names , by="activity", all.x=TRUE)

# ADJUST THE NAMES OF THE COLUMNS
-The comands below will look to the structure of the word, and give more specific and completed meanings to then

* names(data3)<-gsub("std()", "SD", names(data3))
* names(data3)<-gsub("mean()", "Mean", names(data3))
* names(data3)<-gsub("^t", "Time", names(data3))
* names(data3)<-gsub("^f", "Frequency", names(data3))
* names(data3)<-gsub("Acc", "Accelerometer", names(data3))
* names(data3)<-gsub("Gyro", "Gyroscope", names(data3))
* names(data3)<-gsub("Mag", "Magnitude", names(data3))
* names(data3)<-gsub("BodyBody", "Body", names(data3))

# CREATE A TIDY DATA WITH AVERAGE OF VARIABLES, ACTIVITY AND SUBJECTS
-The comands below will aggregate the dataframe based in subject and activity takinh the average of the feature variable
-The last comand will save the tidy data file in a txt format in your working directory

* library(dplyr)
* data4<-aggregate(. ~subject + describeactivity, data3, mean)
* write.table(data4, file = "tidydata.txt",row.name=FALSE)
