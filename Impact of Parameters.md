# Impact of Parameters  

Among the nine tools we investigated, parameters of five tools, including `Dapars`, `ChangePoint`, `APAtrap`, `IsoSCM`, and `GETUTR`, are adjustable. Here we used the human MAQC data set to evaluate the influence of parameters of these tools on the prediction accuracy of poly(A) sites. The accuracy of poly(A) site prediction using different tools with different parameter combinations is shown in `Table 1`.  
Two parameters are adjustable in `APAtrap`, the minimum distance between two poly(A) sites (option: -a, default is 100) and the average read coverage for a 3’UTR (option: -c, default is 20). Here we test five combinations of -a and -c. The accuracy under different parameter combinations ranges from 28% to 32% with the best at the combination of -a=50 and -c=20.   
For `DaPars`, although two parameters are provided, Coverage_cutoff (default is 30) and PDUI_cutoff (default is 0.5), the accuracy remains the same (27.87%) under six parameter combinations examined (PDUI_cutoff=0.5 and Coverage_cutoff=10/20/30; Coverage_cutoff=30 and PDUI_cutoff=0.1/0.3/0.7).  
`ChangePoint` has two parameters, -n (at least how many reads support each region, default is 20) and -a (mixed directional FDR level, default is 0.05). We test nine parameter combinations and the accuracy ranges from 23% to 26%.   
`IsoSCM` has relatively more parameters adjustable, here we assessed the impact of two main parameters, -min terminal (terminal segments are extended by this amount before segmentation) and -min fold (the minimum fold change between neighboring segments expressed as a ratio of coverage downstream divided bycoverage upstream). Because the computation time of IsoSCM is relatively long, here we only test two parameter combinations and obtained similar accuracy (~13%).  
`GETUTR` has one parameter -m (index for the smoothing method, 10 for PAVA, 0 for Max.fit and 1 for Min.fit). Due to the speed limit of GETUTR, here we used the Arabidopsis data instead to assess the parameter influence. The accuracy ranges from 24% to 27% with the best when using the PAVA smoothing method (-m 10).  
Generally, these methods are quite robust to different parameters with slight variation of performance in terms of accuracy.


Table 1 Accuracy of poly(A) site prediction using different tools with different parameter combinations.
-----------------------
 
|Tool|Parameter combinations|Accuracy (cutoff=100 bp)|
|:---|:---------------------|:-----------------------|
|APAtrap|-a 100 –c 20|28.05%|
|APAtrap|-a 100 –c 30|28.54%|
|APAtrap|-a 100 –c 50|29.96%|
|APAtrap|-a 50 –c 20|32.22%|
|APAtrap|-a 150 –c 20|27.39%|
|_DaPars_|_-PDUI_cutoff 0.5_ _-Coverage_cutoff 10_|_27.87%_|
|_DaPars_|_-PDUI_cutoff 0.5_ _-Coverage_cutoff 20_|_27.87%_|
|_DaPars_|_-PDUI_cutoff 0.5_ _-Coverage_cutoff 30_|_27.87%_|
|_DaPars_|_-PDUI_cutoff 0.1_ _-Coverage_cutoff 30_|_27.87%_|
|_DaPars_|_-PDUI_cutoff 0.3_ _-Coverage_cutoff 30_|_27.87%_|
|_DaPars_|_-PDUI_cutoff 0.7_ _-Coverage_cutoff 30_|_27.87%_|
|ChangePoint|-n 20 –a 0.05|25.85%|
|ChangePoint|-n 20 –a 0.1|23.98%|
|ChangePoint|-n 20 –a 0.3|23.98%|
|ChangePoint|-n 20 –a 0.5|23.98%|
|ChangePoint|-n 20 –a 0.05|24.93%|
|ChangePoint|-n 10 –a 0.05|24.41%|
|ChangePoint|-n 15 –a 0.05|24.16%|
|ChangePoint|-n 30 –a 0.05|23.76%|
|ChangePoint|-n 50 –a 0.05|23.17%|
|_IsoSCM_|_-min terminal 300_ _-min fold 0.5_|_13.90%_|
|_IsoSCM_|_-min terminal 50_ _-min fold 0.08_|_13.38%_|
|GETUTR|-m 10|27.32%|
|GETUTR|-m 1|24.97%|
|GETUTR|-m 0|24.29%|

_`The Arabidopsis data set is used for GETUTR, while the human MAQC data set is used for other methods.`_  
_`If a predicted poly(A) site is within 100 bp of any annotated poly(A) site, then it is considered as a true positive.`_


Running
--------------------

