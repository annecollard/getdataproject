getdataproject
==============
__Getting and cleaning data : Course project__

This README is related to the run_analysis.R function. The origin of the data, and the
explanation of the final tidy data set can be found in the codebook (codebook.md file).

Starting from the original data of the "Human Activity Recognition Using Smartphones Dataset
Version 1.0", the run_analysis.R code does the following.

0) - It is assumed that the data set is in the current directory, with its original subfolders "test"
and "train".
   - The useful packages "dplyr" and "plyr" are loaded.
   
1) _Step 1 of the project : This part merges the training and the test sets to create one data set._

First, we read all "test files" - no header are included in those files
After checking the dimensions of each file, it is easy to understand how to connect them.
Indeed, `X_test`, `y_test` and `subject_test` contains the same number of observations (rows).
Moreover, `y_test` and `subject_test` contains a single column. For the sake of clarity, 
those columns are renamed `subject` (for the `subject_test` file) and `activity` (for the `y_test` file).
Those can be binded to the`X_test` using `cbind()`. This table is called `final_test`.

The same procedure is applied to the `train` files, to produce the `final_train` table.

Both tables contains the same number of variables, and can thus be binded using `rbind()`.
This `final_df` table is then converted to a `tbl_df` table (compatible with dplyr package).
The rows are sorted with respect to the subjects id, using `arrange()` (from the dplyr package).

Note : we decided to not use the inertial data.

2) _Step 2 : extracts only the measurements on the mean and standard 
   deviation for each measurement_
   
Explanations on the measurements can be found in `features_info.txt` and `features.txt`.
Based on those explanations, we decided to only keep the measurements whose names contain 
`mean()` or `std()`.

We first read the features names, using `stringsAsFactors = FALSE`.
Then, we use `filter()` (dplyr package) with `grepl()` to find which variables names contain `mean()` or `std()`.
This will give tbl_df objects (`extractmean` and `extractstd`) of dimension `nrows x 2`, 
where `nrows` is the number of interesting variables (here, 66).

Finally, we use `select()` (dplyr package) to select those columns. The first columns of extractmean
and extractstd contains the numbers of the interesting variables. We pay attention to also
keep the subject and activity variable (the first two columns). This table is called `extract_df`.

3) _Step 3 : Uses descriptive activity names to name the activities in the data set_

The activities' names can be found in `activity_labels.txt`. 
We first read this file. We then transform the names : using lower cases instead of upper cases,
and deleting the underscores.

In `extract_df`, the activity variable is a char. We change this, in order to obtain a factor variable.
Finally, we change the levels of the factor variable with the modified names.


4) _Step 4 : Appropriately labels the data set with descriptive variables names._

The names of the variables are currently V1,V2, etc. They should be replaced with a
modified version of what we can found in `features.txt`. We start from the
two tables `extractmean` and `extractstd`, that we bind together using `rbind()`.
The names are put in lower cases, underscore and parenthesis are removed (thanks to `gsub()`). 

"t" or "f" as first letters are supposed to mean "time" or "frequency" domain, so
we change the names in favor of more explicit ones. We use `regexpr()`, and the fact that the 
found occurrence should be at index 1.

"x","y" or "z" as last letters are supposed to represent an axis, so we add this term to 
the concerned names.
  
We use `substr()` to extract the last letter or every variable names and then check if those 
are "x","y", or "z" (or a different letter). We then add (with `paste0()`) "axis" if necessary.

The improved names are then set to the appropriate columns.

5) _Step 5 : From the data set in step 4, creates a second, independent tidy data set 
with the avarage of each variable for each activity and each subject._

We use `group_by()` (dplyr package) to group the data set by `subject` and `activity`.
It is then easy to use `summarise_each()` to compute the average of each variable 
for each "group". This produces a final tidy data set, called `tidy`, which is returned at the 
end of this function. The explanation of this data frame can be found in the code book.
