# Coursera-Tidy-Data-Course-Project
**This repository contains the scripts, codebook and a README file to explain the answer to the Coursera Getting and Cleaning Data Course Project.**

**The Problem is as follows:**

*The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

 You should create one R script called run_analysis.R that does the following. 
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!*

#**EXPLANATION OF SOLUTION:**

**First:** The only dataset needed is in the x_train.txt and x_test.txt dataset.  Inertial measurement files can be ignored. the train and test datasets are read into R using thee read.table function. These datasets are then combined using the rbind function as they both have the same column structure and need to be combined vertically by adding all rows into one new dataset called weardf. Once complete, this needs to be changed to a dta table as defined in the data.table package as it allows us to use more advanced techniques to tidy the data.

**Second:** Features.txt file contains the names of the measurements in the wear data table so we need to get these ready to label the columns.  These are read in with read.table however they need to be made unique as the nomenclature used violates certain variable naming requirements in R. the make.names function is used to make them UNIQUE while preserving the integirty of the label.

**Third:** The Subject list corresponding with each row in the datasets(Subject_test.txt and Subject_train.txt) and the Activity code number corresponding with each row in the datasets(y_train.txt and y_test.txt are also required to be added to the combined dataset in order to have a full reference to each measurement. These are read into R with the read.table command and then combined with an rbind command to match the structure of the combined dataset called wear. The result is a dataset called wearsub containing all subjects in order of the measurements in the x_ files noted above and a dataset called wearAC for all Activity codes. The column of data in each dataset is then labeled with "Subject" and "Activityclass" respectively.

**Fourth:** These datasets containing one column each are then added as a new variable-column in the wear dataset (wear$Subject and wear$Activityclass respectively. The modified Features dataset (containing the column names-variable names from the SECOND step above) are added to the wear dataset in order to follow the tidy data principle of labeling each variable with a meaningful name.

**Fifth:** The dplyr package is used to select out only the mean and standard deviation measurements as required. Any column-variable measurement noted with the word "mean" or "std" represent the measurements we want annotated with the Subject and Activity Code for each observation. As such, the select command is used to pull the Subject, Activityclass and then all columns that "contains"(a helper command in dplyr) either "mean" or "std". Subject and Activityclass are placed at the front of the file in order to make it easily and logically readable for the user in following tidy data principles. This data table is labeled as wearstat.

**Sixth:** The Activityclass column-variable has been a code number all this time but it needs to be changed to the corresponding label to be tidy. The labels are referenced to the code numbers in a file called activity_label.txt. This file is read into R with read.table so the V1 column is the number and the V2 column is the label (i.e. walking, sitting, standing,etc.) The wearstat$Activityclass variable in each row (currently a code number) is replaced with the activity label using a match command within a subset of the activity label table to replace the code number with the activity label.

**Seventh:** Finally, the final dataset is required to be a grouped dataset with one row for each of the subject-activity label combinations in the dataset providing the average (or mean) of each set of measurements for this combination. Since there are 30 subjects and 6 activities that were measured, the final dataset (avewear) must have 180 rows. The wearstat database is first ordered by subject and activity label to make it tidy and easy to read for the end user by using the arrange function from dplyr to create an ordered wearstat dataset called ordwear. This dataset is then grouped by Subject and then Activity label (using the dplyr group_by function) and then each measurement column is summarised (using the summarise_each function in dplyr) requiring each set of grouped observations to have an average computed(the mean) for all columns that "contains" the string "mean" or "std".  The contain function is used to choose these columns since there are 86 of these columns in the dataset and this is the shortest way to define this list of columns-measurements.

#**ULTIMATELY this is a tidy data set as it meets the principles of tidy data noted below:**

1. Avewear has headings to indicate which columns contain which data
2. All of the measurement variables are in separate columns and the subject and activity label correspond to each row
3. Each row contains one and only one observation
4. There are no duplicate columns with the same variable or variable name

