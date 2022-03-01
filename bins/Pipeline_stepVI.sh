cd /home/Metagenome/Pipeline/Metagenome/CAD/7_Total_Uniq_Gene;
for i in $(ls *.pep.fa)
do
	/usr/local/blast-plus/blastp -db /home/Metagenome/Ref_database/NR-BLAST/nr -query $i -out $i.nr.txt -evalue 1e-5 -outfmt 7 -max_target_seqs 100 -num_threads 160
done
