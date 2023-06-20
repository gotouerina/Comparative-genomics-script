#!/usr/bin/perl -w
use strict;
use warnings;
use WGSP::Maf;
use WGSP::Base;
use File::Copy;
use File::Basename;

my $cofi = shift or die 'Usage：merge [cofigure_file] [output_maf_name]';
my $output = shift or die "Usage: merge [cofigure_file] [output_maf_file]";

WGSP::Base::checkfile("$cofi");

my @genome = WGSP::Maf::readcofi("$cofi");

WGSP::Base::checkfile("$genome[0]");

WGSP::Base::checkfile("$genome[1]"); 

system("multiz M=1 $genome[0] $genome[1] 0 U1 U2 > 1.maf ");

my $number;

for (my $i=1 ; $i < @genome; $i++)
{
	WGSP::Base::checkfile("$genome[$i]");
	
	$number = $i+1;
	
	system("multiz M=1 $i.maf $genome[$number] 0 U1 U2 > $number.maf ");
}

File::Copy::move $number.maf $output; 
