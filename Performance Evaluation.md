# Performance Evaluation  

* Prediction precision
  * If a predicted poly(A) site is within a given distance (e.g., 50 bp, 100bp, 150bp) of any annotated poly(A) site (_all_PA_hg19.txt_), then it is considered as a true positive (TP), otherwise is a false positive (FP). 
	
 
* Sensitivity
  * A cutoff of 50 bp was used to determine whether a predicted poly(A) site is a true positive or not. Top `5000` to `30,000` annotated poly(A) sites according to the supported number of reads were chosen as the reference poly(A) sites.
  
* Demo data
  * Prediction results for the human MAQC brain data from each benchmarked tool were stored in the [result_data](https://github.com/BMILAB/APAsurvey/tree/master/result_data) folder. These files are then processed and used for performance evaluation.
