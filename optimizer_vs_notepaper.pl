use strict;
use warnings;

sub make_warrior {
    my ($s1, $s2, $s3) = @_;
    my $code = ";redcode-94\n"
             . ";name Silk Warrior 3\n"
             . ";author Silk\n"
             . ";strategy Replicator (Silk)\n"
             . ";assert VERSION >= 80\n\n"
             . "step1   equ $s1\n"
             . "step2   equ $s2\n"
             . "step3   equ $s3\n\n"
             . "init    spl     1,      <3445\n"
             . "        spl     1,      <5005\n"
             . "        spl     1,      <5366\n\n"
             . "silk1   spl     \@0,     step1\n"
             . "        mov.i   }silk1, >silk1\n"
             . "silk2   spl     \@0,     step2\n"
             . "        mov.i   }silk2, >silk2\n"
             . "silk3   spl     \@0,     step3\n"
             . "        mov.i   }silk3, >silk3\n"
             . "        mov.i   bmb,    >1000\n"
             . "        jmp     silk1,  <2000\n"
             . "bmb     dat     #0,     #0\n\n"
             . "end init\n";
    return $code;
}

sub evaluate {
    my ($s1, $s2, $s3) = @_;
    open(my $fh, '>', 'temp_opt.red') or die $!;
    print $fh make_warrior($s1, $s2, $s3);
    close($fh);

    my $cmd = "./src/pmars -r 30 -s 8000 -c 80000 -p 8000 -l 100 -d 100 temp_opt.red notepaper.red";
    my $out = `$cmd`;
    my @lines = split(/\n/, $out);
    if (@lines) {
        my $last_line = $lines[-1];
        if ($last_line =~ /Results:\s+(\d+)\s+(\d+)\s+(\d+)/) {
            return ($1, $2, $3); # wins, losses, ties
        }
    }
    return (0, 0, 0);
}

my @candidates;
for my $i (1000 .. 7000) {
    if ($i % 2 != 0 && $i % 5 != 0) {
        push @candidates, $i;
    }
}

my $best_wins = 0;
my $best_s1 = 5555;
my $best_s2 = 6505;
my $best_s3 = 5743;

# Let's search for a combination of steps that wins more against Notepaper
for my $iter (1 .. 15) {
    my $s1 = $candidates[int(rand(@candidates))];
    my $s2 = $candidates[int(rand(@candidates))];
    my $s3 = $candidates[int(rand(@candidates))];
    my ($w, $l, $t) = evaluate($s1, $s2, $s3);
    if ($w > $best_wins) {
        $best_wins = $w;
        $best_s1 = $s1;
        $best_s2 = $s2;
        $best_s3 = $s3;
        print "New best: ($s1, $s2, $s3) wins=$w, losses=$l, ties=$t\n";
    }
}

print "Best step sizes against Notepaper: ($best_s1, $best_s2, $best_s3) with $best_wins wins.\n";
