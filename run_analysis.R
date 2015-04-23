## This shows the code used for this project.
getwd()
setwd("./data")
if(!file.exists("./data")){dir.create("./data")} #Downloading the file and put the file in the data folder
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
install.packages("curl")
library(curl)
download.file(fileUrl,destfile="./data/Dataset.zip", method="auto")
unzip(zipfile="./data/Dataset.zip",exdir="./data") #Unzipping the file
path_rf <- file.path("./data" , "UCI HAR Dataset") #unzipping files are in the folderUCI HAR Dataset and Getting the list of the files
files<-list.files(path_rf, recursive=TRUE)
files
dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE) #Reading the Activity files
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE) #Reading the Subject files
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE) #Reading Fearures files
str(dataActivityTest) #Getting variable properties
str(dataActivityTrain)
str(dataSubjectTrain)
str(dataSubjectTest)
str(dataFeaturesTest)
str(dataFeaturesTrain)
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest) #Concatenating the data tables by rows
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)
names(dataSubject)<-c("subject") #Setting names to variables
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2
dataCombine <- cbind(dataSubject, dataActivity) #Merging columns to get the data frame Data for all data
Data <- cbind(dataFeatures, dataCombine)
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)] #Subsetting Name of Features by measurements
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" ) #Subsetting the data frame Data by seleted names of Features
Data<-subset(Data,select=selectedNames)
str(Data) #Checking  data structure
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE) #Reading descriptive activity names from “activity_labels.txt”
head(Data$activity,30)
names(Data)<-gsub("^t", "time", names(Data)) #Labling data sets with descriptive variable names
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data) #Checking
library(plyr); #Second independent tiny data set
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
install.packages("knitr")
library(knitr) #Producing code book
getwd()
setwd("./data")
knit2html("codebook.Rmd");
