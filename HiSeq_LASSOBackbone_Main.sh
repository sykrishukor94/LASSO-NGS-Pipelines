#!/bin/bash
#SBATCH -n 4
#SBATCH -p short
#SBATCH --mem 16G
#SBATCH -t 1:00:00


#                  Trimmomatic
# Use BBtools fixed fastq (bb*.fastq)
#srun -n 1 java -jar $TRIMMOMATIC/trimmomatic-0.36.jar SE -phred33 Capture-200-50ul-E_coli_S1_R1_001.fastq.gz trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz ILLUMINACLIP:TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

#                  Bowtie2
#  Output files have bb_trim_bt_*.sam
srun -n 1 bowtie2 -x /home/ss1033/hiSeqData/bt2_Capture_Index/LASSOBackbone -p 4 --very-sensitive --no-unal -U trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz -S LASSOBackbone_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam -k 1 > LASSOBackbone_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.txt


echo bt2Aligned
srun -n 1 samtools view -c LASSOBackbone_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam



#                 Samtools
# -q30
for i in *trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam;
do
srun -n 1 samtools view -q 30 -bS ${i} > ${i}.bam
done

echo q30Filtered
srun -n 1 samtools view -c LASSOBackbone_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam


# sort
for i in *trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam;
do
srun -n 1 samtools sort -T /tmp/${i}_sorted.bam -o ${i}_sorted.bam ${i}
done
echo sorted

# index
for i in *_sorted.bam;
do
srun -n 1 samtools index ${i};
done
echo indexed

#                 Picard 
# Cleanup
srun -n 1 java -jar $PICARD/picard-2.8.0.jar MarkDuplicates INPUT=LASSOBackbone_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam OUTPUT=LASSOBackbone_dedup_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam METRICS_FILE=LASSOBackbone_dedup_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam.dups.log REMOVE_DUPLICATES=true



echo Picardedup
srun -n 1 samtools view -c LASSOBackbone_dedup_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam

#    Samtools Remove Duplicates
srun -n 1 samtools view -c -F 1804 LASSOBackbone_dedup_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam

srun -n 1 samtools view -b -F 1804 LASSOBackbone_dedup_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam > LASSOBackbone_dedup_F1804_trim_Capture-200-50ul-E_coli_S1_R1_001.fastq.gz.sam.bam_sorted.bam

# Picard Insert Size metrics
#srun -n 1 java -jar $PICARD/picard-2.8.0.jar CollectInsertSizeMetrics I= O= H= M=0.5


