#!/bin/bash
#SBATCH -M teach
#SBATCH -A hugen2076-2026f
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=cmg276@pitt.edu

#This scipt was worked in conjunction with Ceceliagh Pitstick, so there may be similarities, but the code is ultimately my own.

set -euo pipefail

# Example script from class
# Use this as starting point
# Modify the file as needed
# You may need to change it quite a bit!

# Example of how to run this script in this directory (output goes to your home directory)
# (Remember that this script ASSUMES bcftools is already loaded in your environment; don't put module load bcftools in this script!)
# ./extract_region.sh inputs/example.vcf.gz chr12 150000 500000 ~/example.vcf

### Takes 3 arguments:
#the path to an indexed VCF file (.vcf.gz)
#the path to a BED3 file containing one or more genomic regions
#the path to an output directory

# Rename variables
beg="/vast/hugen2076-2026f/unix_scripting_and_containers/hw1"

input_vcf=$( echo $beg/$1 )
input_bed=$( echo $beg/$2 )
output_dir=$3

#create a log file and append to it
echo $input_bed &> log_file.log

#how many regions in the Bed file - how many rows in the regions.bed file
wc -l $input_bed &>> log_file.log

mkdir -p $output_dir

#loop over everyrow of the bed file
while read line
do
	#extract chromo, left, right
	full_line=($line)
	chr=${full_line[0]}
	start=${full_line[1]}
	end=${full_line[2]}
	#only query if left at least 0, right  is greater than left
	if [ $end -gt $start -a $start -ge 0 ]
	then
		#convert
		new_start=$(( ${start} + 1))
		#remove chr
		new_chr=$( echo $chr | sed 's/chr//' )
		#suitable name
		output_vcf=$( echo ${chr}_${start}_${end}.vcf )
		#region to query
		region_temp=$( echo ${new_chr}:${new_start}-${end} )
		echo $region_temp &>> log_file.log
		#query
		bcftools view -r "$region_temp" "$input_vcf" -Ov -o "./results/$output_vcf" 2>> log_file.log
		echo ./results/$output_vcf &>> log_file.log
	else
		echo $line was invalid and skipped &>> log_file.log
	fi
	#covert BED to VCF - ad 1 to left, leave right, remove chr prefix
	#sutable named VCF file for region - chr12_150000_250000.vcf
done < $input_bed

#create a timestamped log file in output dir
#start by going through each part of the file and appending to a log file



# Adjust arguments to be suitable for bcftools
# First, get rid of the "chr" prefix in the chr variable
# Second, convert 0-start coordinate  to 1-start coordinates (simply add 1 to the left endpoint)
#chr=$(echo $chr | sed 's/chr//')
#start=$(( $start + 1 ))

# Create vcf query string
# It looks like this: chr12:1001-2000
#region_temp=$( echo ${chr}:${start}-${stop} )

# bcftools command
# Extract the region from the input .vcf.gz
#bcftools view \
#    -r "$region_temp" \
#    "$input_vcf" \
#    -Ov \
#    -o "$output_vcf"
