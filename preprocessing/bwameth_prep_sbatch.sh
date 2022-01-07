#!/bin/bash

#SBATCH --job-name=bwameth_prep
#SBATCH --mem=32G
#SBATCH --time=06:00:00
#SBATCH --error=%x-%A.out
#SBATCH --output=%x-%A.out

date
bwameth.py index "$SBATCH_BIO_GENOME_FILE"
date
