#!/bin/bash

#SBATCH --job-name=bismark_prep
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=4G
#SBATCH --time=06:00:00
#SBATCH --error=%x-%A.out
#SBATCH --output=%x-%A.out

date
bismark_genome_preparation --parallel 5 --verbose "$SBATCH_BIO_GENOME_DIR"
date
