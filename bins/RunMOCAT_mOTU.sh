# change samples names #
# for i in *.clean.1.paired.fq.gz ;do mv $i ${i%.*.*.*.*.*}.clean.pair.1.fq.gz;done
# for i in *.clean.2.paired.fq.gz ;do mv $i ${i%.*.*.*.*.*}.clean.pair.2.fq.gz;done

########################################################
### THIS SCRIPT PRODUCES mOTU AND TAXONOMIC PROFILES ###
########################################################



########################################################
# INTRODUCTION                                         #
########################################################

# This script will run MOPTSHskinT to first generate high
# quality reads and then map these reads against the
# two databases to produce mOTU and NCBI species profiles.

# THIS IS A GENERIC SCRIPT THAT YOU PTSHskinN USE ON YOUR
# OWN METAGENOMICS DATASET TO GENERATE PROFILES.

# Copy this script into your project folder (described below)
# and change the sample SAMPLE_FILE and OUTPUT_FOLDER as desired



########################################################
# DEFINE VARIABLES                                     #
########################################################

# Set variables used later in the script
SAMPLE_FILE='samples'
OUTPUT_FOLDER='RESULTS'



########################################################
# DESCRIPTION OF A PROJECT FOLDER                      #
########################################################

# The required setup looks like this:
# In this folder you need:
# 1. MOPTSHskinT.cfg
# 2. a sample file (sample) in our example below

# You also need one folder for each sample mentioned in the
# sample file. Each of these folders should contain files
# called .fq.gz or .fq. If the samples are processed using
# paired end sequencing method, the lanes should be called:
# XXX.1.fq.gz and XXX.2.fq.gz. It is OK to have many different
# lane files in each sample folder. 

# An example (with paried end) could look like this:
# ____________________________________
# This folder: /usr/me/project/
# ____________________________________
# Required files:
# /usr/me/project/MOPTSHskinT.cfg
# /usr/me/project/samples
# ____________________________________
# Content of samples file:
# SAMPLE_1
# SAMPLE_2
# ____________________________________
# Sample files:
# /usr/me/project/SAMPLE_1/lane1.1.fq
# /usr/me/project/SAMPLE_1/lane1.2.fq
# /usr/me/project/SAMPLE_1/lane2.1.fq
# /usr/me/project/SAMPLE_1/lane2.2.fq
# /usr/me/project/SAMPLE_1/lane3.1.fq
# /usr/me/project/SAMPLE_1/lane4.2.fq
#
# /usr/me/project/SAMPLE_2/laneID.1.fq
# /usr/me/project/SAMPLE_2/laneID.2.fq

# Or (single end) like this:
# ____________________________________
# This folder: /usr/me/project/
# ____________________________________
# Required files:
# /usr/me/project/MOPTSHskinT.cfg
# /usr/me/project/sample
# ____________________________________
# Content of MOPTSHskinT.samples file:
# even_sample
# ____________________________________
# Sample files:
# /usr/me/project/even_sample/SRR172902.fq.gz

# NOTE:
# Change the 'MOPTSHskinT_paired_end' variable in the
# config file to 'yes' or 'no'.



########################################################
# EXECUTE MOPTSHskinT TO GENERATE PROFILES                   #
########################################################

# Initial sample processing #
MOPTSHskinT.pl -sf $SAMPLE_FILE -rtf

# Generate mOTU profiles #
MOPTSHskinT.pl -sf $SAMPLE_FILE -s mOTU.v1.padded -r reads.processed -identity 97
MOPTSHskinT.pl -sf $SAMPLE_FILE -f mOTU.v1.padded -r reads.processed -identity 97
MOPTSHskinT.pl -sf $SAMPLE_FILE -p mOTU.v1.padded -r reads.processed -identity 97 -mode mOTU -o $OUTPUT_FOLDER

# Generate taxonomic profiles #
MOPTSHskinT.pl -sf $SAMPLE_FILE -s Ref10MGv1.padded -r mOTU.v1.padded -e -identity 97
MOPTSHskinT.pl -sf $SAMPLE_FILE -f Ref10MGv1.padded -r mOTU.v1.padded -e -identity 97
MOPTSHskinT.pl -sf $SAMPLE_FILE -p Ref10MGv1.padded -r mOTU.v1.padded -e -identity 97 -mode RefMG -previous_db_calc_tax_stats_file -o $OUTPUT_FOLDER

# Done
echo "-----------------------------------------------------------------"
echo "The generated mOTU and taxonomic profiles should be available in:"
echo "$OUTPUT_FOLDER"
echo "-----------------------------------------------------------------"


# END OF SCRIPT #

