# Data and Tools  

Simulated Data
------------------------------
* Select candidate gene models  
	*  Based on the human genome annotation file (version [hg19](http://genome.ucsc.edu/cgi-bin/hgTables)), we first filtered out genes with less than 3 exons. Then 2000 genes were randomly selected from the remaining genes, which were used as candidate gene models for the simulation study. To simulate genes with two isoforms, 1000 genes were randomly selected from the candidate gene set. Then the 3' end of the first isoform is the same as the hg19 gene model, while the 3' end of the second isoform is 1000 bp beyond the first 3' end. We also simulated genes with variable number of isoforms (one to four isoforms). The gene set is the same as that used for simulating two-isoform genes. Then 50, 450, 300, and 200 genes were randomly selected from the 1000 genes and were regarded as genes with 1, 2, 3, and 4 isoforms, respectively. 50 genes are with only one isoform, whose 3' end is the same as the hg19 gene model. For genes with two to four isoforms, the respective 3' end is  500 bp, 1000 bp, and 1500 bp beyond the first 3' end, respectively. Finally, two gtf files (two isoforms.gtf and multiple isoforms.gtf) were obtained. Relevant files and code are in the [simulated data](https://github.com/BMILAB/APAsurvey/tree/master/simulate_data) folder.
  ```
	Rscript selectValidGene.R 
  ```  
* Simulate RNA-seq reads   
	* We used the [flux-simulator](http://confluence.sammeth.net/display/SIM/Home) tool, hg19 genomes fasta file, and the gtf files from the first step (Select candidate gene models) to generate simulated RNA-seq reads.
  ```
	flux-simulator -t simulator -p syn1000.par 
  ```  
* Files in [simulated data](https://github.com/BMILAB/APAsurvey/tree/master/simulate_data) 
	* bed file: The BED format is employed as default for describing reads produced in a Flux Simulator run by the genomic regions from which they are originating. Reads that fall partially in the poly-A tail are truncated to their respective content of genomic sequence. In contrast, reads that fall completely into the poly-A tail are described to be located on the special reference sequence 'poly-A'.  
	* read sequences file (.fq): For the (optional) input of a genomic sequence to produce read sequences.   
	* Transcriptome Profile (.PRO): The Profile (.PRO) format is designed to describe the simulated characteristics of each transcript from the reference annotation.  

Real RNA-seq data
-----------------------

* RNA-seq datasets used for the benchmarking analysis  

|Species|Data samples|NCBI accession number|Genome annotation and assembly version|
|:------|:-----------|:--------------------|:-------------------------------------|
|Human|MAQC Brain|[SRX016359](https://www.ncbi.nlm.nih.gov/sra/SRX016359)  [SRX016366](https://www.ncbi.nlm.nih.gov/sra/SRX016366)|[hg19](http://genome.ucsc.edu/cgi-bin/hgTables)| 
|Human|MAQC Universal Human Reference (UHR)|[SRX016367](https://www.ncbi.nlm.nih.gov/sra/SRX016367)  [SRX016368](https://www.ncbi.nlm.nih.gov/sra/SRX016368)|[hg19](http://genome.ucsc.edu/cgi-bin/hgTables)| 
|Mouse|Mouse Brain|[GSE41637](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE41637)|[mm10](http://genome.ucsc.edu/cgi-bin/hgTables)| 
|Arabidopsis|Control and mild drought conditions|[ERX697776](https://www.ncbi.nlm.nih.gov/sra/ERX697776)  [ERX697793](https://www.ncbi.nlm.nih.gov/sra/ERX697793)|[TAIR10](https://www.arabidopsis.org/download/index-auto.jsp?dir=%2Fdownload_files%2FGenes%2FTAIR10_genome_release%2FTAIR10_gff3)| 

Tools evaluated in the benchmarking study
-------------------

|Tools|Program|APA detection|Switching detection|
|:----|:------|:------------|:------------------|
|[MISO](https://miso.readthedocs.io/en/fastmiso/#pipeline)  (Kate, et al., 2010)|Python|No|Yes|
|[roar](https://bioconductor.org/packages/release/bioc/html/roar.html)  (Grassi, et al., 2016)|R|No|Yes|
|[QAPA](https://github.com/morrislab/qapa)  (Ha, et al., 2018)|R, Python|Yes|Yes|
|[PAQR](https://github.com/zavolanlab/PAQR_KAPAC)  (Gruber, et al., 2018)|R, Python|Yes|Yes|
|[3USS](http://circe.med.uniroma1.it/3uss_server/)  (Le Pera, et al., 2015)|Web|Yes|No|
|[PASA](https://github.com/PASApipeline/PASApipeline/wiki)  (Campbell, et al., 2006)|Perl|Yes|No|
|[Cufflinks](http://cole-trapnell-lab.github.io/cufflinks/cuffdiff/index.html)  (Trapnell, et al., 2012)|R|Yes|No|
|[ExUTR](https://github.com/huangzixia/ExUTR)  (Huang and Teeling, 2017)|Perl|No|No|
|[Scripture](http://software.broadinstitute.org/software/scripture/)  (Guttman, et al., 2010)|Java|No|No|
|[KLEAT](http://www.bcgsc.ca/platform/bioinfo/software/cleat)  (Birol, et al., 2015)|Python|Yes|No|
|[ContextMap2](https://www.bio.ifi.lmu.de/software/contextmap/)  (Bonfert and Friedel, 2017)|Java|Yes|No|
|[GETUTR](http://big.hanyang.ac.kr/GETUTR/manual.htm)  (kim, et al., 2015)|Python|Yes|No|
|[PHMM](https://www.niehs.nih.gov/research/resources/software/biostatistics/phmm/)  (Lu and Bushel, 2013)|R|No|Yes|
|[ChangePoint](http://utr.sourceforge.net)  (Wang, et al., 2014)|Java|No|Yes|
|[IsoSCM](https://github.com/shenkers/isoscm)  (Shenker, et al., 2015)|Java|Yes|Yes|
|[DaPars](https://github.com/ZhengXia/dapars)  (Xia, et al., 2014)|Python|Yes|Yes|
|[APAtrap](https://sourceforge.net/projects/apatrap/)  (Ye, et al., 2018)|R, Perl|Yes|Yes|
|[TAPAS](https://github.com/arefeen/TAPAS)  (Arefeen, et al., 2018)|R|Yes|Yes|
|[EBChangePoint](http://ebchangepoint.sourceforge.net)  (Zhang and Wei, 2016)|Java|Yes|Yes|
