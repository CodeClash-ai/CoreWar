use strict;
use warnings;
use JSON::PP;

my $file = '/logs/rounds/0/sim_0.jsonl';
open(my $fh, '<', $file) or die "Cannot open $file: $!";
my $meta_line = <$fh>;
my $data_line = <$fh>;
close($fh);

my $meta = decode_json($meta_line);
my $data = decode_json($data_line);

my $c = $data->{c};
my @w1;
for my $cell (@$c) {
    if ($cell->[1] == 1) {
        push @w1, $cell->[0];
    }
}

@w1 = sort { $a <=> $b } @w1;
print "notepaper (Warrior 1) modified cells at t=0:\n";
print join(", ", @w1), "\n";
print "Count: ", scalar(@w1), "\n";
