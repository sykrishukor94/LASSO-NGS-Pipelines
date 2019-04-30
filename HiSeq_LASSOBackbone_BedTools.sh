#!/bin/bash
#SBATCH -n 4
#SBATCH -p short
#SBATCH --mem 8G
#SBATCH -t 1:00:00

#srun -n 1 bedtools genomecov -ibam LASSOBackbone_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam -g /home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/BedTools/Genome/LASSOBackbone.fasta -d > depthDGene.txt


srun -n 1 bedtools bamtobed -i LASSOBackbone_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam > LASSOBackbone_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam.bed




srun -n 1 bedtools coverage -b LASSOBackbone_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam.bed -a /home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/BedTools/Bed_Files/LASSOArms.bed -wa > LASSOBackbone_S1.out




srun -n 1 bedtools coverage -b LASSOBackbone_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam.bed -a /home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/BedTools/Bed_Files/LASSOArms.bed  -mean -wa > LASSOBackboned_S1.out




srun -n 1 bedtools nuc -fi /home/ss1033/hiSeqData/bt2_Capture_Index/LASSOBackbone.fasta -bed /home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/BedTools/Bed_Files/LASSOArms.bed > targets100CoverageATGC.txt