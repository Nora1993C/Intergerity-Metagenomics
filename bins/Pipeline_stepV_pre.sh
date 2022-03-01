####################################################################################
# 0. Setting working fold and initial parameters
####################################################################################
Data=/home/Metagenome/Pipeline/Metagenome/CAD
GP1=/usr/local/MetaGenome

####################################################################################
# Do BLAT on cds for each sample
####################################################################################

[ ! -d $Data/7_Total_Uniq_Gene ] && mkdir $Data/7_Total_Uniq_Gene
for m in $(ls $Data/6_Unique_Gene/*.cds.fa)
do
	cp $m $Data/7_Total_Uniq_Gene/$(basename $m)
	indi=$(basename ${m%.uniq.cds.fa});
	`perl -pi -e "s/>/>$indi\_/g" $Data/7_Total_Uniq_Gene/$(basename $m)`
	less $Data/7_Total_Uniq_Gene/$(basename $m) >> $Data/7_Total_Uniq_Gene/Total.cds.fa
done


for m in $(ls $Data/6_Unique_Gene/*.pep.fa)
do
        cp $m $Data/7_Total_Uniq_Gene/$(basename $m)
        indi=$(basename ${m%.uniq.pep.fa});
        `perl -pi -e "s/>/>$indi\_/g" $Data/7_Total_Uniq_Gene/$(basename $m)`
        less $Data/7_Total_Uniq_Gene/$(basename $m) >> $Data/7_Total_Uniq_Gene/Total.pep.fa
done


