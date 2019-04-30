#!/bin/bash
#SBATCH -n 4
#SBATCH -p short
#SBATCH --mem 8G
#SBATCH -t 1:00:00

#srun -n 1 bowtie2-build -f /home/ml266/miSeqData/copyFiles/Ligation242.fasta /home/ml266/miSeqData/copyFiles/Ligation242

#srun -n 1 bowtie2-build -f /home/ml266/miSeqData/copyFiles/Extension242.fasta /home/ml266/miSeqData/copyFiles/Extension242

srun -n 1 bowtie2-build -f /home/ml266/miSeqData/miSeqFiles/bt2_indexes/Probes242.fasta /home/ml266/miSeqData/miSeqFiles/bt2_indexes/Probes242
srun -n 1 bowtie2-build -f /home/ml266/miSeqData/miSeqFiles/bt2_indexes/Probes442.fasta /home/ml266/miSeqData/miSeqFiles/bt2_indexes/Probes442
srun -n 1 bowtie2-build -f /home/ml266/miSeqData/miSeqFiles/bt2_indexes/Probes800.fasta /home/ml266/miSeqData/miSeqFiles/bt2_indexes/Probes800