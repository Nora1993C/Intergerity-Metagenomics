#!/usr/bin/env perl
########################################################################################
#### This script is used to generate the pipeline script sample by sample. #############
#### Usage: *.pl script.sh sample.txt ##################################################
#### The script.sh is simply the general pipeline script. ##############################
#### The sample.txt contains one sample name, namely the prefix of each file per line. # 
#####2014.04.23#########################################################################
use File::Basename;
die("Arguments: pipeline_script sample_list\n") if (@ARGV!=2);
my $script_file=shift @ARGV;
my $sample_file=shift @ARGV;
my($filename, $dir, $suffix)=fileparse($script_file, '.sh');
my @sample;
open SAMPLE,"<$sample_file";
while($line = <SAMPLE>){
	chomp $line;
	push @sample, $line;
}
close SAMPLE;
foreach $sample (@sample){
	open SCR,"<$script_file";
	my $script_sample_file = $dir . $filename . "_$sample" . $suffix;
	open OUTPUT,">$script_sample_file";
	while($line = <SCR>){
		if($line =~ /for\s+/){
			$line =~ s/(\(.*?)(\*)(.*\))/${1}${sample}${3}/;
		}
		print OUTPUT $line;
	}
	close SCR;
	close OUTPUT;
}
print "ok!\n";
