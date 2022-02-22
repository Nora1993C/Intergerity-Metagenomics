use strict;

my @files=glob("*.2.fq");
for my $file(@files)
{
	open In,"<",$file;
	open Out,">","./temp/".$file;
	while(<In>)
	{
		chomp;
		if(/^(\@\S+)\s+2\:/)
		{
			printf Out "%s/2\n",$1;
		}
		else
		{
			printf Out "%s\n",$_;
		}
	}
}
