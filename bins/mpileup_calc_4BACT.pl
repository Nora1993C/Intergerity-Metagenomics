#!/usr/bin/env perl
######################################################################################################
#### This script is used calculate the coverage and counts of pileup reads. ##########################
#### Usage: *.pl ref_Length.txt pileup_files.txt #####################################################
#### The ref_Length.txt is a refID to length file, typically see the one in HMP ref genomes. #########
#### The second is the list of individual pileup files. ##############################################
#### Calculate the individual coverage by positions, and sequence depths by reads, as well as the#####
#####corresponding counts. (i.e., for individual, position counts; for sequence, reads counts across##
#####samples (second column in the output). ##########################################################
#####2014.09.23#######################################################################################

use File::Basename;
die("Argument: ref_Length.txt pileup_files.txt\n") if (@ARGV != 2);
my $ref_len = shift @ARGV;
my $pileup_files = shift @ARGV;

my($fn,$dir,$suffix) = fileparse($pileup_files, ".txt");

my @inds;
my %ref_len;
my @refids;
my %ref_read_count;
my %ind_coverage;
my %ind_count;
my @ref_coverage;
my @ref_count;

open REF,"<$ref_len";
#my $header = <REF>;
#die("Check the header of $ref_len\n") if ($header !~ /^Seq\.ID/);
while($line=<REF>){
	chomp $line;
	my @line = split /\s+/, $line;
	if(! exists $ref_len{$line[0]}){
		$ref_len{$line[0]} = $line[1];
		push @refids, $line[0];
	}else{
		die("Duplicated $line[0]!\n");
	}
}
close REF;

open FILES,"<$pileup_files";
while($file = <FILES>){
	chomp $file;
	my($ind,$idir,$suffix) = fileparse($file, ".sort.pileup");
	push @inds, $ind;
	my %ref_pos_count;
	open PILEUP,"<$file";
	while($line = <PILEUP>){
		chomp $line;
		next if($line !~ /^BACT_/);
		my @line = split /\s+/, $line;
		$line[0] = (split /\|/, $line[0])[0];
		if(exists $ref_len{$line[0]}){
			if(exists $ref_pos_count{$line[0]}){
				if($line[1]<=$ref_len{$line[0]}){
					$ref_pos_count{$line[0]}++;
				}else{
					die("Check $line in $file!\n") if($line[2] ne 'N');
				}
			}else{
				$ref_pos_count{$line[0]} = 1;
			}
			if(exists $ref_read_count{$line[0]}){
				if($line[1]<=$ref_len{$line[0]}){
					$ref_read_count{$line[0]} += $line[3];
				}else{
					die("Check $line in $file!\n") if($line[2] ne 'N');
				}
			}else{
				$ref_read_count{$line[0]} = $line[3];
			}
		}else{
#			die("$line[0] is not in $ref_len\n");
			#print "$line[0] is not in $ref_len\n";
		}
	}
	close PILEUP;
	foreach $ref (@refids){
		if(exists $ind_coverage{$ref}){
			if(exists $ref_pos_count{$ref}){
				$ind_coverage{$ref} .= (sprintf "\t%.5f", $ref_pos_count{$ref}/$ref_len{$ref});
				$ind_count{$ref} .= "\t$ref_pos_count{$ref}";
			}else{
				$ind_coverage{$ref} .= "\t0.00000";
				$ind_count{$ref} .= "\t0";
			}
		}else{
			if(exists $ref_pos_count{$ref}){
				$ind_coverage{$ref} = (sprintf "%.5f", $ref_pos_count{$ref}/$ref_len{$ref});
				$ind_count{$ref} = "$ref_pos_count{$ref}";
			}else{
				$ind_coverage{$ref} = "0.00000";
				$ind_count{$ref} = "0";
			}
		}
	}
}
close FILES;

foreach $ref (@refids){
	push @ref_coverage, $ref;
	push @ref_count, $ref;
	if(exists $ref_read_count{$ref}){
		$ref_coverage[-1] .= (sprintf "\t%.5f", $ref_read_count{$ref}/$ref_len{$ref});
		$ref_count[-1] .= "\t$ref_read_count{$ref}";
	}else{
		$ref_coverage[-1] .= "\t0.00000";
		$ref_count[-1] .= "\t0";
	}
	if(exists $ind_coverage{$ref}){
		$ref_coverage[-1] .= "\t$ind_coverage{$ref}\n";
		$ref_count[-1] .= "\t$ind_count{$ref}\n";
	}else{
		die("Impossible!\n");
	}
}

$header_cov = join "\t", ("Seq.ID","Seq.Depth",@inds);
$header_cnt = join "\t", ("Seq.ID","Seq.Count",@inds);
my $pileup_calc_cov = $dir . $fn . ".Coverage.txt";
my $pileup_calc_cnt = $dir . $fn . ".Count.txt";
open COV,">$pileup_calc_cov";
select COV;
print "$header_cov\n";
print @ref_coverage;
close COV;
open CNT,">$pileup_calc_cnt";
select CNT;
print "$header_cnt\n";
print @ref_count;
close CNT;
select STDOUT;
print "OK! Finish the mpileup calculating!\n";

