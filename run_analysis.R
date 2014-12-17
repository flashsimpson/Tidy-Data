library(plyr)
library(data.table)
library(reshape2)
##read in all the ".txt" files
##test folder
ytest<- read.table("./test/y_test.txt")
xtest<- read.table("./test/x_test.txt")
subjecttest<- read.table("./test/subject_test.txt")
##train folder
ytrain<- read.table("./train/y_train.txt")
xtrain<- read.table("./train/x_train.txt")
subjecttrain<- read.table("./train/subject_train.txt")
##features and activites lables
features<- read.table("./features.txt", sep=" ")
activity_labels<- read.table("./activity_labels.txt")

## attach features to x test/train col names
colnames(xtest)<- features$V2
colnames(xtrain)<- features$V2
##give subjects and activites header names
colnames(subjecttrain)[1]<- "subjects"
colnames(subjecttest)[1]<- "subjects"
colnames(ytest)[1]<- "activities"
colnames(ytrain)[1]<- "activities"
##combine test data set with subject id's and activites
datatest<- cbind(subjecttest, ytest, xtest)
##combine train data set with subject id's and activites
datatrain<- cbind(subjecttrain, ytrain, xtrain)
##merge test and train data frames
dataset<- rbind(datatest, datatrain)
##apply activities as factor names
dataset$activities<- as.factor(dataset$activities)
## set factor levels for activities
dataset$activities<- factor(dataset$activities, labels=activity_labels$V2)
## create vector with all column names with std or mean, as well as subjects and activities
subname<- grep("mean|std|subjects|activities", names(dataset), value=TRUE)
## subset based on previous vector
subdata<- dataset[,subname]
##  Create new data frame with summarised values for each subjects different activites
## melt data frame to make tall tidy data 
newdata<- melt(subdata, id=c("subjects", "activities"), measure.vars=subname[3:81])
newdata2<- dcast(newdata, subjects + activities ~ variable, mean)
newdata3<- melt(newdata2, id=c("subjects", "activities"), measure.vars=subname[3:81])
newdata3<- arrange(newdata3, subjects, activities)
setnames(newdata3, "value", "mean_value")

## write data frame to txt file



write.table(newdata2, file="tidydata.txt", row.name=FALSE)
