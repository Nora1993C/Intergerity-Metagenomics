use strict;
srand;
open Ref,"<","CA-grouping.info";
my @id;
while(<Ref>)
{
        chomp;
        if(!/^SampleID/)
        {
            my @temp = split /\t/;
		@id = (@id, $temp[0]);
        }
}
close Ref;
open ID_ref,"<","CA-sample.info";
my %Indi;
while(<ID_ref>)
{
	chomp;
	if(!/^SampleID/)
	{
		my @temp = split /\t/;
		$Indi{$temp[1]}{$temp[0]} = 1;	
	}
}
close ID_ref;

open In,"<","../11_MLG/CA.readsCounts.txt";
#open In,"<","../tt.txt";
my %Data;
while(<In>)
{
	chomp;
        if(!/^ID/)
        {
		my @temp = split /\t/;
                for my $i(1..$#temp)
                {
			if($temp[$i]>1)
                        {
				$Data{$id[$i-1]}{$temp[0]} = 1;
			}
		}
	}
}
close In;

	my $i = (sort keys %Indi)[0];	
	open Out,">",'../11_MLG/'.$i.".CA.sample.txt";
	my $length = keys $Indi{$i};
	my @ID = sort keys $Indi{$i};
	for my $a(1..$length)
	{
		for my $b(1..100)
		{
			my %hash;
			while ((keys %hash) < $a)
			{
				$hash{int(rand($length))} = 1;
			}
			my %gene_ID;
			for my $k(sort keys %hash) 
			{
				if (exists $Data{$ID[$k]})
				{
					for my $j(sort keys $Data{$ID[$k]})
					{
						$gene_ID{$j}=1;
					}
				}
			}
			if(%gene_ID)
			{
				my $l = keys %gene_ID;
				printf Out "%s\t",$l;
			}else{
				printf Out "0\t";
			}
			undef %hash;
			undef %gene_ID;
		}
		printf Out "\n";
	}
	close Out;
