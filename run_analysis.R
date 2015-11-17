
##Read the Features.txt file into R
##convert Features labels to unique acceptable labels in R
features<-read.table("features.txt", col.names=c("Feature","Feature_Name"))
features$Feature_Name<-make.names(features$Feature_Name, unique=TRUE)

##Read the wearable computing datasets into R and bind into one dataset
weartrain<-read.table("x_train.txt")
weartest<-read.table("x_test.txt")
weardf<-rbind(weartrain,weartest)
library(data.table)
wear<-data.table(weardf)

##Read the Subject datasets into R and bind to one dataset - change column name
weartrainsub<-read.table("subject_train.txt")
weartestsub<-read.table("subject_test.txt")
wearsub<-rbind(weartrainsub,weartestsub)
colnames(wearsub)<-"Subject"

##Read the Activityclass datasets into R and bind to one dataset - change column name
weartrainAC<-read.table("y_train.txt")
weartestAC<-read.table("y_test.txt")
wearAC<-rbind(weartrainAC,weartestAC)
colnames(wearAC)<-"Activityclass"

##Add the Subject and Activityclasses as variables-columns to the datasets
wear$Subject<-wearsub
wear$Activityclass<-wearAC

##Add column anmes to the combined dataset based on unique feature names
colnames(wear)<-c(features[,2],"Subject","Activityclass")

##Select out only the mean and standard deviation for each measurement
library(dplyr)
wearstat<-select(wear,Subject,Activityclass,
                 contains("mean"),contains("std"))

##Name the activities in the dataset by replacing the
##number with the name from the activity_labels.txt file
actlab<-read.table("activity_labels.txt")
wearstat$Activityclass<-actlab$V2[match(wearstat$Activityclass,actlab$V1)]

##Create second dataset called Avewear calculating
##average for each activity and each subject using summarise_each function
ordwear<-arrange(wearstat,Subject)

avewear<-ordwear %>%
        group_by(Subject,Activityclass) %>%
        summarise_each(funs(mean),contains("mean"),contains("std"))

                   
                   
                   