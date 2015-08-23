# Getting and Cleaning Data Course Project

The main analysis script is saved as run_analysis.R and an average output is saved as avg.txt.

The scripts downloads and unzips Samsung Sensor data. It then merges training and test data and adds activity and subject 
variables to the data set.

Then the data is cleansed by reorder the variables. Finally, we only keep mean and standard deviation values for each subject, 
and activity.

As part of the assignment, the data is also grouped by subject and activity and the mean of all remaining variables is stored in
the `avg` data set.
