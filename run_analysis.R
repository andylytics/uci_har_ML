## ***NOTE*** start by extracting the contents of the zip file from the following url into a
## in your R session working directory:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## you should now have a folder called 'UCI HAR Dataset' in your working directory

# set vector with folder names
a <- c("test", "train")

# read in features (ie variable names) to rename columns in later step
feat <- read.table("./UCI HAR Dataset/features.txt", colClasses = "character")

# create vector of columns wanted (just those with mean() and std())
selectcols <- c(grep("mean()", feat$V2, fixed = TRUE), grep("std()", feat$V2, fixed = TRUE))

## for loop to read in each file

# load packages
require("data.table")
require("dplyr")

i <- 1
for (i in i:length(a)){
  # read data for test and train
  data <- read.table(paste0("./UCI HAR Dataset/" ,a[i], "/X_", a[i], ".txt"), header = FALSE)
  
  # rename column names
  names(data) <- feat$V2
  
  # limit data frame to just mean() and std() columns
  data <- data[, selectcols]
  
  # add subject column
  subject <- read.table(paste0("./UCI HAR Dataset/" ,a[i], "/subject_", a[i], ".txt"), header = FALSE)
  data$subject <- subject$V1
  
  # add activity column
  activity_code <- read.table(paste0("./UCI HAR Dataset/" ,a[i], "/y_", a[i], ".txt"), header = FALSE)
  data$activity_code <- activity_code$V1
  
  ## rename activity values using activity_labels.txt
  activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
  
  # rename columns to allow use of inner_join() function from dplyr package
  names(activity_labels) <- c("activity_code", "activity")
  data <- inner_join(data, activity_labels, by = "activity_code")
  
  # remove unneeded activity_code column
  data <- select(data, -activity_code)
  
  # if/then to rbind test and train
  if (i == 1){
    df <- data
  }
  else {
    df <- rbind_list(df, data)
  }
}

# cleanup: remove workspace objects no longer needed
rm(data, activity_code, activity_labels, feat, subject, a, i, selectcols)

## melt data frame to create one column with values for each of the variables

# laod package
require("reshape2")
df <- melt(df, id = c("subject", "activity"))

# cast data frame so each variable has a column, take mean grouped by subject and activity
df <- dcast(df, subject + activity ~ variable, mean)

# write.table data frame to tidydata.txt file in working directory, pipe-delimted "|"
write.table(df, file = "tidydata.txt", sep = "|", quote = FALSE, row.names = FALSE)