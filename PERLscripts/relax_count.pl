#######Relax select count###############
#--------------------------------------#
#######make by Kogoori Masaki###########
#--------------------------------------#
#Example Usage: for i in *.fa.filter.relax; do perl relax_count.pl $i >> relax.count ; done#
use warnings;
open $I,"< $ARGV[0]" or die "no inputfile!";
@gene  = <$I>;
@species = ("cahirinus","dimidiatus","russatus","kempi","percivali");
@count = 0;
$name = $ARGV[0];
$name =~ s/\.fa\.filter\.relax//g;
for($j=0;$j<=$#gene;$j++)
{
	for($d=0;$d<=$#species;$d++)
	{
		if($gene[$j] =~  /\"$species[$d]\"\:\{/)
		{
		push @count,"$j";
		}
		if($gene[$j] =~ /p-value/)
		{
			$pvalue = $gene[$j];
		}
	}
}
for($f=1;$f<=$#count;$f++)
{
	my $a = $count[$f]+7;
	my $e = $gene[$count[$f]];
	$e =~ s/\n//g;
	$e =~ s/\:\{//g;
	$e =~ s/\"//g;
	print $name."\t";
	print $e;
	$kvalue = $gene[$a];
	$kvalue =~ s/\:/\t/g;
	$kvalue =~ s/\,//g;
	$kvalue =~ s/\"//g;
	$pvalue =~ s/\"//g;
	$pvalue =~ s/\:/\t/g;
	$pvalue =~ s/\,//g;
	chomp $kvalue;
	print "$kvalue\t"."$pvalue";
}	
close $I;