* APAtrap
  * APA site detection using different parameters
  ```
  predictAPA.pl –a 100 –c 20 -i Brain.bedgraph Brain_control.bedgraph -g 2 -n 1 1 -u hg19.utr.bed -o output.txt -d 0.1 
  ```
  ```
  predictAPA.pl –a 100 –c 30 -i Brain.bedgraph Brain_control.bedgraph -g 2 -n 1 1 -u hg19.utr.bed -o output.txt -d 0.1 
  ```
  ```
  predictAPA.pl –a 100 –c 50 -i Brain.bedgraph Brain_control.bedgraph -g 2 -n 1 1 -u hg19.utr.bed -o output.txt -d 0.1 
  ```
  ```
  predictAPA.pl –a 50 –c 20 -i Brain.bedgraph Brain_control.bedgraph -g 2 -n 1 1 -u hg19.utr.bed -o output.txt -d 0.1 
  ```
  ```
  predictAPA.pl –a 150 –c 20 -i Brain.bedgraph Brain_control.bedgraph -g 2 -n 1 1 -u hg19.utr.bed -o output.txt -d 0.1 
  ```

* DaPars
  * APA site detection using different parameters  
  ```
  python DaPars_main.py configure_file
   configure_file: 
   Annotated_3UTR=hg19_refseq_extracted_3UTR.bed
   Group1_Tophat_aligned_Wig=Brain.bedgraph
   Group2_Tophat_aligned_Wig=Brain_control.bedgraph
   Output_directory=DaPars_Brain/
   Output_result_file=DaPars_Brain
   Num_least_in_group1=1
   Num_least_in_group2=1
   Coverage_cutoff=30
   FDR_cutoff=0.05
   PDUI_cutoff=0.5
   Fold_change_cutoff=0.59
  ```
  Change the Coverage_cutoff and PDUI_cutoff parameters  
  ```
   Coverage_cutoff=10
   PDUI_cutoff=0.5
  ```  
  ```
   Coverage_cutoff=20
   PDUI_cutoff=0.5
  ```  
  ```
   Coverage_cutoff=30
   PDUI_cutoff=0.1
  ```  
  ```
   Coverage_cutoff=30
   PDUI_cutoff=0.3
  ```  
  ```
   Coverage_cutoff=30
   PDUI_cutoff=0.7
  ```  

* ChangePoint
  * APA dynamics detection using different parameters
  ```
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g 3utr.bed -d s -n 20 –a 0.05
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g 3utr.bed -d l -n 20 –a 0.05
  ```  
  ```
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g 3utr.bed -d s -n 20 –a 0.1
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g 3utr.bed -d l -n 20 –a 0.1
  ```  
  ```
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g 3utr.bed -d s -n 20 –a 0.3
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g 3utr.bed -d l -n 20 –a 0.3
  ```  
  ```
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g 3utr.bed -d s -n 20 –a 0.5
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g 3utr.bed -d l -n 20 –a 0.5
  ```  
  ```
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g utr.bed -d s -n 5 –a 0.05
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g utr.bed -d l -n 5 –a 0.05
  ```  
  ```
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g utr.bed -d s -n 10 –a 0.05
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g utr.bed -d l -n 10 –a 0.05
  ```  
  ```
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g utr.bed -d s -n 15 –a 0.05
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g utr.bed -d l -n 15 –a 0.05
  ```    
  ```
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g utr.bed -d s -n 30 –a 0.05
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g utr.bed -d l -n 30 –a 0.05
  ```   
  ```
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g utr.bed -d s -n 50 –a 0.05
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g utr.bed -d l -n 50 –a 0.05
  ```  
  
* IsoSCM
  * APA site detection using different parameters  
  ```
   java -Xmx102400m -jar IsoSCM-2.0.11.jar assemble -min terminal 300 -min fold 0.5 -coverage false -bam Brain.bam -base Brain -s unstranded  -jnct alpha 0.05
  ```  
  ```
   java -Xmx102400m -jar IsoSCM-2.0.11.jar assemble -min terminal 50 -min fold 0.08 -coverage false -bam Brain.bam -base Brain -s unstranded  -jnct alpha 0.05
  ``` 
  
* GETUTR
  * APA site detection using different parameters  
  ```
  python GETUTR.py -i Brain.bam -o Brain.3UTR -m 10 -r refFlat.txt
  ``` 
  ```
  python GETUTR.py -i Brain.bam -o Brain.3UTR -m 0 -r refFlat.txt
  ``` 
  ```
  python GETUTR.py -i Brain.bam -o Brain.3UTR -m 1 -r refFlat.txt
  ``` 
  
  
  
  
  

