####################################################################################
# 0. Setting working fold and initial parameters
####################################################################################
Data=/home/Metagenome/Pipeline/Metagenome/CAD
GP1=/usr/local/MetaGenome

####################################################################################
# Do BLAT on cds for each sample
####################################################################################


for m in $(ls $Data/7_Total_Uniq_Gene/*.uniq.cds.fa)
do
	blat $Data/7_Total_Uniq_Gene/$(basename $m) $Data/7_Total_Uniq_Gene/Total.cds.fa -noHead  $Data/7_Total_Uniq_Gene/$(basename ${m%.fa}).psl
done


