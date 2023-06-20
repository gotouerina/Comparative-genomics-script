#!/usr/bin/perl -w
use warnings;
use strict;
use File::Basename;
use WGSP::Base;
use WGSP::Maf;

my $cofi = shift or die 'Usage：align [cofigure_file]';

WGSP::Base::checkfile("$cofi");

my @genome = WGSP::Base::readcofi("$cofi") or die "Usage : align [cofigure_file]";

WGSP::Base::checkfile("$genome[0]");

system("lastdb -P8 -uMAM8 myDB $genome[0]");

my @suffixlist = qw(.fa .fasta .fna);

for (my $i = 1; $i < @genome;$i++)
{	
	WGSP::Base::checkfile("$genome[$i]");

	my ($name, $path, $suffix)=fileparse($genome[$i], @suffixlist);

	system("last-train -P40 --revsym -E0.05 -C2 myDB $genome[$i]>$name.train");
	system("lastal -k32 -p $name.train myDB $genome[$i] | last-split -fMAF+ >$name.maf");
	system("maf-swap $name.maf |last-split |maf-swap |maf-sort > $name.filter.maf");

	WGSP::Maf::rename("$name.filter.maf","$name.rename.maf","$genome[0]","$genome[$i]");
}

