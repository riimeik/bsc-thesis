#!/bin/bash

#SBATCH --job-name=bsseeker_align
#SBATCH --cpus-per-task=6
#SBATCH --mem=12G
#SBATCH --time=06:00:00
#SBATCH --error=%x-%A-%a.out
#SBATCH --output=%x-%A-%a.out

src=$SBATCH_BIO_SRC
names_arr=($SBATCH_BIO_NAMES)
name=${names_arr[SLURM_ARRAY_TASK_ID]}

date
bs_seeker2-align.py --genome="$SBATCH_BIO_GENOME_FILE" --maxins=1000 --aligner=bowtie2 --bt2--mm --bt2--threads 3 --output="${SBATCH_BIO_OUT}/${name}_bsseeker.bam" -1 "${src}/${name}_1.fastq" -2 "${src}/${name}_2.fastq"
date
