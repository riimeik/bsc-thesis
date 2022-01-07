#!/bin/bash

#SBATCH --job-name=trim_galore
#SBATCH --mem=300M
#SBATCH --time=00:30:00
#SBATCH --error=%x-%A-%a.out
#SBATCH --output=%x-%A-%a.out

src=$SBATCH_BIO_SRC
out=$SBATCH_BIO_OUT
names_arr=($SBATCH_BIO_NAMES)
name=${names_arr[SLURM_ARRAY_TASK_ID]}

date
trim_galore --nextera --output_dir "$out" --paired "${src}/${name}_1.fastq" "${src}/${name}_2.fastq"
date
