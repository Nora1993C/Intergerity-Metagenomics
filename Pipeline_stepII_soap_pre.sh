

#08.Jan.2014
#Processing the Gut metagenome data using same Pipeline

#Initial Steps: setting working fold and initial parameters
####################################################################################
# 0. Setting working fold and initial parameters
####################################################################################
Data=/home/Metagenome/Pipeline/Metagenome/CAD
Bin=/usr/local/Scripts

####################################################################################
# 2.1. Combine the still paired reads and extract single reads
####################################################################################
FQ_delim="/"
for n in $(ls $Data/2_High_quality_reads/S2017*.clean.1.fq);
do 
	Fline=$(head -1 $n);
	FQ_F4=${Fline:0:4};
	$Bin/fastqcombinepairedend_frq.py $FQ_F4 $FQ_delim ${n%.*.*}.1.fq ${n%.*.*}.2.fq;
	mv ${n%.*.*}.*.paired.fq $Data/3_Assembly/;
	mv ${n%.*.*}.single.fq $Data/3_Assembly/;
done

