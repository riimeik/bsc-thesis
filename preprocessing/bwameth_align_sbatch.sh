#!/bin/bash

#SBATCH --job-name=bwameth_align
#SBATCH --cpus-per-task=5
#SBATCH --mem=12G
#SBATCH --time=03:00:00
#SBATCH --error=%x-%A-%a.out
#SBATCH --output=%x-%A-%a.out

src=$SBATCH_BIO_SRC
names_arr=($SBATCH_BIO_NAMES)
name=${names_arr[SLURM_ARRAY_TASK_ID]}
out_name=${SBATCH_BIO_OUT}/${name}_bwameth

date
bwameth.py --threads 3 --reference "$SBATCH_BIO_GENOME_FILE" "${src}/${name}_1.fastq" "${src}/${name}_2.fastq" > "${out_name}.sam"
date
