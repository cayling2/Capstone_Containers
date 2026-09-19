#!/bin/bash

set -euo pipefail

# Example script from class
# Use this as starting point
# Modify the file as needed
# This one should not require major changes

#Use the same three arguments from the extract_region.sh
input_vcf=$1
input_bed=$2
output_dir=$3

# Need to load singularity befor running it
module load singularity

# Start a container where bcftools is loaded
# Depending on where you run this script, you might need to give the full path to the image file
# Run your extract_region.sh script
# Notice that THIS script takes the 5 arguments of extract_region.sh and passes them to that script
# Example of how to run this container script:
# ./run_container.sh inputs/example.vcf.gz chr12 150000 500000 ~/example.vcf
singularity exec -B /vast/hugen2076-2026f/unix_scripting_and_containers/hw1:/work \
	bcftools_1.24.sif \
	bash extract_region.sh "$1" "$2" "$3"

#explicitly bind the current working directory to /work inside container
