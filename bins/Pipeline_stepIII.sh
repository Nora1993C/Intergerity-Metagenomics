#08.Jan.2014
#Processing the Gut metagenome data using same Pipeline

#Initial Steps: setting working fold and initial parameters
####################################################################################
# 0. Setting working fold and initial parameters
####################################################################################
Data=/home/Metagenome/Pipeline/Metagenome/CAD


####################################################################################
# 3.1 Predict ORF of Gene and related protein sequences from contigs
####################################################################################
[ ! -d $Data/5_PTSHskinS_PEP ] && mkdir $Data/5_PTSHskinS_PEP

GeneMark=/usr/local/MetaGeneMark/;

for n in $(ls $Data/4_Contigs/*.fa);
do 
	$GeneMark/gmhmmp -a -d -f G -m $GeneMark/MetaGeneMark_v1.mod -o ${n%.*}.gff $n;
	mv ${n%.*}.gff $Data/5_PTSHskinS_PEP;
done

####################################################################################
# 3.2 Convert to uniqul Predict ORF of Gene and related protein sequences from contigs
####################################################################################
for n in $(ls $Data/5_PTSHskinS_PEP/*.gff);
do
	$GeneMark/aa_from_gff.pl < $n > ${n%.*}.pep.fa;
	$GeneMark/nt_from_gff.pl < $n > ${n%.*}.cds.fa;
done

