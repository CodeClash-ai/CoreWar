use strict;
use warnings;

my $file = '/logs/rounds/0/sim_0.jsonl';
open(my $fh, '<', $file) or die "Cannot open $file: $!";
my $first_line = <$fh>;
my $second_line = <$fh>;
close($fh);

print "Line 2: $second_line\n";
