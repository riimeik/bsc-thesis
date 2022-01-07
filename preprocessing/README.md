# Calculating site methylation proportions from raw FASTQ reads

> All scripts are expected to be run on a compute cluster supporting [Slurm](https://slurm.schedmd.com/)

> Sequence files are expected to reside in `./raw_data` and named `{PATIENT}_S{SEQNR}_L001_R{READDIR}_001.fastq` (e.g. `V22298_S176_L001_R2_001.fastq`)

## Software installation

Because some software is only supported on Pyhon 2.x and some on 3.x, we have to work with two conda environments:


```bash
conda env create -f ./bio2.yml
conda env create -f ./bio3.yml
```

Download the alignment software (bwameth is already installed as part of the conda environment):

```bash
mkdir software
cd software

wget https://github.com/FelixKrueger/Bismark/archive/0.21.0.zip
unzip ./0.21.0.zip
rm ./0.21.0.zip
wget https://github.com/BSSeeker/BSseeker2/archive/BSseeker2-v2.1.8.zip
unzip ./BSseeker2-v2.1.8.zip
rm ./BSseeker2-v2.1.8.zip

# Load the aligners into current env
source ./env.sh
cd ..
```

## Reference genome preparation

Start with downloading the reference genome:

```bash
mkdir genome
cd genome

wget ftp://ftp.ensembl.org/pub/grch37/current/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.dna.primary_assembly.fa.gz

# Resource-intensive operation, run with Slurm
srun --mem=10G --time=00:02:00 gunzip ./Homo_sapiens.GRCh37.dna.primary_assembly.fa.gz

cd ..
```

Then run the preparation script (bisulfite prep, indexing) for each alignment method (replace bismark with bwameth or bsseeker):

```bash
./genome_prep.sh bismark ./genome/Homo_sapiens.GRCh37.dna.primary_assembly.fa
```

## Quality control

To obtain a preliminary quality control report on the data:

```bash
mkdir processing
cd processing
source activate bio3

# Create renamed symlinks to FASTQ files
../create_symlinks.sh ../raw_data ./data
# Generate FastQC reports
../fastqc.sh ./data ./raw_fq
# Aggregate with MultiQC
multiqc ./raw_fq
```

## Adapter trimming

Since the previous report indicates adapter contamination, perform adapter trimming and generate a new quality control report:

```bash
../trim.sh ./data ./trimmed_res
../create_symlinks.sh ./trimmed_res ./trimmed
../fastqc.sh ./trimmed ./trimmed_fq
multiqc ./trimmed_fq
```

## Alignment

Perform bisulfite alignment of the trimmed sequences for each method (replace bismark with bwameth or bsseeker):

```bash
../align.sh bismark ../genome/Homo_sapiens.GRCh37.dna.primary_assembly.fa ./trimmed ./aligned
```

## Methylation calling

Run the following script to generate methylation reports for all methods at once:

```bash
../calc_meth.sh ../genome/Homo_sapiens.GRCh37.dna.primary_assembly.fa ./aligned
```

Finally, download the reports to your own computer:

```bash
scp user@cluster:./processing/aligned ../meth
```
