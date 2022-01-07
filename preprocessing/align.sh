#!/bin/bash

# Usage: sbatch ./align.sh <method> <genome_file> <files_dir> <out_dir>

# Performs alignment of reads

method=$1
src=$3
out=$4
dir=$(dirname "$0")

if [ ! -d "$out" ]; then
    mkdir "$out" || exit 1
fi

files=($(find $src -name '*_1.fastq'))
valid_files_arr=()
i=0
regex=".*/(.+)_1.fastq"

for file in ${files[@]}; do
    if [[ $file =~ $regex ]]; then
        name=${BASH_REMATCH[1]}
        file2="${src}/${name}_2.fastq"

        if [ ! -f "${file2}" ]; then
            echo "File ${file} has no corresponding _2.fastq file"
            continue
        fi

        valid_files_arr+=("$name")
    fi
done

echo "Aligning ${#valid_files_arr[@]}/${#files[@]} pairs using $method"

export SBATCH_BIO_GENOME_FILE=$2
export SBATCH_BIO_GENOME_DIR=$(dirname "$2")
export SBATCH_BIO_OUT=$out
export SBATCH_BIO_SRC=$src
export SBATCH_BIO_NAMES="${valid_files_arr[@]}"

case $method in
bismark)
    time_mins=15
    source activate bio3
    ;;
bwameth)
    time_mins=30
    source activate bio3
    ;;
bsseeker)
    time_mins=15
    source activate bio2
    ;;
*)
    echo "Invalid method $method"
    exit 1
    ;;
esac

if [ "${#valid_files_arr[@]}" -ne 0 ]; then
    sbatch --array=0-$[${#valid_files_arr[@]}-1] "$dir/${method}_align_sbatch.sh"
fi
