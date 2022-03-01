###############################
## set env virable
###############################
Data=/home/Metagenome/Pipeline/Metagenome/CAD
WD=/$Data/9_Relative_Abun
BIN=/usr/local/Scripts

echo "Calculate gene relative abundance and sample diversity"

###########################################################

## Calculation

###########################################################
#For paired and single reads
for n in $(ls $WD/*.clean.se.1.aln.txt)
do
	SamID=$(basename $n .clean.se.1.aln.txt)
	less $n $WD/$SamID.clean.pe.1.aln.txt $WD/$SamID.clean.pe.2.aln.txt > $WD/$SamID.clean.aln.txt
	lengthfile=$Data/6_Unique_Gene/$SamID.uniq.more100.cds.length.txt
	$BIN/CalculateRelativeGeneAbundance_Diversity_Beta.pl $WD/$SamID.clean.aln.txt 1 8 $lengthfile
done

echo "Finish Calculating gene relative abundance and sample diversity"
