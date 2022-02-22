####################################################################################
# 0. Setting working fold and initial parameters
####################################################################################
Data=/home/Metagenome/Pipeline/Metagenome/CAD
GP1=/usr/local/MetaGenome

####################################################################################
# Do BLAT on cds for each sample
####################################################################################

[ ! -d $Data/6_Unique_Gene ] && mkdir $Data/6_Unique_Gene

for n in $(ls $Data/5_PTSHskinS_PEP/*.scanftig_500.cds.fa)
do
	blat $n $n -noHead ${n%.fa}.psl 
	$GP1/Script/nonRedundantSeq_Gamma.pl ${n%.fa}.psl
	$GP1/Script/seqid2seq_Gamma.pl ${n%.fa}.nonRedundantRepresentid.txt $n dna
	sed -e '1d' ${n%.fa}.nonRedundantRepresentid.length.txt |cut -f1 > ${n%.fa}.tmpID.txt
	mv ${n%.fa}.nonRedundantRepresentid.fa $Data/6_Unique_Gene/$(basename $n .scanftig_500.cds.fa).uniq.cds.fa
	mv ${n%.fa}.nonRedundantRepresentid.length.txt $Data/6_Unique_Gene/$(basename $n .scanftig_500.cds.fa).uniq.more100.cds.length.txt
	mv ${n%.fa}.seqid2representid.txt $Data/6_Unique_Gene/
	mv ${n%.fa}.representid2seqid.txt $Data/6_Unique_Gene/
	mv ${n%.fa}.psl $Data/6_Unique_Gene/
	rm ${n%.fa}.nonRedundantRepresentid.txt
	$GP1/Script/seqid2seq_Beta.pl ${n%.fa}.tmpID.txt ${n%.cds.fa}.pep.fa
	mv ${n%.fa}.tmpID.fa $Data/6_Unique_Gene/$(basename $n .scanftig_500.cds.fa).uniq.pep.fa
	rm ${n%.fa}.tmpID.txt ${n%.fa}.tmpID.length.txt
done

