use strict;

my @files=glob("Pipeline_stepV_blat_*.sh");
for my $file(@files)
{
	while(1)
	{
		my $job=(split /\s+/,`qstat -u lj|wc -l`)[0];
		if($job < 90)
		{
			last;
		}
		else
		{
			sleep(100);
		}
	}
	`qsub $file`;
}
