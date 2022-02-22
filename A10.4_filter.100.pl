use strict;
use File::Basename;
die("Argument: InFile1 InFile_2\n") if ((@ARGV < 2) or (@ARGV >2));

my $InFile1=$ARGV[0];
my $InFile2=$ARGV[1];

open In,"<",$InFile1;
open Out,">",$InFile2;
while(<In>)
{
        chomp;
	my @temp=split /\s+/;
	if($temp[1] > 99)
	{
		printf Out "%s\n",$_;
	}
}
