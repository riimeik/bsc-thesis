#!/bin/bash

#SBATCH --job-name=bwameth_meth
#SBATCH --cpus-per-task=3
#SBATCH --mem=8G
#SBATCH --time=02:00:00
#SBATCH --error=%x-%A-%a.out
#SBATCH --output=%x-%A-%a.out

src=$SBATCH_BIO_SRC
names_arr=($SBATCH_BIO_NAMES)
name=${names_arr[SLURM_ARRAY_TASK_ID]}

date
samtools view -b -o "$src/$name.bam" "$src/$name.sam"
samtools sort -o "$src/$name.bam" "$src/$name.bam"
MethylDackel extract -@ 3 --CHH --CHG "$SBATCH_BIO_GENOME_FILE" "$src/$name.bam"
date
