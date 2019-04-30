#!/bin/bash
#SBATCH -n 4
#SBATCH -p short
#SBATCH --mem 16G
#SBATCH -t 1:00:00

#                  BBtools

#toss - 1
srun -n 1 /home/ss1033/bbmap/repair.sh  in1=1_S1_L001_R1_001.fastq.gz in2=1_S1_L001_R2_001.fastq.gz out1=bb_1_S1_L001_R1_001.fastq.gz out2=bb_1_S1_L001_R2_001.fastq.gz outs=bb_S1_singletons.fastq.gz tossbrokenreads


#                  Trimmomatic
# Use BBtools fixed fastq (bb*.fastq)
srun -n 1 java -jar $TRIMMOMATIC/trimmomatic-0.36.jar PE -phred33 bb_1_S1_L001_R1_001.fastq.gz bb_1_S1_L001_R2_001.fastq.gz bb_trim_1_S1_R1_PE_paired.fastq.gz bb_trim_1_S1_R1_PE_unpaired.fastq.gz bb_trim_1_S1_R2_PE_paired.fastq.gz bb_trim_1_S1_R2_PE_unpaired.fastq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36



#                  Bowtie2
#  Output files have bb_trim_bt_*.sam
srun -n 1 bowtie2 -x /home/ss1033/miSeqData/miSeqFiles/bt2_indexes/Probes242 -I 377 -X 377 -p 4 --very-sensitive --no-unal -1 bb_trim_1_S1_R1_PE_paired.fastq.gz -2 bb_trim_1_S1_R2_PE_paired.fastq.gz -S bb_trim_bt_1_S1_P242.sam -k 1


#                  Samtools
#  QC #1
echo bt2Aligned
srun -n 1 samtools view -c bb_trim_bt_1_S1_P242.sam


# -q30
srun -n 1 samtools view -q 30 -bS bb_trim_bt_1_S1_P242.sam > bb_trim_bt_1_S1_P242.sam.bam

#  QC #2
echo q30Filtered
srun -n 1 samtools view -c bb_trim_bt_1_S1_P242.sam.bam


# sort
srun -n 1 samtools sort -T /tmp/bb_trim_bt_1_S1_P242.sam.bam_sorted.bam -o bb_trim_bt_1_S1_P242.sam.bam_sorted.bam bb_trim_bt_1_S1_P242.sam.bam
echo sorted

# index
srun -n 1 samtools index bb_trim_bt_1_S1_P242.sam.bam_sorted.bam;
echo indexed



#                  Picard
#  Removes duplicates
srun -n 1 java -jar $PICARD/picard-2.8.0.jar MarkDuplicates INPUT=bb_trim_bt_1_S1_P242.sam.bam_sorted.bam OUTPUT=bb_trim_bt_dedup_1_S1_P242.sam.bam_sorted.bam METRICS_FILE=bb_trim_bt_dedup_1_S1_P242.sam.bam_sorted.bam.dups.log REMOVE_SEQUENCING_DUPLICATES=true



#                  Samtools 
#  -F 1804 Remove Duplicates
#srun -n 1 samtools view -c -F 1804 bb_trim_bt_dedup_1_S1_P242.sam.bam_sorted.bam

#srun -n 1 samtools view -b -F 1804 bb_trim_bt_dedup_1_S1_P242.sam.bam_sorted.bam > Aligned_Cleaned_1_S1_P242.bam

srun -n 1 mv bb_trim_bt_dedup_1_S1_P242.sam.bam_sorted.bam Aligned_Cleaned_1_S1_P242.bam


#  Probe Flag Occurrences
echo all probes
echo f1 F0 
srun -n 1 samtools view -c -f 1 -F 0 Aligned_Cleaned_1_S1_P242.bam

echo all mapped probes
echo f1 F8
srun -n 1 samtools view -c -f 1 -F 8 Aligned_Cleaned_1_S1_P242.bam

echo concordant probes    
echo f2 F0 
srun -n 1 samtools view -c -f 2 -F 0 Aligned_Cleaned_1_S1_P242.bam

echo all discordant    
echo f0 F2 
srun -n 1 samtools view -c -f 0 -F 2 Aligned_Cleaned_1_S1_P242.bam

echo discordantly mspped probes
echo f0 F10 
srun -n 1 samtools view -c -f 0 -F 10 Aligned_Cleaned_1_S1_P242.bam



#  Filter Alignments
srun -n 1 samtools view -u -f 1 -F 0 Aligned_Cleaned_1_S1_P242.bam  > allPairedProbes_S1.bam

srun -n 1 samtools view -u -f 1 -F 8 Aligned_Cleaned_1_S1_P242.bam  > allPairedandMappedProbes_S1.bam

srun -n 1 samtools view -u -f 2 -F 0 Aligned_Cleaned_1_S1_P242.bam > ConcordantProbes_S1.bam

srun -n 1 samtools view -u -f 0 -F 2 Aligned_Cleaned_1_S1_P242.bam  > allDiscordantProbes_S1.bam

srun -n 1 samtools view -u -f 0 -F 10 Aligned_Cleaned_1_S1_P242.bam  > DiscordantMappedProbes_S1.bam

#  Sorts BAM files
for i in *S1.bam;
do 
srun -n 1 samtools sort -T /tmp/${i}_sorted.bam -o ${i}_sorted.bam ${i};
done

echo sorted

for i in *S1.bam_sorted.bam;
do
srun -n 1 samtools index ${i};
done

echo indexed



#                   Counts Text
#  Populates Text file

for i in *S1.bam_sorted.bam;

do 
srun -n 1 samtools view ${i} | cut -f 3 | sort | uniq -c | awk '{printf("%s\t%s\n", $2, $1)}' > ${i}_counts.txt
done


#  Sorts numerically
for i in *S1.bam_sorted.bam_counts.txt;

do
srun -n 1 sort -n ${i} > sorted_${i} 
done

for i in sorted_*

do
awk '{ while (NR + shift < $1) { print (NR + shift) "\t"0; shift++ }; print } END { shift++; while (NR + shift < 3164) { print (NR + shift) "\t"0; shift++ } }' ${i} > fill${i}
done