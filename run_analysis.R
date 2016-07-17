# Script to create the required tidy dataset and the dataset with averages.

# Create your data directory if it doesn't already exist
if (!file.exists("coursera")) {
	dir.create("coursera")
}

# Download and unzip the data
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fname <- "./coursera/week4assignment.zip"
download.file(URL, destfile = fname, method="curl")
unzip(fname, exdir="./coursera")

# Load in the descriptions of the "features" (describing the readings eg tBodyAcc-std()-X)
library(data.table)
features <- fread("./coursera/UCI HAR Dataset/features.txt", sep=" ", col.names = c("feature_number", "feature_description"))

# Load in the descriptions of the activities (sitting, standing etc)
activities <- fread("./coursera/UCI HAR Dataset/activity_labels.txt", sep=" ", col.names = c("activity_number", "activity_description"))

# Load in the activity numbers for the training set and the test set
training_activity_numbers <- fread("./coursera/UCI HAR Dataset/train/y_train.txt", sep=" ", col.names = c("activity_number"))
testing_activity_numbers <- fread("./coursera/UCI HAR Dataset/test/y_test.txt", sep=" ", col.names = c("activity_number"))

# Load in the subjects for the training set and the test set
training_subject_numbers <- fread("./coursera/UCI HAR Dataset/train/subject_train.txt", sep=" ", col.names = c("subject_number"))
testing_subject_numbers <- fread("./coursera/UCI HAR Dataset/test/subject_test.txt", sep=" ", col.names = c("subject_number"))

# Load in the observations for the training set and the test set
training_observations <- fread("./coursera/UCI HAR Dataset/train/X_train.txt", sep=" ")
testing_observations <- fread("./coursera/UCI HAR Dataset/test/X_test.txt", sep=" ")

# We are going to create a tidy set with both training and test data

# Create a new tidy set and add the subject numbers from the training and the test set
tidy_set <- training_subject_numbers
tidy_set <- rbind(tidy_set, testing_subject_numbers)

# Now add a column containing the (training and testing) activity numbers
tidy_set <- cbind(tidy_set, rbind(training_activity_numbers, testing_activity_numbers))

# Now add a column containing the (training and testing) observations
tidy_set <- cbind(tidy_set, rbind(training_observations, testing_observations))

# Now add a column containing the descriptions of the activities
tidy_set <- merge(tidy_set, activities, by="activity_number")

# Now remove the column with the activity number
tidy_set <- subset(tidy_set, select=-activity_number)

# Now rename the unlabelled columns from the feature descriptions
names(tidy_set)[2:562] <- features$feature_description

# Now only take the columns with means and standard deviations
tidy_set <- subset(tidy_set, select = c(subject_number, activity_description, grep("mean()|std()", names(tidy_set))))

# Find the average (mean) of each measurement grouped by subject and activity
aggdata <- aggregate(tidy_set, by=list(tidy_set$subject_number, tidy_set$activity_description), FUN=mean, na.rm=TRUE)

# Now drop the columns subject_number and activity_description
aggdata <- subset(aggdata, select=c(-subject_number, -activity_description))

# Now rename the Group columns appropriately
names(aggdata)[1:2] <- c("subject_number", "activity_description")

# Now write the two files
write.table(tidy_set,"tidy_set.txt",row.names=FALSE)
write.table(aggdata,"averages.txt",row.names=FALSE)
