use strict;
use File::Basename;
die("Argument: InFile1 InFile_2 Outdir\n") if ((@ARGV < 3) or (@ARGV >3));

my $InFile1=$ARGV[0];
my $InFile2=$ARGV[1];
my $OutFile=$ARGV[2];
#my $InFile1='CA-grouping.info';
#my $InFile2='../11_MLG/CA.MLG.hcluster';
#my $OutFile='../11_MLG/CA.MLG.abundance.txt';

open ID_ref,"<",$InFile1;
my %Indi;
my @id;
while(<ID_ref>)
{
	chomp;
	if(!/^SampleID/)
	{
		my@temp=split /\t/;
		$Indi{$temp[0]}=1;
		@id=(@id,$temp[0]);
	}
}
close ID_ref;
my %Abundance;
my @files=glob("../9_Relative_Abun/*.clean.aln.relativeGeneAbundance.txt");
for my $file(@files)
{
	open In1,"<",$file;
	$file=~/(\S+).clean.aln.relativeGeneAbundance.txt/;
	my @temp=split /\//,$1;
	my $SamID=$temp[2];
	while(<In1>)
	{
		chomp;
		#if(!/^gene.id/)
		#{
			my @temp1=split /\s+/;
			my @temp2=split /\_/,$temp1[0];
			$Abundance{$SamID}{$temp2[2]}=$temp1[1];
		#}
	}
	close In1;
}
open In,"<",$InFile2;
open Out,">",$OutFile;
printf Out "ID\t";
for my $i(sort keys %Indi)
{
        printf Out "%s\t",$i;
}
printf Out "\n";

while(<In>)
{
	chomp;
	my %Data;	
	my @temp1=split /\t/;
	printf Out "%s\t",$temp1[0];
	my @temp2=split /\,/,$temp1[2];
	for my $i(0..$#temp2)
	{
		my @temp3=split /\_/,$temp2[$i];			
		$Data{$temp3[0]}=$Data{$temp3[0]}+$Abundance{$temp3[0]}{$temp3[3]};
	}
	for my $j(@id)
       	{
        	if(exists $Data{$j})
                {
             	printf Out "%.8f\t",$Data{$j};
            }else{
             	printf Out "%.8f\t",0;
		}
        }
       	printf Out "\n";
}

