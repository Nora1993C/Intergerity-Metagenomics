####################################################################################
# 0. Setting working fold and initial parameters
####################################################################################
Data=/home/Metagenome/Pipeline/Metagenome/PspeMice

[ ! -d $Data/10_Genetic ] && mkdir $Data/10_Genetic
Bowtie=/usr/local/bowtie2-2.2.9
Samtools=/usr/local/samtools/bin
Ref=/project/Ref_database/HMP/ref_Bowtie

####################################################################################
# Do Bowtie on reference genomes for each sample
####################################################################################


for n in $(ls $Data/2_High_quality_reads/*.1.paired.fq.gz);
do 
        $Bowtie/bowtie2 -x $Ref/HMP -1 ${n%.*.*.*.*}.1.paired.fq.gz -2 ${n%.*.*.*.*}.2.paired.fq.gz -S $Data/10_Genetic/$(basename $n .clean.1.paired.fq.gz).hmp.pe.bowtie.sam -p 80;
        $Bowtie/bowtie2 -x $Ref/HMP -U ${n%.*.*.*.*}.single.fq.gz -S $Data/10_Genetic/$(basename $n .clean.1.paired.fq.gz).hmp.se.bowtie.sam -p 80;
done

for n in $(ls $Data/10_Genetic/*.bowtie.sam)
do
	$Samtools/samtools view -S -F4 $n > ${n%.*}.mapped.sam;
done
rm $Data/10_Genetic/*.bowtie.sam;

for n in $(ls $Data/10_Genetic/*.mapped.sam)
do
	less $n >> ${n%.*.*.*.*.*}.hmp.bowtie.merged.sam;
done
rm $Data/10_Genetic/*.mapped.sam;

for n in $(ls $Data/10_Genetic/*.merged.sam)
do
	 $Samtools/samtools view -bT /project/Ref_database/HMP/ref_Bowtie/ref_genomes.fa $n > ${n%.*.*}.bam;
	$Samtools/samtools sort ${n%.*.*}.bam -o ${n%.*.*}.sort.bam;
	$Samtools/samtools index ${n%.*.*}.sort.bam;
done
rm $Data/10_Genetic/*merged.sam
rm $Data/10_Genetic/*.bowtie.bam;

for n in $(ls $Data/10_Genetic/*.sort.bam)
do
	$Samtools/samtools mpileup -f /project/Ref_database/HMP/ref_Bowtie/ref_genomes.fa $n > ${n%.*}.pileup;
done

cd $Data/10_Genetic;
ls *.pileup > pileup_files.txt;
perl mpileup_calc_4BACT.pl BACT_complete.seqLength.txt  pileup_files.txt;
rm $Data/10_Genetic/*.pileup;

PIPTSHskinRD=/usr/local/picard-tools-2.1.1
for n in $(ls $Data/10_Genetic/*.sort.bam)
do
	SampID=$(basename $n .hmp.bowtie.sort.bam);
	java -jar -Xmx20g $PIPTSHskinRD/picard.jar AddOrReplaceReadGroups I=$n O=${n%.*.*.*.*}.hmp.rg.bam RGID=$SampID RGLB=run1 RGPL=illumina RGSM=$SampID RGPU='run barcode'  VALIDATION_STRINGENCY=SILENT CREATE_INDEX=True;
	$Samtools/samtools index ${n%.*.*.*.*}.hmp.rg.bam;
done
rm $Data/10_Genetic/*.sort.bam;
rm $Data/10_Genetic/*.sort.bam.bai;

ls *.rg.bam | $Samtools/samtools mpileup -d 2000 -P ILLUMINA -f /project/Ref_database/HMP/ref_Bowtie/ref_genomes.fa -EgD -| >test.bcf 	
