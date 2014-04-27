## extract the contents of the  zip file from the following url into a folder called 
## 'UCI HAR Dataset' in your R session working directory:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## read files test and train files
# setwd(paste0(getwd(), "/", "uci_har_ML/uci_har_ML"))

# set vector with folder names
a <- c("test", "train")

# read in features (ie variable names) to rename columns in later step
feat <- read.table("./UCI HAR Dataset/features.txt", colClasses = "character")

# create vector of columns wanted (just those with mean() and std())
selectcols <- c(grep("mean()", feat$V2, fixed = TRUE), grep("std()", feat$V2, fixed = TRUE))

# for loop to read in each file
library(data.table)
library(dplyr)
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

# melt data frame to create one column with values for each of the variables
library(reshape2)
df <- melt(df, id = c("subject", "activity"))

# cast data frame so each variable has a column, take mean grouped by subject and activity
df <- dcast(df, subject + activity ~ variable, mean)
names(df)

# write.table to .txt file, pipe-delimited perhaps

# FOR CODEBOOK? CHECK FOR NAs
# apply(df[,1:66], 2, function(x) sum(is.na(x)))
