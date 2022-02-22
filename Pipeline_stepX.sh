####################################################################################
# 0. Setting working fold and initial parameters
####################################################################################
Data=/home/Metagenome/Pipeline/Metagenome/PspeMice

[ ! -d $Data/11_MLG ] && mkdir $Data/11_MLG

####################################################################################
# form reads number matrix between genes and individuals
####################################################################################

perl A10.1_reads.pl $Data/bin/PTSHskin-grouping.info $Data/7_Total_Uniq_Gene/Total.cds.representid2seqid.txt $Data/11_MLG/PTSHskin.readsCounts.txt 

####################################################################################
# form abundance matrix between genes and individuals
####################################################################################

perl A10.1_abundance.pl $Data/bin/PTSHskin-grouping.info $Data/7_Total_Uniq_Gene/Total.cds.representid2seqid.txt $Data/11_MLG/PTSHskin.gene.abundance.txt 

####################################################################################
# remove less than 10 samples
####################################################################################

perl A10.2_remove.less.than.10.pl $Data/11_MLG/PTSHskin.readsCounts.txt $Data/11_MLG/PTSHskin.more.than.10.txt

####################################################################################
# calculate pcc & hclust
####################################################################################

./correlation -t $Data/11_MLG/PTSHskin.more.than.10.txt  -c 0.7 -o $Data/11_MLG/PTSHskin.more.than.10.cor -p 80

./cluster -w 0.7 -s 0.99 -m 99999999 -p 80 -o $Data/11_MLG/PTSHskin.more.than.10.hcluster $Data/11_MLG/PTSHskin.more.than.10.cor

####################################################################################
# choose more than 100 cluster in MLG
####################################################################################

perl A10.4_filter.100.pl $Data/11_MLG/PTSHskin.more.than.10.hcluster $Data/11_MLG/PTSHskin.MLG.hcluster

####################################################################################
# calculate the MLG abindance
####################################################################################

perl A10.5_abundance.pl $Data/bin/PTSHskin-grouping.info $Data/11_MLG/PTSHskin.MLG.hcluster $Data/11_MLG/PTSHskin.MLG.abundance.txt
