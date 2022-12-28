#######Convertid2name in linux##############
##--------------------------------------####
########make by Kogoori Masaki##############
##--------------------------------------####
##EVMMODEL,geneID2geneName
use strict;
use warnings;
open I,"<$ARGV[0]" or die "NO gfffile!\nUsage perl $0 gff idfile output_namefile";
open I2,"<$ARGV[1]" or die "NO idfile!\nUsage perl $0 gff idfile output_namefile";
open O,">$ARGV[2]";
my %data;
while(<I>)
{
	if(/\tgene\t/)
	{
	my @line = split(/\t/);
	my ($chr,$source,$type,$start,$end,$score,$strand,$phase,$attributes) = @line;
	$attributes =~ m/ID=(.*);Name=(.*);NameSource/;
	my $id = $1;
	my $name = $2;
	$data{$id} = $name;
	}
}
print STDERR "$ARGV[0] loaded..\n";
close I;
while(<I2>)
{
	chomp;
	my $line = $_;
	print O "$data{$line}\n";
}
print STDERR "$ARGV[1] loaded..\n";
close I2;
close O;
&Checkfile($ARGV[2]);

sub Checkfile
{
if (-z "$_[0]")
	{
	print STDERR "the $ARGV[2] is null , please check the script and inputfile";
	}
else
	{
	print STDERR "Done";
	}	
}
