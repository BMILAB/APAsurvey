Introduction
====================
This github site describes relevant information for the review paper "A survey on identification and quantification of alternative polyadenylation sites from RNA-seq data". Currently, a number of computational approaches for identifing APA sites and/or dynamic APA events from RNA-seq data have emerged in the literature, which provide valuable yet preliminary results that should be refined to yield credible guidelines for the scientific community. We conducted objective benchmarking analysis using RNA-seq datasets from different species (human, mouse, and Arabidopsis) and simulated datasets to present a systematic evaluation of 11 representative methods.  
The data and tools investigated in the review are described in the webpage [Data and Tools](#Data and Tools).  
The commands used for running tools for identification and quantification of APA sites from RNA-seq data are given in the webpage Running Tools.  
The performance evaluation is described here.  
The impact of parameters for different tools is described in the webpage Impact of Parameters.   


### Data and Tools
--------------------
* [Flux Simulator](http://confluence.sammeth.net/display/SIM/Home), [HISAT2](http://ccb.jhu.edu/software/hisat2/index.shtml), [bedtools](https://bedtools.readthedocs.io/en/latest/), [Samtools](http://www.htslib.org)


# DATA

* Simulate data
 
 The script in simulate_data folder
  1) Select the Gene
  ```
  Rscript selectValidGene.R
  ```
  2) Generate simulate data
  ```
  flux-simulator -t simulator -p syn1000.par 
  ```

* RNA-seq data

   1) Human MAQC Brain data
   https://www.ncbi.nlm.nih.gov/sra/SRX016359; https://www.ncbi.nlm.nih.gov/sra/SRX016366
   
   2) Human MAQC Universal Human Reference (UHR) data
   https://www.ncbi.nlm.nih.gov/sra/SRX016367; https://www.ncbi.nlm.nih.gov/sra/SRX016368

   3) Mouse Brain data
   https://www.ncbi.nlm.nih.gov/sra?term=SRX196264; https://www.ncbi.nlm.nih.gov/sra?term=SRX196273; https://www.ncbi.nlm.nih.gov/sra?term=SRX196281
   
   4) Arabidopsis data
   https://www.ncbi.nlm.nih.gov/sra/?term=ERX697776; https://www.ncbi.nlm.nih.gov/sra/?term=ERX697793

* Genome annotation file

    1) Human hg19 and Mouse mm10
    https://genome.ucsc.edu/cgi-bin/hgTables
    
    2) Arabidopsis TAIR10
    https://www.arabidopsis.org/download/index-auto.jsp?dir=%2Fdownload_files%2FGenes%2FTAIR10_genome_release%2FTAIR10_gff3                                               



# Software

* MISO  https://miso.readthedocs.io/en/fastmiso/#pipeline

* Roar  https://bioconductor.org/packages/release/bioc/html/roar.html

* QAPA  https://github.com/morrislab/qapa

* PAQR  https://github.com/zavolanlab/PAQR_KAPAC

* Cufflinks  http://cole-trapnell-lab.github.io/cufflinks/cuffdiff/index.html

* ExUTR  https://github.com/huangzixia/ExUTR

* Scripture  http://software.broadinstitute.org/software/scripture/

* KLEAT  http://www.bcgsc.ca/platform/bioinfo/software/cleat

* ContextMap2  https://www.bio.ifi.lmu.de/software/contextmap/

* GETUTR  http://big.hanyang.ac.kr/GETUTR/manual.htm

* PHMM  https://www.niehs.nih.gov/research/resources/software/biostatistics/phmm/

* ChangePoint  http://utr.sourceforge.net

* IsoSCM  https://github.com/shenkers/isoscm

* DaPars  https://github.com/ZhengXia/dapars

* APAtrap  https://sourceforge.net/projects/apatrap/

* TAPAS  https://github.com/arefeen/TAPAS

* EBChangePoint  http://ebchangepoint.sourceforge.net

The usage information for each software in the ###Usage.doc### file.

# Performance evaluation
  
  The demo file in the result_data folder, there are all PA results for each tools.
  

