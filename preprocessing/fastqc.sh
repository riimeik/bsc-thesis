#!/bin/bash

# Usage: ./fastqc.sh <files_dir> <out_dir>

# Runs fastqc on all files in the folder in parallel

dir=$(dirname "$0")
src=$1
out=$2

if [ ! -d "$out" ]; then
    mkdir "$out" || exit 1
fi

files=($(find $src -name '*.fastq'))

export SBATCH_BIO_FILES="${files[@]}"
export SBATCH_BIO_OUT=$out

if [ "${#files[@]}" -ne 0 ]; then
    source activate bio3
    sbatch --array=0-$[${#files[@]}-1] "$dir/fastqc_sbatch.sh"
fi
