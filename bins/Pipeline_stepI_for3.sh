####################################################################################
# 0. Setting working fold and initial parameters
####################################################################################
Data=/home/Metagenome/Pipeline/Metagenome/CAD
BWA=/usr/local/bwa-0.7.12
Picard=/usr/local/picard-tools-2.1.1
Fastx=/usr/local/fastx
HumanGenome=/home/Metagenome/Ref_database/human_g1k_v37_BWT

#1st run : Mapping the raw pair-end seqeuncing reads to Human genome

####################################################################################
# 1.1. Do the mapping with the BWA
####################################################################################
# Human Reference Genome from 1000 Genomes Project : {$GP}/Ref_Genomes/human_g1k_v37_BWT/

##for n in $(ls $Data/1_Raw_reads/*R1.fastq);do $BWA/bwa mem -t 90 $HumanGenome/human_g1k_v37 $n ${n%_combined_R1.fastq}_combined_R2.fastq > ${n%_combined_R1.fastq}.humRef.aln.pe.sam ;done
##for n in $(ls $Data/1_Raw_reads/*R1.fastq);do $BWA/bwa mem -t 90 $HumanGenome/human_g1k_v37 ${n%_combined_R1.fastq}.fastq > ${n%_combined_R1.fastq}.humRef.aln.se.sam ;done

####################################################################################
# 1.2. Extract mapped and unmapped reads with Samtools
####################################################################################

##for n in $(ls $Data/1_Raw_reads/*.humRef.aln.*.sam);do $BWA/samtools view -S -F4 $n > ${n%.*}.mapped.sam;done
##for n in $(ls $Data/1_Raw_reads/*.humRef.aln.*.sam);do $BWA/samtools view -S -f4 $n > ${n%.*}.unmapped.sam;done

####################################################################################
# 1.3. Convert unmapped reads to FASTQ format with PIPTSHskinRD
####################################################################################

##for n in $(ls $Data/1_Raw_reads/*.pe.unmapped.sam);do java -jar $Picard/picard.jar SamToFastq INPUT=$n FASTQ=${n%.*.*}.unmapped.1.fq SECOND_END_FASTQ=${n%.*.*}.unmapped.2.fq;done
##for n in $(ls $Data/1_Raw_reads/*.se.unmapped.sam);do java -jar $Picard/picard.jar SamToFastq INPUT=$n FASTQ=${n%.*.*}.unmapped.se.fq ;done

####################################################################################
# 1.4. Remove low quality reads with Fastx toolkits
####################################################################################
##for n in $(ls $Data/1_Raw_reads/*.humRef.aln.pe.unmapped.1.fq);do $Fastx/fastq_quality_filter -Q33  -q 20 -p 80 -i $n -o $Data/2_High_quality_reads/$(basename $n .humRef.aln.pe.unmapped.1.fq).clean.1.fq;done
##for n in $(ls $Data/1_Raw_reads/*.humRef.aln.pe.unmapped.2.fq);do $Fastx/fastq_quality_filter -Q33  -q 20 -p 80 -i $n -o $Data/2_High_quality_reads/$(basename $n .humRef.aln.pe.unmapped.2.fq).clean.2.fq;done
##for n in $(ls $Data/1_Raw_reads/*.humRef.aln.se.unmapped.se.fq);do $Fastx/fastq_quality_filter -Q33  -q 20 -p 80 -i $n -o $Data/2_High_quality_reads/$(basename $n .humRef.aln.se.unmapped.se.fq).clean.se.fq;done
####################################################################################
# 2.0. Calculate the quality stats for high quality reads
####################################################################################
for n in $(ls $Data/2_High_quality_reads/*.fq);do $Fastx/fastx_quality_stats -Q33 -i $n -o $n.stat;done
