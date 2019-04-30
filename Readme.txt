README
# The following scripts are adapted for Orchestra, the Harvard Medical School Research Computing Cluster
# Files and scripts are listed in order of usage. Calls to certain reference indexed .fasta files or .bed files need to be updated accordingly.


LASSO REFERENCE SEQUENCE PREPARATION

Bowtie2BuildIndex.sh
# Indexes .fasta files of reference sequences within the "Fasta Files" folder

HiSeq_BedFileFix.sh
# 'Fixes' custom .bed files within 'Bed Files' folder before use


LASSO ASSEMBLY NGS PIPELINE

MiSeq_Main.sh
# Main script for analyzing MiSeq reads, requires the following files to run:- 
# 	R1 & R2 Raw Sequencing output
#	TruSeq3-PE.fa
#	Indexed Probes242.fasta


LASSO CAPTURE NGS PIPELINE

HiSeq_gDNA_Main.sh
HiSeq_LASSOBackbone_Main.sh
# Scripts for processing raw sequencing reads and aligning reads to either genomic DNA or LASSO probe backbone to first gauge LASSO capture efficiency

HiSeq_gDNA_BedTools.sh
HiSeq_LASSOBackbone_BedTools.sh
# Script to align output .bam files and process into output files for statistical analysis