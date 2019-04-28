# Data and Tools  

Simulated Data
------------------------------
* Select Valid Gene  
	*  Use the hg19 annotation file(gtf) and select exons for each genes, 2000 genes were randomly selected, genes with less than 3 exon were filtered out, next generate 2 isoforms for 1000 genes and multiple isoforms for 1000 genes (50 genes: 1 isoform, 450 genes: 2 isoforms, 300 genes: 3 isoform, 200 genes 4 isoforms), finally get two gtf files(two isoforms.gtf and multiple isoforms.gtf). The details files are in the [simulated data](https://github.com/BMILAB/APAsurvey/tree/master/simulate_data) folder
  ```
	Rscript selectValidGene.R 
  ```  
* Simulated data   
	* Use the [flux-simulator](http://confluence.sammeth.net/display/SIM/Home) tool, hg19 genomes fasta file and the gtf file for first step(Select Valid Gene), generate simulated data.
  ```
	flux-simulator -t simulator -p syn1000.par 
  ```  
* Main files in simulated data  
	* bed file: The BED format is employed as default for describing reads produced in a Flux Simulator run by the genomic regions from which they are originating. Reads that fall partially in the poly-A tail are truncated to their respective content of genomic sequence. In contrast, reads that fall completely into the poly-A tail are described to be located on the special reference sequence 'poly-A'.  
	* fasta/fastq read sequences file: For the (optional) input of a genomic sequence to produce read sequences.   
	* .PRO Transcriptome Profile: The Profile (.PRO) format is designed to describe the simulated characteristics of each transcript from the reference annotation.  

Real RNA-seq data
-----------------------

* RNA-seq datasets used for benchmarking analysis  

|Species|Data samples|NCBI accession number|Genome annotation and assembly version|
|:------|:-----------|:--------------------|:-------------------------------------|
|Human|MAQC Brain|[SRX016359](https://www.ncbi.nlm.nih.gov/sra/SRX016359)  [SRX016366](https://www.ncbi.nlm.nih.gov/sra/SRX016366)|[hg19](http://genome.ucsc.edu/cgi-bin/hgTables)| 
|Human|MAQC Universal Human Reference (UHR)|[SRX016367](https://www.ncbi.nlm.nih.gov/sra/SRX016367)  [SRX016368](https://www.ncbi.nlm.nih.gov/sra/SRX016368)|[hg19](http://genome.ucsc.edu/cgi-bin/hgTables)| 
|Mouse|Mouse Brain|[GSE41637](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE41637)|[mm10](http://genome.ucsc.edu/cgi-bin/hgTables)| 
|Arabidopsis|Control and mild drought conditions|[ERX697776](https://www.ncbi.nlm.nih.gov/sra/ERX697776)  [ERX697793](https://www.ncbi.nlm.nih.gov/sra/ERX697793)|[TAIR10](https://www.arabidopsis.org/download/index-auto.jsp?dir=%2Fdownload_files%2FGenes%2FTAIR10_genome_release%2FTAIR10_gff3)| 

Software
-------------------

|Tools|Program|APA detection|Switching detection|
|:----|:------|:------------|:------------------|
|[MISO](https://miso.readthedocs.io/en/fastmiso/#pipeline)  (Kate, et al., 2010)|Python|No|Yes|
|[roar](https://bioconductor.org/packages/release/bioc/html/roar.html)  (Grassi, et al., 2016)|R|No|Yes|
|[QAPA](https://github.com/morrislab/qapa)  (Ha, et al., 2018)|R,Python|Yes|Yes|
|[PAQR](https://github.com/zavolanlab/PAQR_KAPAC)  (Ha, et al., 2018)|R,Python|Yes|Yes|
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
|[APAtrap](https://sourceforge.net/projects/apatrap/)  (Ye, et al., 2018)|R,Perl|Yes|Yes|
|[TAPAS](https://github.com/arefeen/TAPAS)  (Arefeen, et al., 2018)|R|Yes|Yes|
|[TAPAS](http://ebchangepoint.sourceforge.net)  (Zhang and Wei, 2016)|Java|Yes|Yes|
















