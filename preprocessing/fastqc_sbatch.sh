#!/bin/bash

#SBATCH --job-name=fastqc
#SBATCH --mem=300M
#SBATCH --time=00:10:00
#SBATCH --error=%x-%A-%a.out
#SBATCH --output=%x-%A-%a.out

files_arr=($SBATCH_BIO_FILES)

date
fastqc --noextract --outdir "$SBATCH_BIO_OUT" "${files_arr[SLURM_ARRAY_TASK_ID]}"
date
