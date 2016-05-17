run_analysis <- function() {
    # First of all, this script saves the directory where its located
    directory <- getwd()
    
    # Check if the folder containing the data has already been created; if not, create it
    if (!file.exists("SmartphonesDataSet")){
      dir.create(("SmartphonesDataSet"))
    }
    
    # Set the working directory to the just created folder
    setwd("SmartphonesDataSet")
    
    # Download the file from the URL given
    zipfileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(zipfileUrl, destfile = "DataSet.zip")
    
    #Unzip the folder
    unzip("DataSet.zip")
    
    # Get the names of all the files contained in the data set, including those staying in sub folders
    path <- file.path("./UCI HAR Dataset")
    allfiles <- list.files(path, recursive = TRUE)
    allfilesUsed <- allfiles[!grepl(".Inertial.", allfiles)]
    
    # Read all the files corresponding to activity, subject and features data
    activity_data_test <- read.table(file.path(path, "test", "y_test.txt"), header = FALSE)
    activity_data_train <- read.table(file.path(path, "train", "y_train.txt"), header = FALSE)
    subject_data_test <- read.table(file.path(path, "test", "subject_test.txt"), header = FALSE)
    subject_data_train <- read.table(file.path(path, "train", "subject_train.txt"), header = FALSE)
    features_data_test <- read.table(file.path(path, "test", "X_test.txt"), header = FALSE)
    features_data_train <- read.table(file.path(path, "train", "X_train.txt"), header = FALSE)
    
    # Create one data set combining data for activity, subject and features
    activity_Data <- rbind(activity_data_test, activity_data_train)
    subject_Data <- rbind(subject_data_test, subject_data_train)
    features_Data <- rbind(features_data_test, features_data_train)
    names(activity_Data) <- c("Activity")
    names(subject_Data) <- c("Subject")
    
    # Read the files containing the features and activity names/labels
    featuresNames <- read.table(file.path(path, "features.txt"), header = FALSE)
    activityNames <- read.table(file.path(path, "activity_labels.txt"), header = FALSE)
    
    # Both files "features.txt" and "activity_labels.txt" have two columns, where the second one #V2 has a list of all names
    names(features_Data) <- featuresNames$V2
    
    # Combine all data we have in one final dataframe
    auxiliar_dataframe <- cbind(subject_Data, activity_Data)
    final_Data <- cbind(features_Data, auxiliar_dataframe)
    
    # Once we get the complete set of data, we seek for measurements on the mean and standard deviation
    ### First, choose the features names we want to conserve (those with "mean()" and "std()")
    subset_names <- featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]
    subset_names_list <- c(as.character(subset_names), "Subject", "Activity")
    
    ### Then, subset the data frame
    proyect_Data1 <- final_Data[, subset_names_list]
    
    # Use descriptive activity names to name the activities in the data set
    ### Factorize variable $Activity using the activityNames
    proyect_Data1$Activity <- factor(proyect_Data1$Activity, levels = activityNames$V1, labels = activityNames$V2)
    proyect_Data1 <- proyect_Data1[order(proyect_Data1$Activity),]
    
    ### Change features names for more descriptive variable names
    names(proyect_Data1) <- gsub("^t", "time", names(proyect_Data1))
    names(proyect_Data1) <- gsub("[Aa]cc", "Accelerometer", names(proyect_Data1))
    names(proyect_Data1) <- gsub("[Gg]yro", "Gyroscope", names(proyect_Data1))
    names(proyect_Data1) <- gsub("[Mm]ag", "Magnitude", names(proyect_Data1))
    names(proyect_Data1) <- gsub("^f", "frecuency", names(proyect_Data1))
    names(proyect_Data1) <- gsub("[Bb]ody[Bb]ody", "Body", names(proyect_Data1))
    
    # From the data set in step 4, create a second, independent tidy data set with the average
    # of each variable for each subject and each activity.
    ### Check if the package "plyr" is installed, and install it if not installed & load the package
    if("plyr" %in% rownames(installed.packages()) == FALSE) {
      install.packages("plyr")
    }
    library(plyr)
    
    ### Create and order by subject and Activity an independent data set 
    proyect_Data2 <- aggregate(. ~Subject + Activity, proyect_Data1, mean)
    proyect_Data2 <- proyect_Data2[order(proyect_Data2$Subject, proyect_Data2$Activity), ]
    
    ### Save the data set in two equal output files (.txt and .csv)
    setwd(directory)
    write.table(proyect_Data2, file = "GettingandCleaningDataProyect.txt", row.names = FALSE)
    write.csv2(proyect_Data2, file = "GettingandCleaningDataProyect.csv", row.names = FALSE)

}