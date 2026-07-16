use strict;
use warnings;

my $file = '/logs/rounds/0/sim_0.jsonl';
open(my $fh, '<', $file) or die "Cannot open $file: $!";
my $first_line = <$fh>;
my $second_line = <$fh>;
close($fh);

if ($second_line =~ /"c":\[(.*?)\]/) {
    my $c_block = $1;
    my @pairs;
    while ($c_block =~ /\[(\d+),(\d+)\]/g) {
        my $addr = $1;
        my $owner = $2;
        push @pairs, [$addr, $owner];
    }
    
    my %w0;
    my %w1;
    for my $p (@pairs) {
        if ($p->[1] == 0) {
            $w0{$p->[0]} = 1;
        } else {
            $w1{$p->[0]} = 1;
        }
    }
    
    print "Warrior 0 addresses: ", join(", ", sort { $a <=> $b } keys %w0), "\n";
    print "Warrior 1 addresses: ", join(", ", sort { $a <=> $b } keys %w1), "\n";
}
