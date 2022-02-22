Data=/home/Metagenome/Pipeline/Metagenome/PspeMice

[ ! -d $Data/12_mOTU ] && mkdir $Data/12_mOTU

cp $Data/2_High_quality_reads/*paired.fq.gz $Data/12_mOTU

cd $Data/12_mOTU
for i in $Data/12_mOTU/*.1.paired.fq.gz
do 
	gz=$(basename $i)	
	mkdir ${gz%.*.*.*.*.*}
	mv $i ${gz%.*.*.*.*.*}/${gz%.*.*.*.*.*}.1.fq.gz
	mv ${gz%.*.*.*.*.*}.clean.2.paired.fq.gz  ${gz%.*.*.*.*.*}/${gz%.*.*.*.*.*}.2.fq.gz
done

cp $Data/bin/Samples.txt $Data/12_mOTU
cp $Data/bin/mOTUs.pl $Data/12_mOTU

#perl mOTUs.pl --sample-file Samples.txt
