run_analysis <-function(){
	
	#----------------------------------------------------
	# "Getting and cleaning Data" Course Project
	#----------------------------------------------------
	
	# Loading usefeul libraries
	
	library(dplyr);
	library(plyr);
	
	#----------------------------------------------------------------------
	# Step 1 :Merges the training and the test sets to create one data set.  
	#----------------------------------------------------------------------
	
	
	# Reading all "test files" - no header are included in those files
	
	X_test <- read.table("./test/X_test.txt");
	
	subject_test <- read.table("./test/subject_test.txt");
	
	# Changing the name of the "subject" variable (represents which subject was recorded)
	names(subject_test)<-"subject";
	
	# Changing the name of the "activity" variable (represents which activity the subject was doing)
	y_test <- read.table("./test/y_test.txt");
	names(y_test) <- "activity";
	
	# The two variables 'subject' and activity' are added to the measurements file ("test" part).
	# Their dimensions are (fortunately) compatible.
	
	final_test <- cbind(subject_test,y_test,X_test);
	
	# Reading all "train files" - no header are included in those files
	
	X_train <- read.table("./train/X_train.txt");
	
	subject_train <- read.table("./train/subject_train.txt");
	
	# Changing the name of the "subject" variable (represents which subject was recorded)
	names(subject_train)<-"subject";
	
	y_train <- read.table("./train/y_train.txt");

	# Changing the name of the "activity" variable (represents which activity the subject was doing)
	names(y_train) <- "activity";
	
	# The two variables 'subject' and activity' are added to the measurements file ("train" part).
	# Their dimensions are (fortunately) compatible.

	final_train <- cbind(subject_train,y_train,X_train);

	# The final dataset is a row-binding of the test and train files.
	# Both files contain the same (huge) number of variables.
	
	final_df <- rbind(final_test,final_train);
	
	# Transformation to a tbl_df (in order to use dplyr package)
	final_df <- tbl_df(final_df);
	
	# Function of the dplyr package. The data set is sorted according to the subjects.
	
	final_df <- arrange(final_df,subject)
	
	#----------------------------------------------------------------------
	# Step 2 : extracts only the measurements on the mean and standard 
	# deviation for each measurement
	#----------------------------------------------------------------------
	
	# Reading the features file, which contains the 'names' of the variables.
	
	features <- read.table("features.txt",stringsAsFactors = FALSE);
	features <- tbl_df(features);
	
	# Using filter (dplyr package) with grepl to find which variables are mean or std.
	# This will give tbl_df objects of dimension nrows x 2, where nrow is the number of 
	# interesting variables.
	
	extractmean <- filter(features, grepl("mean()",features$V2,fixed = TRUE));
	extractstd  <- filter(features, grepl("std()",features$V2,fixed = TRUE));
	
	# Using select (dplyr package) to select those columns. The first columns of extractmean
	# and extractstd contains the numbers of the interesting variables.
	
	extract_df <- select(final_df,subject,activity,extractmean$V1+2,extractstd$V1+2)
	
	#----------------------------------------------------------------------
	# Step 3 : Uses descriptive activity names to name the activities 
	# in the data set
	#----------------------------------------------------------------------
	
	# Reading the activity labels file.
	labels <- read.table("activity_labels.txt");
	
	# Using lower cases instead of upper cases
	labels$V2 <- tolower(labels$V2);
	# Using no underscore.
	labels$V2 <- sub("_"," ",labels$V2);
	
	# Transforming the activity variable (which was of class int) to a factor variable
	extract_df$activity <- factor(extract_df$activity);
	
	# Changing the levels of the factor variable (with the modified names)
	levels(extract_df$activity) <- labels$V2;
	
	#----------------------------------------------------------------------
	# Step 4 : Appropriately labels the data set with descriptive
	# variables names.
	#----------------------------------------------------------------------
	
    # The names of the variables are currently V1,V2, etc. They should be replaced with a
    # modified version of what we can found in the features file.
    
    # We first keep only the names of the extracted variables.
    
     keptfeatures <- rbind(extractmean,extractstd);
     
    # The names are put in lower cases, underscore and () are removed. 
     keptfeatures$V2 <- tolower(keptfeatures$V2);
     keptfeatures$V2 <- gsub("-","",keptfeatures$V2)
     keptfeatures$V2 <- gsub("\\(\\)","",keptfeatures$V2)
     
    # "t" or "f" as first letters are supposed to mean "time" or "frequency", so
    # we change the names in favor of more explicit ones.
    
	# finding names beginning with "t"    
     tto <- (regexpr("t",keptfeatures$V2)==1)
     # changing "t" to "time"
     keptfeatures$V2[tto]<- sub("t","time",keptfeatures$V2[tto])
     
     # finding names beginning with "f"  
     fto <- (regexpr("f",keptfeatures$V2)==1)
     # changing "f" to "freq"
     keptfeatures$V2[fto]<- sub("f","freq",keptfeatures$V2[fto])
     
     # "x","y" or "z" as last letters are supposed to represent an axis, so add this term
     # to the concerned names.
     
     # extract the last letter or every variable names
     lastl <- substr(keptfeatures$V2,nchar(keptfeatures$V2),nchar(keptfeatures$V2)+1)
     # check if those are "x","y", or "z" (or a different letter)
	 lastletter <- (lastl == "x") | (lastl=="y") | (lastl=="z")	
	 # adding "axis" if needed
	 keptfeatures$V2[lastletter]<- paste0(keptfeatures$V2[lastletter],"axis")
	 
	 # Add those better names to the data set.
	 extract_df <- setNames(extract_df,c("subject","activity",keptfeatures$V2))

	#----------------------------------------------------------------------
	# Step 5 : From the data set in step 4, creates a second, independent
	# tidy data set with the avarage of each variable for each activity 
	# and each subject.
	#----------------------------------------------------------------------

	 # Using group_by() (dplyr package) to group the data set by subject and activity
	 gr_extract_df <- group_by(extract_df,subject,activity);
	 
	 #Using summarise_each() to compute the average of each variable for each "group".
	 
	 tidy <- summarise_each(gr_extract_df,funs(mean))
	
	 # Returning the tidy data set.
	 tidy;
	
}


