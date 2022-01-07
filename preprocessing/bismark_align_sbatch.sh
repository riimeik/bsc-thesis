#!/bin/bash

#SBATCH --job-name=bismark_align
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --error=%x-%A-%a.out
#SBATCH --output=%x-%A-%a.out

src=$SBATCH_BIO_SRC
names_arr=($SBATCH_BIO_NAMES)
name=${names_arr[SLURM_ARRAY_TASK_ID]}

date
bismark --maxins 1000 --parallel 2 --output_dir "$SBATCH_BIO_OUT" "$SBATCH_BIO_GENOME_DIR" -1 "${src}/${name}_1.fastq" -2 "${src}/${name}_2.fastq"
date
