use strict;
use warnings;

my $file = '/logs/rounds/0/sim_0.jsonl';
open(my $fh, '<', $file) or die "Cannot open $file: $!";
my $first_line = <$fh>;
my $second_line = <$fh>;
close($fh);

if ($second_line =~ /"c":\[(.*?)\]\s*,\s*"p"/) {
    my $c_block = $1;
    # print "c_block: $c_block\n";
    # We can split on ],[ or simply match pairs of numbers
    my @pairs = ($c_block =~ /(\d+),(\d+)/g);
    my %w0;
    my %w1;
    for (my $i = 0; $i < @pairs; $i += 2) {
        my $addr = $pairs[$i];
        my $owner = $pairs[$i+1];
        if ($owner == 0) {
            $w0{$addr} = 1;
        } else {
            $w1{$addr} = 1;
        }
    }
    print "Warrior 0 addresses: ", join(", ", sort { $a <=> $b } keys %w0), "\n";
    print "Warrior 1 addresses: ", join(", ", sort { $a <=> $b } keys %w1), "\n";
}
