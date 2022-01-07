#!/bin/bash

#SBATCH --job-name=bsseeker_meth
#SBATCH --mem=8G
#SBATCH --time=02:00:00
#SBATCH --error=%x-%A-%a.out
#SBATCH --output=%x-%A-%a.out

src=$SBATCH_BIO_SRC
names_arr=($SBATCH_BIO_NAMES)
name=${names_arr[SLURM_ARRAY_TASK_ID]}

db_name=$(basename "$SBATCH_BIO_GENOME_FILE")_bowtie2
bsseeker_dir=$(dirname "$(which bs_seeker2-call_methylation.py)")
db_path=$bsseeker_dir/bs_utils/reference_genomes/$db_name

date
bs_seeker2-call_methylation.py --db="$db_path" --input="$src/$name.bam"
gunzip "$src/$namer.bam.CGmap.gz"
date
