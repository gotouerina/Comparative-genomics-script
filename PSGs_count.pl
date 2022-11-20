#######@PSGs select count###############
#--------------------------------------#
#######make by Kogoori Masaki###########
#--------------------------------------#
#Example Usage: for i in *.fa.filter.result; do perl PSGs_count.pl $i >> PSGs.count ; done#
use warnings;
open $I,"< $ARGV[0]" or die "no inputfile!";
@gene  = <$I>;
@species = ("Eospalax_rufescens","Eospalax_smithi","Mus_musculus","Eospalax_cansus","Eospalax_rothschildi","Eospalax_baileyi");
@count = 0;
$name = $ARGV[0];
$name =~ s/\.fa\.filter\.result//g;
for($j=0;$j<=$#gene;$j++)
{
	for($d=0;$d<=$#species;$d++)
	{
		if($gene[$j] =~  /\"$species[$d]\"\:\{/)
		{
		push @count,"$j";
		}
	}
}
for($f=1;$f<=$#count;$f++)
{
	my $a = $count[$f]+2;
	my $z = $count[$f]+3;
	my $e = $gene[$count[$f]];
	$e =~ s/\n//g;
	$e =~ s/\:\{//g;
	$e =~ s/\"//g;
	$pvalue = $gene[$z];
	chomp $pvalue;
        $pvalue =~ s/\,//g;
	$pvalue =~ s/\:/\t/g;
	$pvalue =~ s/\"//g;	
	$omegavalue = $gene[$a];
	$omegavalue =~ s/\:/\t/g;
	$omegavalue =~ s/\,//g;
	$omegavalue =~ s/\"//g;
	chomp $omegavalue;
	print $name."\t";
	print $e;
	print $omegavalue."\t";
	print $pvalue."\n";
}	
close $I;
