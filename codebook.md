Getting and cleaning data course project : codebook
====================================================


This codebook describes the data set `tidydata.txt` obtained when running `run_analysis.R`
on the original data given for this project. A readme file is also present, which explains
how the analysis works.

The original data come from the "Human Activity Recognition Using Smartphones Dataset" experiment,
whose authors are :

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit‡ degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

Original dataset 
-------------------

The original experiments are described in the readme of the original data set : 

_The experiments have been carried out with a group of 30 volunteers within an age bracket
of 19-48 years. Each person performed six activities (WALKING, WALKING\_UPSTAIRS, 
WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) 
on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear 
acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have
been video-recorded to label the data manually. The obtained dataset has been randomly 
partitioned into two sets, where 70% of the volunteers was selected for generating the 
training data and 30% the test data._

_The sensor signals (accelerometer and gyroscope) were pre-processed by applying 
noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap
(128 readings/window). The sensor acceleration signal, which has gravitational and body 
motion components, was separated using a Butterworth low-pass filter into body acceleration 
and gravity. The gravitational force is assumed to have only low frequency components, 
therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of 
features was obtained by calculating variables from the time and frequency domain._

In the original dataset, the following data can be found : 

_For each record it is provided:_


_- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration._
_- Triaxial Angular velocity from the gyroscope._
_- A 561-feature vector with time and frequency domain variables._
_- Its activity label._
_- An identifier of the subject who carried out the experiment._

_The dataset includes the following files:_

_- 'README.txt'_

*- 'features_info.txt': Shows information about the variables used on the feature vector.*

_- 'features.txt': List of all features._

*- 'activity_labels.txt': Links the class labels with their activity name.*

*- 'train/X_train.txt': Training set.*

*- 'train\y_train.txt': Training labels.*

*- 'test/X_test.txt': Test set.*

*- 'test/y_test.txt': Test labels.*

_The following files are available for the train and test data. Their descriptions are equivalent._

*- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.*

*(Missing text about (non-used) inertial signals).*

_Notes:_ 

_- Features are normalized and bounded within [-1,1]._  
_- Each feature vector is a row on the text file._  

_For more information about this dataset contact: activityrecognition@smartlab.ws_

It should be first noted that the Inertial signals were not used.

Transformations 
-----------------
When running the analysis, the following transformations are made :

1) A data set is created which contains 563 columns (the subject 
identificator (called `subject`), the activity identificator (called `activity`) and the 
561 measured features).
When melting together the test and train measurements, this data set contains 
7352+2947 = 10299 rows. This set is sorted according to the subject id.

2) Only the variables related to the measurements mean or standard deviation are kept for the following. 
Using the info from the `features.txt` file, it is possible to select only the columns which
corresponds to those variables (their names should contain `mean()` or `std()`). After this 
selection, the data set is of dimension 10299*68 (subject, activity and 66 measured variables).

3) At this time, the activity variable is of class int. This is modified in order to obtain
a `factor` variable. For the sake of clarity, the numbers are replaced with the corresponding
activity names. Moreover, those labels are improved (lower cases, no underscores). The levels
of the activity variable are thus : "walking", "walking upstairs", "walking downstairs",
"sitting", "standing" and "laying".

4) The names of the variables are not explicit at all : V1, V2, V3,... They are modified using
the info available in `features.txt`. Those names do not respect the usual standards,
and are thus modified (lower cases, no underscores, no parentheses, and a better explanation
of the actual variables).

The original data give the following info about the features :

_The features selected for this database come from the accelerometer and gyroscope 3-axial_
_raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time)_
_were captured at a constant rate of 50 Hz. Then they were filtered using a median filter_
_and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove_
_noise. Similarly, the acceleration signal was then separated into body and gravity_
_acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth_
_filter with a corner frequency of 0.3 Hz._

_Subsequently, the body linear acceleration and angular velocity were derived in time to_
_obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these_
_three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag,_
_tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag)._

_Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing_
_fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag,_
_fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals)._

_These signals were used to estimate variables of the feature vector for each pattern:_
_'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions._

_tBodyAcc-XYZ_  
_tGravityAcc-XYZ_  
_tBodyAccJerk-XYZ_  
_tBodyGyro-XYZ_  
_tBodyGyroJerk-XYZ_  
_tBodyAccMag_  
_tGravityAccMag_  
_tBodyAccJerkMag_  
_tBodyGyroMag_  
_tBodyGyroJerkMag_  
_fBodyAcc-XYZ_  
_fBodyAccJerk-XYZ_  
_fBodyGyro-XYZ_  
_fBodyAccMag_  
_fBodyAccJerkMag_  
_fBodyGyroMag_  
_fBodyGyroJerkMag_  

_The set of variables that were estimated from these signals are:_

_mean(): Mean value_  
_std(): Standard deviation_  

In the final data set, the "t" and "f" (for "time" and "frequence") become respectively
"time" and "freq". Each axial signal is indicated by "xaxis" (resp. "yaxis" and "zaxis").

The values (and their unities) are conserved.

5) The final data set represents a "grouped" version of the preceding ones. One group represents
all the observations from one subject performing one activity. They are thus 180 groups (rows
in the data set). For the 66 variables, only the mean over each group is given.

Final data set 
----------------
The final tidy data set (named `tidy`) is thus of dimension 180*68.

The 68 variables are :

- `subject` : of class int, ranges between 1 and 30. Tells which subject was recorded.
- `activity` : of class factor, with 6 levels : "walking", "walking upstairs", "walking downstairs",
	"sitting", "standing" and "laying". Tells what the subject was doing.
- 66 variables of class num. Those can be "time" measurements or "freq" values. Their names
are related to what was measured, and in which direction (if applicable). They represent the 
mean (for one subject doing one activity) of mean or standard deviation of the original measurements.

Bibliography
--------------
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.


