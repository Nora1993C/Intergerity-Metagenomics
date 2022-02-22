###############################
## set env virable
###############################

Data=/home/Metagenome/Pipeline/Metagenome/CAD
Reads=$Data/2_High_quality_reads
[ ! -d $Data/9_Relative_Abun ] && mkdir $Data/9_Relative_Abun
WD=$Data/9_Relative_Abun
#SOAPbin=/usr/local/SOAPaligner

###############################
## index indiv uniq gene
###############################
#cp $Data/6_Unique_Gene/*.cds.fa $Data/9_Relative_Abun
#for n in $Data/9_Relative_Abun/*.uniq.cds.fa;
#do
#	fa=$(basename $n)
#	mkdir ${n%.fa}.index;
#	mv $n ${n%.fa}.index;
#	2bwt-builder ${n%.fa}.index/$fa
#done


###############################
## SOAPalign individual HiQual reads to its unique gene set
###############################
for n in $Reads/*.clean.single.fq;
do
	SamID=$(basename $n .clean.single.fq)
	index=$Data/9_Relative_Abun/${SamID}.uniq.cds.index/${SamID}.uniq.cds.fa.index
#	gunzip -c $Reads/${SamID}.clean.single.fq.gz > ${WD}/${SamID}.clean.single.fq
#	gunzip -c $Reads/${SamID}.clean.1.paired.fq.gz > ${WD}/${SamID}.clean.1.paired.fq
#	gunzip -c $Reads/${SamID}.clean.2.paired.fq.gz > ${WD}/${SamID}.clean.2.paired.fq

	#for single reads
	soap -a $Reads/${SamID}.clean.single.fq -D $index -o ${WD}/${SamID}.clean.se.1.aln.txt -2 ${WD}/${SamID}.clean.se.2.aln.txt -u ${WD}/${SamID}.clean.aln.unmapped.txt -r 2 -m 50 -x 350  -v 5 -p 30

	#for paired reads
	soap -a $Reads/${SamID}.clean.1.paired.fq -b $Reads/${SamID}.clean.2.paired.fq -D $index -o ${WD}/${SamID}.clean.pe.1.aln.txt -2 ${WD}/${SamID}.clean.pe.2.aln.txt -u ${WD}/${SamID}.clean.aln.unmapped.txt -r 2 -m 50 -x 350  -v 5 -p 30

done

