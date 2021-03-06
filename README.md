Getting-and-Cleaning-Data
=========================

To upload the Course Project - Coursera- run_analysis.R


* First step: to import the relevant data from different tables provided from the original experiment and assign them to new variables as below:
		x_test<- read.table("./test/X_test.txt", header=FALSE,sep="")
		y_test<- read.table("./test/y_test.txt", header=FALSE,sep="")
		subject_test<-read.table("./test/subject_test.txt", header=FALSE,sep="")

		x_train<- read.table("./train/X_train.txt", header=FALSE,sep="")
		y_train<- read.table("./train/y_train.txt", header=FALSE,sep="")
		subject_train<-read.table("./train/subject_train.txt", header=FALSE,sep="")

	*Second step: to merge the acquired data appropriately : 
		test<-cbind(subject_test,y_test,x_test)
		train<-cbind(subject_train,y_train,x_train)
		data_set<-rbind(test,train)
	Now we have a data frame with 10299 rows and 563 columns. Which is also submitted as a .txt file called "myMergedData.txt". 

	*Third step: to read the features from the appropriate table and use them as column names for our new data_set:
		features <- read.table("./features.txt",stringsAsFactors =FALSE, header=FALSE, sep="")
		names(data_set)[3:563]<-features[,2]
	We should use these names for the "x" part of the data set which are our variables. We can name the first two columns manually as below:
		names(data_set)[1]<-"Subject"
		names(data_set)[2]<-"Activity"

	*Forth step: to read the activity labels from the appropriate file and replace the numeric values with descriptive activity names:
		labels <- read.table("./activity_labels.txt",stringsAsFactors =FALSE, header=FALSE, sep="")
		for (i in 1:6){
  			data_set$Activity[data_set$Activity ==i] <- labels[i,2]}	
	
	*Fifth step: To extract only the measurements on the mean and std for each measurement. The "Regular Expression" method has been used to select those columns containing the "mean()" and "std()" strings. 
		meanColumns<-grep("mean()",features[,2],fixed=TRUE)
		stdColumns<-grep("std()",features[,2],fixed=TRUE)
		columnsToSelect<-c(-1,0,meanColumns,stdColumns)
	Then we can create a new data set based on the "columnsToSelect"
		data_set1<-data_set[,columnsToSelect+2]

	*Sixth step: to create a second, independent tidy data set with the average of each variable for each activity and each subject using the "melt" and "cast" functions where "Subject" and "Activity" are our identifiers:
		library(reshape2)
		myMelt<-melt(data_set1,id=c("Subject","Activity"))
		Final<-dcast(myMelt,Subject+Activity~variable,mean)
	
	*Last step: to create two new .txt files to create our new tidy data sets: 
		write.table(data_set1,file="myMergedData.txt",sep="\t ",append=FALSE)
		write.table(Final,file="myTidyData.txt",sep="\t ",append=FALSE)
  

The result is a tidy data frame with 180 rows (6 activities*30 subjects) and 68 columns. The first column shows the measurements belong to which "Subject" , the second column describes the "Activity" with descriptive labels.  Rest columns (66 columns) are those measurements only on the mean and the standard deviation. 
