use warnings;
open ($I,"<$ARGV[0]");
open ($O,">$ARGV[1]");
while (<$I>)
{
	if(/s(\s+)(\w+?)(\..*?)(\s.*?)/)
	{
	s/$3//g;
	print {$O} $_;
	}
	else
	{
	print {$O} $_;
	}
}
close $I;
close $O;
