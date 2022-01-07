#!/bin/bash

#SBATCH --job-name=bismark_meth
#SBATCH --cpus-per-task=3
#SBATCH --mem-per-cpu=8G
#SBATCH --time=02:00:00
#SBATCH --error=%x-%A-%a.out
#SBATCH --output=%x-%A-%a.out

src=$SBATCH_BIO_SRC
names_arr=($SBATCH_BIO_NAMES)
name=${names_arr[SLURM_ARRAY_TASK_ID]}
genome_dir=$(realpath "$SBATCH_BIO_GENOME_DIR")

cd "$src"

date
bismark_methylation_extractor --genome_folder "$genome_dir" --buffer_size 6G --bedGraph "./$name.bam"
gunzip "./$name.bismark.cov.gz"
date
