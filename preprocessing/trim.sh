#!/bin/bash

# Usage: ./trim.sh <files_dir> <out_dir>

# Runs trim_galore on paired-end FASTQ files in the directory

dir=$(dirname "$0")
src=$1
out=$2

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

echo "Trimming ${#valid_files_arr[@]}/${#files[@]} pairs"

export SBATCH_BIO_OUT=$out
export SBATCH_BIO_SRC=$src
export SBATCH_BIO_NAMES="${valid_files_arr[@]}"

if [ "${#valid_files_arr[@]}" -ne 0 ]; then
    source activate bio3
    sbatch --array=0-$[${#valid_files_arr[@]}-1] "$dir/trim_sbatch.sh"
fi
