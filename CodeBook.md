# This is a code book for the course evaluation

## Variables
The Variables in the data sets (tidy_set.csv and averages.csv) are named in https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The only two new ones are:
- subject_number which is the number of the person participating in the experiment, who was being measured.  This is a number from 1-30.
- activity_description which is the activity the subject was doing when being measured (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)

## Data
The data were taken from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Both the training sets and test sets were used and combined into one set.

## Transformations
Please see the run_analysis.R script for a full description.
Here's a summary:
- Load in the features (describing the readings eg tBodyAcc-std()-X)
- Load in the activities (sitting, standing etc)
- Load in the activity numbers for the training set and the test set
- Load in the subjects for the training set and the test set
- Load in the observations for the training set and the test set
- Create a tidy set and add the subject numbers
- Now add a column of the (training and testing) activity numbers
- Now add the (training and testing) observations
- Now add a column with the descriptions of the activities
- Now drop the column with the activity number
- Now rename the unlabelled columns from the feature descriptions
- Now only get the columns with means and standard deviations
- Find the average (mean) of each variable grouped by subject and activity
- Now drop the columns subject_number and activity_description
- Now rename the Group columns appropriately
- Now write the two files
