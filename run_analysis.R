x_test<- read.table("./test/X_test.txt", header=FALSE,sep="")
y_test<- read.table("./test/y_test.txt", header=FALSE,sep="")
subject_test<-read.table("./test/subject_test.txt", header=FALSE,sep="")

x_train<- read.table("./train/X_train.txt", header=FALSE,sep="")
y_train<- read.table("./train/y_train.txt", header=FALSE,sep="")
subject_train<-read.table("./train/subject_train.txt", header=FALSE,sep="")

test<-cbind(subject_test,y_test,x_test)
train<-cbind(subject_train,y_train,x_train)
data_set<-rbind(test,train)

features <- read.table("./features.txt",stringsAsFactors =FALSE, header=FALSE, sep="")
names(data_set)[3:563]<-features[,2]
names(data_set)[1]<-"Subject"
names(data_set)[2]<-"Activity"

labels <- read.table("./activity_labels.txt",stringsAsFactors =FALSE, header=FALSE, sep="")
for (i in 1:6){
  data_set$Activity[data_set$Activity ==i] <- labels[i,2]}

meanColumns<-grep("mean()",features[,2],fixed=TRUE)
stdColumns<-grep("std()",features[,2],fixed=TRUE)
columnsToSelect<-c(-1,0,meanColumns,stdColumns)
data_set1<-data_set[,columnsToSelect+2]

library(reshape2)
myMelt<-melt(data_set1,id=c("Subject","Activity"))
Final<-dcast(myMelt,Subject+Activity~variable,mean)

write.table(data_set1,file="myMergedData.txt",sep=" ",append=FALSE)
write.table(Final,file="myTidyData.txt",sep=" ",append=FALSE)
