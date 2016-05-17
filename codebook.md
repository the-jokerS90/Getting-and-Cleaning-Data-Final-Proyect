This code book defines the use of most of the important variables that appears in the R script for this final proyect.


	"activity_data_test" and "activity_data_train" stand for the activity data, both test and train respectively.

	"subject_data_test" and "subject_data_train" stand for the subject data, both test and train respectively.

	"features_data_test" and "features_data_train" stand for the features data, both test and train respectively.


	"activity_Data", "subject_Data" and "features_Data" are used to store the complete dataset of activity, subject and features, respectively.

	"featuresNames" and "activityNames" are variables that contain the features names and activity labels read from its corresponding files.

	"auxiliar_dataframe" is a temporary variable containing the merge of "subject_Data" and "activity_Data"
	"final_Data" stores the merge of "features_Data" (put in first place) and the previous auxiliar_dataframe (subject and activity data)

	"subset_names" variable keeps the names of the feature data we are interested for the proyect (those which mean() or std() in its name), extracted from the second column of the variable "featuresNames"

	"subset_names_list" gather the names extracted before with the labels "Subject" and "Activity"

	
	This "subset_names_list" variable is used to subset the previous variable "final_Data" into the final dataset "proyect_Data1" asked for in the proyect. This variable is just afterwards transformed factoring its Activity column, assigning the first column of "activityNames" as its levels (numbers from 1 to 6) and the second column (names from walking to laying) as its labels. Finally, the dataset is ordered by the Activity column.
	In order to get the final dataset "proyect_Data1" tidy and ready to submit, it was labelled with more descriptive variable names.

	"proyect_Data2" is the result of creating a new and independent tidy data set with the average of each variable for each activity and each subject from the previous proyect_Data1 dataset. The function "aggregate" was used for this purpose. It was also ordered by it subject column first, and then by it Activity column.

	As a final step, the script saves the "proyect_Data2" dataset into both .txt and .csv files, being the .txt file used for submission.
