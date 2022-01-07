#!/bin/bash

# Usage: ./create_symlinks.sh <files_dir> <out_dir> <prefix>

# Creates symlinks of FASTQ files to be fed into aligners

src=$1
out=$2
prefix=$3

if [ ! -d "$out" ]; then
    mkdir "$out" || exit 1
fi

files=($(find $src -name '*.f*q'))
i=0
regex=".*/(.+)_(L001_R(1|2)_001|(1|2)_val_(1|2)).(fastq|fq)"

for file in ${files[@]}; do
    if [[ $file =~ $regex ]]; then
        name=${BASH_REMATCH[1]}

        if [ ! -z "${BASH_REMATCH[3]}" ]; then
            read=${BASH_REMATCH[3]}
        else
            read=${BASH_REMATCH[4]}
        fi

        newfile="$out/${prefix}${name}_${read}.fastq"

        if [ ! -L "$newfile" ]; then
            ln -s "$(realpath "$file")" "$newfile"
            i=$[i+1]
        fi
    fi
done

echo "$i/${#files[@]} files symlinked"
