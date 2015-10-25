#### =====================================================================
#### Programming assignment
#### =====================================================================


message("load package dplyr") # dplyr is used in the summarizing part (5)
library(dplyr)



#### =====================================================================
#### 1, 2, 3, 4 Constructing a tidy dataset for all the data (test+training) together
#### =====================================================================



### Read the data elements in R ===============================
message("Begin reading.")
message("The data must be in subdir 'UCI HAR Dataset' of the working directory")

## common elements---------------------------------------------
message("reading common data elements")

# the activity code -label table
ac_path <- file.path("UCI HAR Dataset" , "activity_labels.txt")
ac <- read.table(ac_path)

# the the feature code number-label table
feat_path <- file.path("UCI HAR Dataset" , "features.txt")
feat <- read.table(feat_path)

## the test set data---------------------------------------
message("reading test set data")

# subject_test
su_test_path <- file.path("UCI HAR Dataset" , "test", "subject_test.txt")
su_test <- read.table(su_test_path)

# yt_test (= the activities)
y_test_path <- file.path("UCI HAR Dataset" , "test", "y_test.txt")
y_test <- read.table(y_test_path)
# head(y_test)

# X_test (= the measurements)
X_test_path <- file.path("UCI HAR Dataset" , "test", "X_test.txt")
X_test <- read.table(X_test_path)


## the training set data---------------------------------------
message("reading training set data (may take a while)")

# subject_train
su_train_path <- file.path("UCI HAR Dataset" , "train", "subject_train.txt")
su_train <- read.table(su_train_path)

# yt_train (= the activities)
y_train_path <- file.path("UCI HAR Dataset" , "train", "y_train.txt")
y_train <- read.table(y_train_path)

# X_train (= the measurements)
X_train_path <- file.path("UCI HAR Dataset" , "train", "X_train.txt")
X_train <- read.table(X_train_path)


### Combining the elements ========================================
message("Combining  data sets")

## common elements---------------------------------------------


# making a vector of legal column names with the features names 
# i.e. substituting (), ), (, )  and - with nonspecial chars.
oknames <- gsub("\\(",
                "", 
                gsub("\\)", 
                     "", 
                     gsub("_", 
                          "__", 
                          gsub("\\()","",feat[,2]))))



## the test set ---------------------------------------------------


# creating a factor with activity labels instead of activity num code  
acl <- factor(y_test[,1], ac[, 2])
for (j in seq_along(X_test[,1])) {
        acl[j] <- ac[y_test[j,1],2]
}

## make one dataframe with 3 (column-wise)
testdata <- cbind(su_test, acl, X_test)
# set names
names(testdata)<-c("subjectID", 
                   "Activity", 
                   oknames)

## the training set ---------------------------------------------------
## same thing
acl <- factor(y_train[,1], ac[, 2])
for (j in seq_along(X_train[,1])) {
        acl[j] <- ac[y_train[j,1],2]
}

## make one dataframe with 3 (column-wise)
traindata <- cbind(su_train, acl, X_train)
# set names
names(traindata)<-c("subjectID", 
                    "Activity", 
                    oknames)

## combine the two sets ------------------------------------------------

alldata <- rbind(traindata,testdata)



### select mean and std dev measurements (plus activity names) ======================

# mean
ismean1 <- grepl("-mean", feat[ ,2], fixed = TRUE)
ismean2 <- grepl("-meanFreq", feat[ ,2], fixed = TRUE)
ismean <- ismean1 & !ismean2
# std dev
isstd <- grepl("-std", feat[ ,2], fixed = TRUE)
#combined
isok <- ismean | isstd

# Number of measurements selected
numcolok <- sum(isok)

# final first tidy data set (end of step 4)
colok <- c(1, 2, feat[isok, 1]+2)
okdata <- alldata[ , colok]



#### =====================================================================
#### 5 summarizing the data
#### =====================================================================

message("summarizing the data")

#same names
snames <- names(okdata)

#adding a new variable
sdata <- mutate(okdata, 
                idact = interaction(okdata$subjectID, okdata$Activity))

sm <- split(sdata, sdata$idact)
ssum <- sapply(sm, function(x) c(x[1, 1], 
                                 x[1, 2], 
                                 colMeans(x[ , 3:68]) ))
ssum <- as.data.frame(ssum)
ssum <- data.table::transpose(ssum)

ssum <- ssum[which(!is.na(ssum[ , 1])), ]


# re-establish labels and names lost in the summarizing process
# labels
acl <- factor(ssum[ , 2], ac[, 2])
for (j in seq_along(ssum[ , 2])) {
        acl[j] <- ac[ssum[j,2], 2]
}
ssum[, 2] <- acl

# names of variables
names(ssum) <- snames


##-----------------------------------------------------------------------
# Writing the resulting table in "summary.txt"

write.table(ssum, file = "summary.txt", row.name=FALSE)

# the end -------------------------------------------------------------------

