####################################################################################
# 0. Setting working fold and initial parameters
####################################################################################
Data=/home/Metagenome/Pipeline/Metagenome/CAD
GP=/usr/local/Scripts

####################################################################################
# Breakdown the scaffolds (from SOAPdenovo) to get contigs larger than 500bp
####################################################################################

for n in $(ls $Data/3_Assembly/*.scafSeq)
do
	$GP/BreakScanffold_Beta.pl $n	
	# print the estamated coverage to the STDIN
done

[ ! -d $Data/4_Contigs ] && mkdir $Data/4_Contigs/

mv $Data/3_Assembly/*.scanftig_500.fa $Data/4_Contigs/


