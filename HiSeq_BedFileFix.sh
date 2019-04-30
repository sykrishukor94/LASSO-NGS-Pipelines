#!/bin/bash
#SBATCH -n 4
#SBATCH -p short
#SBATCH --mem 8G
#SBATCH -t 1:00:00

for i in *.bed
do
srun -n 1 dos2unix ${i}
srun -n 1 sed -i -e '$a\' ${i}
done