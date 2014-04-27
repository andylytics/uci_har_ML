Codebook for the UCI Human Activity Research Coursera Project
---------------
Begin by [downloading the zip file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) provided on the course page. Information on the contents of the file can be found on the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) site for the Human Activity Recognition Using Smartphones Data Set.

Extract the contents of the `getdata_projectfiles_UCI HAR Dataset.zip` into your working directory. You should now have a `UCI HAR Dataset` folder with a series of files and subfolders.

The `run_analysis.R` script performs the following:

* Merges the `test` and `train` data sets (found in `X_test.txt` and `X_train.txt`)
* Adds descriptive column names for the feature variables (found in the `features.txt` file)
* Subsets the merged data set to include only the mean and standard deviation variables. These were indicated by `mean()` and `std()` in the respective variable names. This reduced the number of variables from 561 to 66.
* Adds a column to indicate the study subject (found in `subject_test.txt` and `subject_train.txt`)
* Adds a column to indicate the activity the subject was performing (found in `y_test.txt` and `y_train.txt`)
* Uses the activity labels found in `activity_labels.txt` to replace the numbers indicating activity with descriptive text (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)

After these transformations the data frame `df` will consist of 10,299 observations (rows) and 68 variables (columns). The script then takes the mean of each variable grouped by subject and activity, resulting in a data frame with 180 observations (the mean for each feature for six activities for each of the 30 subjects).

Finally the script write/exports a pipe-delimited ("|") flat file named `tidydata.txt` to the working directory.

Note the script uses the following R packages: `data.table`, `reshape2` and `dplyr`. Each of the packages are available on the CRAN repository and can be installed using the `install.packages` fucnction in R. The `dplyr` package requires R version 3.0 or higher. You can download and install the latest version of R [here](http://www.r-project.org/).