#!/bin/bash

# Usage: sbatch ./genome_prep.sh <method> <genome_file>

# Prepares the genome for bisulfite alignment

dir=$(dirname "$0")
method=$1

export SBATCH_BIO_GENOME_FILE=$2
export SBATCH_BIO_GENOME_DIR=$(dirname "$2")

case $method in
bismark|bwameth)
    source activate bio3
    ;;
bsseeker)
    source activate bio2
    ;;
*)
    echo "Invalid method $method"
    exit 1
    ;;
esac

sbatch "$dir/${method}_prep_sbatch.sh"
