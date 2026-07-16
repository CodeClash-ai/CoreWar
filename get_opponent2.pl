use strict;
use warnings;

my $file = '/logs/rounds/0/sim_0.jsonl';
open(my $fh, '<', $file) or die "Cannot open $file: $!";
my $first_line = <$fh>;
my $second_line = <$fh>;
close($fh);

if ($second_line =~ /"c":\[(.*?)\]/) {
    my $cells_str = $1;
    # Let's extract all numbers inside the brackets
    my @cells;
    while ($cells_str =~ /\[(\d+),(\d+)\]/g) {
        push @cells, [$1, $2];
    }

    my %w0;
    my %w1;
    for my $cell (@cells) {
        if ($cell->[1] == 0) {
            $w0{$cell->[0]} = 1;
        } else {
            $w1{$cell->[0]} = 1;
        }
    }

    print "Warrior 0 addresses: ", join(", ", sort { $a <=> $b } keys %w0), "\n";
    print "Warrior 1 addresses: ", join(", ", sort { $a <=> $b } keys %w1), "\n";
}
