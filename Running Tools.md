# Prediction of APA sites and APA dynamics using different tools.

Example files of input data
------------------------------
* Brain.fq (MAQC Brain exp 2 phi X) &  Brian_control.fq (MAQC UHR exp 2 auto) -- RNA-seq datasets from two conditions  
* hg19.fa -- reference genome sequence  
* hg19.gff/hg19_refFlat.txt -- reference genome annotation


Running different tools for APA prediction
------------------------------
* Generate bam file and bedgraph file
  * Use [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic) to trim and filter out low quality raw reads.
  ```
	java -jar trimmomatic-0.35.jar SE -phred33 Brain.fq  Brain.paired.fastq Brain.unpaired.fastq ILLUMINACLIP:TruSeq3-SE-2.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
  ```  
  * Use [HISAT2](http://ccb.jhu.edu/software/hisat2/index.shtml) or [tophat](http://ccb.jhu.edu/software/tophat/index.shtml) to align the Brain/Brain_control reads to the reference genome.  
  ```
	hisat2 -x reference_genome_index Brain.paired.fastq -S Brain.sam
  ```   
  * Convert file format (Tools: [Samtools](http://samtools.sourceforge.net) and [bedtools](https://bedtools.readthedocs.io/en/latest/))  
  ```
	samtools view -bS Brain.sam > Brain.bam  
  
    samtools sort Brain.bam -o Brain.sorted.bam  
  
    samtools index Brain.sorted.bam  
  
    genomeCoverageBed -bg -ibam Brain.sort.bam -g reference.genome.size.txt -split > Brain.bedgraph
  ```   
   
* MISO
    * Index the annotation using index_gff
    ```
	  index_gff --index hg19.gff  indexed/
    ```  
    _`where refGene.gff3 is a GFF file containing descriptions of isoforms/alternative splicing events to be quantitated (e.g. skipped exons)`_
    * Run MISO
    ```
    miso --run indexed/  Brain.bam --output-dir output1/  --read-len 50 –use-cluster
    miso --run indexed/  Brain_control.bam --output-dir output2/  --read-len 50 –use-cluster
    ```  
    _`The --read-len option is necessary and specifies the length of the reads in the data`_  
    _`To compute expression levels using paired-end reads, use the --paired-end option`_ 
    * Summarize MISO inferences using summarize_miso --summarize-samples
    ```
    summarize_miso --summarize-samples output1/ summary_output1/
    summarize_miso --summarize-samples output2/ summary_output2/
    ```  
    * Make pairwise comparisons between samples to detect differentially expressed isoforms/events with compare_miso --compare-samples
    ```
    compare_miso --compare-samples output1/ output2/ comparison_output/
    ```  
  
* roar
  ```
  library(roar)
  gtf <- system.file("examples", "apa.gtf", package="roar")
  bamTreatment <- c("Brain.bam")
  bamControl <- c("Brain_control.bam")
  rds <- RoarDatasetFromFiles(bamTreatment, bamControl, gtf)
  rds <- countPrePost(rds, FALSE)
  rds <- computeRoars(rds)
  rds <- computePvals(rds)
  results <- totalResults(rds)
  results_filtered <- pvalueFilter(rds, fpkmCutoff=-Inf,  pvalCutoff=0.05
  ```  

* QAPA
    *  Extract 3′ UTRs from annotation    
    ```
    qapa build --db ensembl_identifiers.txt -g gencode.polyA_sites.bed -p clusters.mm10.bed gencode.basic.txt > output_utrs.bed
    ```  
     If using a custom BED file, replace the -g and -p options with -o:
    ```
    qapa build --db ensembl_identifiers.txt -o custom_sites.bed gencode.basic.txt > output_utrs.bed
    ```    
    * Extract sequences from the BED file prepared by build (a reference genome in FASTA format is required)
    ```
    qapa fasta -f hg19.fa output_utrs.bed output_sequences.fa
    ```  
     _`hg19.fa must be uncompressed`_ 
    * Expression quantification of 3’UTR isoforms must be carried out first using the FASTA file prepared by fasta as the index  
    To index the sequences using [Salmon](https://combine-lab.github.io/salmon/)
    ```
    salmon index -t output_sequences.fa -i utr_library
    ```  
    next 
    ```
    qapa quant --db ensembl_identifiers.txt project/sample*/quant.sf > pau_results.txt
    ```  
 
* PAQR
  * Configure the input parameters  
  The PAQR subdirectory contains a file called "config.yaml". This files contains all information about used parameter values, data locations, file names and so on. During a run, all steps of the pipeline will retrieve their parameter values from this file.
  ```
  max_cores=4 # maximum number of threads that will run in parallel
  snakemake -s part_one.Snakefile -p --cores ${max_cores} &> log_output.log
  ```  
  ```
  max_cores=8 # maximum number of threads that will run in parallel
  snakemake -s part_two.Snakefile -p --cores ${max_cores} &>> log_output.log
  ```  
  * The single steps/scripts of the pipeline
  ```
  python calculate-TIN-values.py \
         -i data/bam_files/Brain.bam \
         -r ${transcripts} \
         -c ${min_raw_reads} \
         --names KD_rep1 \
         -n ${sample_size} \
         > data/Brain.tsv
  ```  
  ```
  python merge-TIN-tables.py \
         --verbose \
         --input data/Brain.tsv data/Brain_control.tsv \
         > data/bias.transcript_wide.TIN.tsv
  ``` 
  ```
  python merge-TIN-tables.py \
         --verbose \
         --input data/Brain.tsv data/Brain_control.tsv \
         > data/bias.transcript_wide.TIN.tsv
  ``` 
  bias.transcript_wide.TIN.tsv > bias.TIN.median_per_sample.tsv in part_one.Snakefile
  ```
  Rscript boxplots-TIN-distributions.R \
          --file HNRNPC_KD/bias.TIN.median_per_sample.tsv\
          --pdf HNRNPC_KD/bias.transcript_wide.TIN.boxplots.pdf
  ``` 
  * Run KAPAC
  ```
  Rscript --vanilla KAPAC.R --help
  ``` 
  
* Cufflinks
  ```
  cufflinks -p 8 -o brain --overlap-radius 75 brain.sorted.bam
  ``` 
  ```
  cuffdiff -o ./cuffdiff_out/ -p 2 -FDR 0.1 -L c1,c2 -max-bundle-frags 20000000 hg19.gtf Brain.sorted.bam Brain_control.sorted.bam
  ``` 

* ExUTR
    * Reading Open Frame (ORF) prediction
    ```
    perl 3UTR_orf.pl -i transcripts.fasta  -d /home/user/swissprot/swissprot -a 8 -o Test -l un
    ``` 
    * 3'UTR sequence retrieval
    ```
    perl 3UTR_ext.pl -i1 transcripts.fa -i2 orfs.fasta -d /home/user/3UTR_database/3UTR.mam.fasta -a 8 -o 3UTR.fasta -x 2500 -m 20
    ``` 
  
* Scripture
    * Make paired end alignment files using Scripture  
    Remove the headers from the TopHat alignment file (headers begin with "@") and sort each by read name
    ```
    sed '1,2d' Brian.sam | sort > Brian.sorted.sam
    sed '1,2d' Brian_control.sam | sort > Brian_control.sorted.sam
    ``` 
    ```
    java -Xmx4000m -jar scripture.jar -task makePairedFile -pair1 Brain.sorted.sam -pair2 Brian_control.sam -out Brain.paired.sam –sorted
    ``` 
    * Run Scripture  
    Combine TopHat alignment file and paired end alignments file, then sort and index  
    ```
    cat Brain.sorted.sam Brian_control.sorted.sam > all_Brain.sam
    ``` 
    ```
    cat Brain.paired.sam Brain2.paired.sam > all_Brain.paired.sam
    ``` 
    ```
    java –jar scripture.jar –alignment all_Brain.sorted.sam –out Brain_Test –sizeFile hg19.sizes –chr chr19 –chrSequence chr19.fa -pairedEnd all_Brain.paired.sorted.sam
    ``` 
   
* KLEAT
    * Use the included script (TA.sh) to generate the input necessary for KLEAT 
    ```
     TA.sh -a Brain1.fq.gz -b Brain2.fq.gz -n Brain -k "32 52 72" -o Brain/assembly -t 6 -m 15G
    ``` 
    * Run KLEAT
    ```
     python KLEAT.py  Brain/assembly/Brain.bam Brain/assembly/merged/Brain-merged.fa hg19.fa ensembl.fixed.sorted.gz Brain/assembly/r2c_sorted.bam /KLEAT/Brain -k KLEAT_Brain "KLEAT cleavage sites" -ss
    ``` 
    
* ContextMap2
  ```
  java -jar ContextMap_v2.1.0.jar mapper -read Brain.fq  -aligner_name bowtie2  -aligner_bin /user/home/bowtie2 -indexer_bin   ./bowtie2_build  -indices chr1,chr2 -genome /user/home/hg19 -o Brain --ployA
  ``` 
   
* GETUTR
  ```
  python GETUTR.py -i Brain.bam -o Brain.3UTR -m 10 -r refFlat.txt
  ``` 

* PHMM
    * Build transcript database 
    ```
    Rscript buildTranscriptDB_fixed.R  refGene txdb.hg19.refGene.sqlite hg19
    ``` 
    * Select transcripts with 3'utr with length > 600bp  
    ```
    Rscript apa3utr_fixed.R txdb.hg19.refGene.sqlite 22 long3utr.txt
    ``` 
    * Compute read tag counts in sliding windows
    ```
    Rscript apaCount_fixed.R long3utr.txt 22 Brain.bam
    ```   
    * Fit poisson HMM
    ```
    Rscript poissonHMM_fixed long3utr.txt Brain.sorted.cts.rda Brain.csv
    ```    
 
* ChangePoint
  ```
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g 3utr.bed -d s -o Brain
  ```    
  ```
  perl change_point.pl -t Brain.bam -c Brain_control.bam -g 3utr.bed -d l -o Brain
  ```    

* IsoSCM
  ```
  java -Xmx102400m -jar IsoSCM-2.0.11.jar assemble -coverage false -bam Brain.bam -base Brain -s unstranded
  java -Xmx102400m -jar IsoSCM-2.0.11.jar assemble -coverage false -bam Brain_control.bam -base Brain_control -s unstranded
  ```  
  ```
  java -Xmx102400m -jar IsoSCM-2.0.11.jar compare -x1 brain.assembly_parameters.xml -x2 brain_control.assembly_parameters.xml -base Brain
  ```  
 
* DaPars
    * Generate region annotation
    ```
    python DaPars_Extract_Anno.py -b hg19_refseq_extracted_3UTR.bed -s hg19_4_19_2012_Refseq_id_from_UCSC.txt -o extracted_3UTR.bed
    ```  
    * Run DaPars
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
    
* APAtrap
    * Identify distal 3' UTR  
    For genome having long 3'UTR
    ```
    identifyDistal3UTR -i Brain.bedgraph Brain_control.bedgraph -m hg19.genemodel.bed -o Brain.utr.bed  
    ```  
       For genome having short 3'UTR
    ```
    identifyDistal3UTR -i Brain.bedgraph Brain_control.bedgraph -m hg19.genemodel.bed -o Brain.utr.bed -w 50 -e 5000
    ``` 
    * APA site detection  
    For genome having long 3'UTR
    ```
    predictAPA -i Brain.bedgraph Brain_control.bedgraph -g 2 -n 1 1 -u Brain.utr.bed -o output.txt  
    ``` 
       For genome having short 3'UTR
    ```
    predictAPA -i Brain.bedgraph Brain_control.bedgraph -g 2 -n 1 1 -u Brain.utr.bed -o output.txt -a 50
    ``` 
    * APA dynamics detection  
    ```
    library(deAPA)
    deAPA('output.txt', 'de_output.txt', 1, 2, 1, 1, 20)
    ``` 

* TAPAS
    * APA site detection
    ```
    samtools view -b Brain.sorted.bam > Brain.bam
    samtools depth Brain.bam > Brain.txt
    ./APA_sites_detection -ref refFlat.txt -cov Brain.txt -l 50 -o Brain.txt
    ```
    * APA dynamics detection
    ```
    ./Diff_APA_site_analysis -C1 Brain.txt,Brain_control.txt -C2 UHR.txt,UHR_control.txt -a refFlat.txt -cutoff 70 -type d -o Brain_output.txt
    ```

* EBChangePoint
  ```
  perl EBChangePoint.pl -c Brain.bam -t Brain_control.bam -g 3utr.bed  -h1  junctions_brain.bed   -h2 junctions_brain_control.bed
  ```  
  _`Junction.bed file for Brain.fq/Brain_control.fa sample, i.e. generated by Tophat`_ 

     
