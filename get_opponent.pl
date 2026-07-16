use strict;
use warnings;

my $file = '/logs/rounds/0/sim_0.jsonl';
open(my $fh, '<', $file) or die "Cannot open $file: $!";
my $first_line = <$fh>;
my $second_line = <$fh>;
close($fh);

if ($second_line =~ /"c":\[(.*?)\]/) {
    my $cells_str = $1;
    my @pairs = split(/\],\[/, $cells_str);
    # Clean up brackets on first and last elements
    $pairs[0] =~ s/^\[//;
    $pairs[-1] =~ s/\]$//;

    my %warrior_0_locations;
    my %warrior_1_locations;

    for my $pair (@pairs) {
        my ($addr, $owner) = split(/,/, $pair);
        if ($owner == 0) {
            $warrior_0_locations{$addr} = 1;
        } else {
            $warrior_1_locations{$addr} = 1;
        }
    }

    print "Warrior 0 addresses: ", join(", ", sort { $a <=> $b } keys %warrior_0_locations), "\n";
}
