use strict;
use warnings;
use JSON::PP;

for my $sim_num (0..5) {
    my $file = "/logs/rounds/0/sim_$sim_num.jsonl";
    if (-e $file) {
        open(my $fh, '<', $file) or die "Cannot open $file: $!";
        my $meta_line = <$fh>;
        my $data_line = <$fh>;
        close($fh);

        my $meta = decode_json($meta_line);
        my $data = decode_json($data_line);

        my $start_1 = $meta->{starts}->[1]->[0];

        my $c = $data->{c};
        my @w1_rel;
        for my $cell (@$c) {
            if ($cell->[1] == 1) {
                my $rel = ($cell->[0] - $start_1) % 8000;
                if ($rel < 0) { $rel += 8000; }
                push @w1_rel, $rel;
            }
        }
        @w1_rel = sort { $a <=> $b } @w1_rel;
        print "Sim $sim_num count: ", scalar(@w1_rel), " relative: ", join(", ", @w1_rel[0..10]), " ...\n";
    }
}
