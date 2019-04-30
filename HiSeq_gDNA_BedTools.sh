#!/bin/bash
#SBATCH -n 4
#SBATCH -p short
#SBATCH --mem 8G
#SBATCH -t 1:00:00

srun -n 1 bedtools genomecov -ibam Genome_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.bam_sorted.bam -g /home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/BedTools/Genome/MG1655_All_Cds.fasta.fai -d > depthDGene_S1.txt



srun -n 1 bedtools bamtobed -i Genome_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.bam_sorted.bam > Genome_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.bam_sorted.bam.bed



srun -n 1 bedtools coverage -b Genome_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.bam_sorted.bam.bed -a /home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/BedTools/Bed_Files/Target100_ORF_NC_000913.bed -wa > targetshundred_S1.out

srun -n 1 bedtools coverage -b Genome_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.bam_sorted.bam.bed -a /home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/BedTools/Bed_Files/Target_ORF_NC_000913.bed -wa > targets_S1.out

srun -n 1 bedtools coverage -b Genome_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.bam_sorted.bam.bed -a /home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/BedTools/Bed_Files/Non_Target_ORF_NC_000913.bed -wa > nontargets_S1.out

srun -n 1 bedtools coverage -b Genome_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.bam_sorted.bam.bed -a /home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/BedTools/Bed_Files/Intergenic_NC_000913.bed > complement_S1.out


srun -n 1 bedtools coverage -b Genome_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.bam_sorted.bam.bed -a /home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/BedTools/Bed_Files/Target100_ORF_NC_000913.bed  -mean -wa > targetshundredd_S1.out

srun -n 1 bedtools coverage -b Genome_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.bam_sorted.bam.bed -a /home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/BedTools/Bed_Files/Target_ORF_NC_000913.bed  -mean -wa > targetsd_S1.out

srun -n 1 bedtools coverage -b Genome_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.bam_sorted.bam.bed -a /home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/BedTools/Bed_Files/Non_Target_ORF_NC_000913.bed  -mean -wa > nontargetsd_S1.out

srun -n 1 bedtools coverage -b Genome_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.bam_sorted.bam.bed -a /home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/BedTools/Bed_Files/Intergenic_NC_000913.bed  -mean > complementd_S1.out



srun -n 1 bedtools nuc -fi /home/ss1033/hiSeqData/bt2_Capture_Index/K12_Mg1655.fasta -bed /home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/BedTools/Bed_Files/Target_ORF_NC_000913.bed > targetsCoverageATGC.txt

srun -n 1 bedtools nuc -fi /home/ss1033/hiSeqData/bt2_Capture_Index/K12_Mg1655.fasta -bed /home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/BedTools/Bed_Files/Non_Target_ORF_NC_000913.bed > nontargetsCoverageATGC.txt

srun -n 1 bedtools nuc -fi /home/ss1033/hiSeqData/bt2_Capture_Index/K12_Mg1655.fasta -bed /home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/BedTools/Bed_Files/Intergenic_NC_000913.bed > complementCoverageATGC.txt

srun -n 1 bedtools nuc -fi /home/ss1033/hiSeqData/bt2_Capture_Index/K12_Mg1655.fasta -bed /home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/BedTools/Bed_Files/Target100_ORF_NC_000913.bed > targets100CoverageATGC.txt