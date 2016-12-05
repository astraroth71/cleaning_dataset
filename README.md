Coursera Getting and Cleaning Data Project
==========================================
This file describes how run_analysis.R script works.
* First, change the value of the working directory with the one you are using, Then from a console run "Rscript run_analysis.R".
* Once executed the script download and unzip the data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  and rename the folder with "<date>_data" where <date> is the System date when the analysis is performed.
* This analysis will produce 2 files one called "tidy_dataset.txt" with all the train and test dataset merged and cleaned and another called "tidy_dataset_with_mean.txt" with the data with the average of each variable for each activity and each subject.
* A detailed description of the variables can be found in CodeBook.md
