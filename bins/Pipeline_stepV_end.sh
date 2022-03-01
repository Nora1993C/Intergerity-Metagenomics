####################################################################################
# 0. Setting working fold and initial parameters
####################################################################################
Data=/home/Metagenome/Pipeline/Metagenome/CAD
GP1=/usr/local/MetaGenome

####################################################################################
# Do BLAT on uniq.cds for each sample
####################################################################################

[ ! -d $Data/7_Total_Uniq_Gene ] && mkdir $Data/7_Total_Uniq_Gene

less $Data/7_Total_Uniq_Gene/*.uniq.cds.psl >> $Data/7_Total_Uniq_Gene/Total.cds.psl

for n in $(ls $Data/7_Total_Uniq_Gene/Total*.cds.fa)
do
	$GP1/Script/nonRedundantSeq_Gamma.pl ${n%.fa}.psl
	$GP1/Script/seqid2seq_Gamma.pl ${n%.fa}.nonRedundantRepresentid.txt $n dna
	sed -e '1d' ${n%.fa}.nonRedundantRepresentid.length.txt |cut -f1 > ${n%.fa}.tmpID.txt
	mv ${n%.fa}.nonRedundantRepresentid.fa $Data/7_Total_Uniq_Gene/$(basename $n .cds.fa).uniq.cds.fa
	mv ${n%.fa}.nonRedundantRepresentid.length.txt $Data/7_Total_Uniq_Gene/$(basename $n .cds.fa).uniq.cds.length.txt
	rm ${n%.fa}.nonRedundantRepresentid.txt
	$GP1/Script/seqid2seq_Beta.pl ${n%.fa}.tmpID.txt ${n%.cds.fa}.pep.fa
	mv ${n%.fa}.tmpID.fa $Data/7_Total_Uniq_Gene/$(basename $n .cds.fa).uniq.pep.fa
	rm ${n%.fa}.tmpID.txt ${n%.fa}.tmpID.length.txt
done

