use strict;
use File::Basename;
die("Argument: InFile1 InFile_2\n") if ((@ARGV < 2) or (@ARGV >2));

my $InFile1=$ARGV[0];
my $InFile2=$ARGV[1];

my $count;
open In,"<",$InFile1;
open Out,">",$InFile2;
while(<In>)
{
	chomp;
	if(/^ID/)
	{
		printf Out "%s\n", $_;
	}else{
		my @temp=split /\t/;
		$count=0;
		for (my $i=1;$i<@temp;$i++)
		{
			if($temp[$i] != 0)
			{	
				$count=$count+1;
			}
		}
        	if($count>9)
        	{
            		printf  Out "%s\n", $_;
        	}
	}
}

