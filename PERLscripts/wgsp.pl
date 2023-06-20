#!/usr/bin/perl -w 

use strict;
use warnings;
use Getopt::Long;
my $align = "";
my $merge = "";
my $lst = "";

GetOptions(
	'align=s' => \$align,
	'merge=s'=> \$merge,
	'lst=s' => \$lst,

)or die "Usage: wgsp [-a][-m] cofigure_file";

if($align eq "" && $merge eq "" && $lst eq "")
{
	die "Usage: wgsp [-a][-m] cofigure_file";
}


if($align ne "")
{
	open A,">$align" or die "the cofigure_file argument is required";
	print A "{alignment}\nreference = example1.fa\nquery1 = example2.fa\nquery2 = example3.fa";
}
if($merge ne "")
{
	open M,">$merge" or die "the cofigure_file argument is required";
	print M "{merge}\nmaf1 = example1.maf\nmaf2 = example2.maf";
}
if($lst ne "")
{
	open L,">$lst" or die "the cofigure_file argument is required";
	print L "{MAF2LST}\nmaf = example.maf\nlst = example.lst\nspecies1 = example1\nspecies2 = example2\nspecies3 = example3\nspecies4 = example4\nspecies5 = example5";
	
}


