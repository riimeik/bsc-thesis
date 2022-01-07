#!/bin/bash

# Usage: sbatch ./calc_meth.sh <genome_file> <files_dir>

# Extracts methylation data

src=$2
dir=$(dirname "$0")

bismark_regex=".*/(.+_bismark_bt2_pe).bam$"
bwameth_regex=".*/(.+_bwameth).sam$"
bsseeker_regex=".*/(.+_bsseeker).bam$"

files=($(find $src -name '*'))
bismark_files_arr=()
bwameth_files_arr=()
bsseeker_files_arr=()

for file in ${files[@]}; do
    if [[ $file =~ $bismark_regex ]]; then
        name=${BASH_REMATCH[1]}
        bismark_files_arr+=("$name")
    elif [[ $file =~ $bwameth_regex ]]; then
        name=${BASH_REMATCH[1]}
        bwameth_files_arr+=("$name")
    elif [[ $file =~ $bsseeker_regex ]]; then
        name=${BASH_REMATCH[1]}
        bsseeker_files_arr+=("$name")
    fi
done

echo "Extracting methylation from ${#bismark_files_arr[@]} bismark, ${#bwameth_files_arr[@]} bwameth, ${#bsseeker_files_arr[@]} bsseeker alignments"

export SBATCH_BIO_SRC=$src
export SBATCH_BIO_GENOME_FILE=$1
export SBATCH_BIO_GENOME_DIR=$(dirname "$1")

if [ "${#bismark_files_arr[@]}" -ne 0 ]; then
    source activate bio3
    export SBATCH_BIO_NAMES="${bismark_files_arr[@]}"
    sbatch --array=0-$[${#bismark_files_arr[@]}-1] "$dir/bismark_meth_sbatch.sh"
fi

if [ "${#bwameth_files_arr[@]}" -ne 0 ]; then
    source activate bio3
    export SBATCH_BIO_NAMES="${bwameth_files_arr[@]}"
    sbatch --array=0-$[${#bwameth_files_arr[@]}-1] "$dir/bwameth_meth_sbatch.sh"
fi

if [ "${#bsseeker_files_arr[@]}" -ne 0 ]; then
    source activate bio2
    export SBATCH_BIO_NAMES="${bsseeker_files_arr[@]}"
    sbatch --array=0-$[${#bsseeker_files_arr[@]}-1] "$dir/bsseeker_meth_sbatch.sh"
fi
