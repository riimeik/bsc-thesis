#!/bin/bash

#SBATCH --job-name=bsseeker_prep
#SBATCH --cpus-per-task=16
#SBATCH --mem=16G
#SBATCH --time=06:00:00
#SBATCH --error=%x-%A.out
#SBATCH --output=%x-%A.out

date
bs_seeker2-build.py --aligner=bowtie2 --bt2--threads 16 --file="$SBATCH_BIO_GENOME_FILE" --up=1000
date
