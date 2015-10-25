
# Readme #

## principles ##

### first set of tidy data ###
The script presented here construcs first a tidy set of data with all 561 features variables

2 columns are added at the beginning: 
* "subjectID" = the test dubject number (1 to 30)
* "Activity" = the activity name (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
These variables will be needed in the summarization process

The other columns (the measurements columns) are then first selected in order to keep only the mean and standard deviation 
for each measurement (66 matching columns)
These variables have each a name derived from the original names (the "special characters" "()" and "-" have only been replaced)
These names are as descriptive as possible and their definition was provided in "feature_info.txt"
As the concept behind each name is complicated enough, its seems difficult to find  more explicit short names.

The first datasets thus contains 2 + 66 = 68 variables, and 10299 rows (observations)

### Summary - second set of tidy data ###
The mean of each column is computed using split-sapply, the split vector being the interaction("subjectID", "Activity")
A trasposition was needed, and names and activity labels needed to be reestablished after the summarization.


