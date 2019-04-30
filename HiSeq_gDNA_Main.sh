#!/bin/bash
#SBATCH -n 4
#SBATCH -p short
#SBATCH --mem 16G
#SBATCH -t 1:00:00

#                  BBtools

#toss - 1
#srun -n 1 /home/ss1033/bbmap/repair.sh in=Capture-200-50ul-E_coli_S1_R1_001.fastq.gz out=bb_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz outs=bb_Capture-200-50ul-E_coli_singletons.fastq.gz tossbrokenreads


#                  Trimmomatic
# Use BBtools fixed fastq (bb*.fastq)
#srun -n 1 java -jar $TRIMMOMATIC/trimmomatic-0.36.jar SE -phred33 Capture-200-50ul-E_coli_S1_R1_001.fastq.gz trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz ILLUMINACLIP:TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

#                  Bowtie2
#  Output files have bb_trim_bt_*.sam
#srun -n 1 bowtie2 -x /home/ss1033/hiSeqData/bt2_Capture_Index/K12_Mg1655 -p 4 --very-sensitive --no-unal -U trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz -S Genome_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam -k 1 > Genome_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.txt

#srun -n 1 bowtie2 -x /home/ss1033/hiSeqData/bt2_Capture_Index/K12_CaptRef -p 4 --very-sensitive --no-unal -U trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz -S CaptRef_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam -k 1 > CaptRef_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.txt

#                 Samtools
# -q30
#for i in *trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam;
#do
#srun -n 1 samtools view -q 30 -bS ${i} > ${i}.bam
#done

# sort
#for i in *trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam;
#do
#srun -n 1 samtools sort -T /tmp/${i}_sorted.bam -o ${i}_sorted.bam ${i}
#done

#echo sorted

# index
#for i in *_sorted.bam;
#do
#srun -n 1 samtools index ${i};
#done

#echo indexed

#                 Picard 
# Cleanup

#srun -n 1 java -jar $PICARD/picard-2.8.0.jar MarkDuplicates INPUT="/home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/S1_CaptRef/Genome_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam" OUTPUT="/home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/S1_CaptRef/Genome_dedup_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam" METRICS_FILE="/home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/S1_CaptRef/Genome_dedup_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.bam_sorted.bam.dups.log" REMOVE_DUPLICATES=true

srun -n 1 java -jar $PICARD/picard-2.8.0.jar MarkDuplicates INPUT="/home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/S1_CaptRef/CaptRef_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam" OUTPUT="/home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/S1_CaptRef/CaptRef_dedup_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam" METRICS_FILE="/home/ss1033/hiSeqData/E_Coli_50ul_v_2ml/S1_CaptRef/CaptRef_dedup_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.bam_sorted.bam.dups.log" REMOVE_DUPLICATES=true

#    Samtools Remove Duplicates
# -F 1804
#srun -n 1 samtools view -c -F 1804 Genome_dedup_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam

srun -n 1 samtools view -c -F 1804 CaptRef_dedup_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam

#srun -n 1 samtools view -b -F 1804 Genome_dedup_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam > Genome_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.bam_sorted.bam

srun -n 1 samtools view -b -F 1804 CaptRef_dedup_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam > CaptRef_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.bam_sorted.bam

# Picard Insert Size metrics
srun -n 1 java -jar $PICARD/picard-2.8.0.jar CollectInsertSizeMetrics I= O= H= M=0.5


