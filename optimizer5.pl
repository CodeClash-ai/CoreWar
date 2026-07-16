use strict;
use warnings;

sub make_warrior {
    my ($s1, $s2) = @_;
    my $code = ";redcode-94\n"
             . ";name Silk Warrior 3\n"
             . ";author Silk\n"
             . ";strategy Replicator (Silk)\n"
             . ";assert VERSION >= 80\n\n"
             . "step1   equ $s1\n"
             . "step2   equ $s2\n\n"
             . "init    spl     1,      <3000\n"
             . "        spl     1,      <4000\n"
             . "        spl     1,      <5000\n\n"
             . "silk1   spl     \@0,     step1\n"
             . "        mov.i   }silk1, >silk1\n"
             . "silk2   spl     \@0,     step2\n"
             . "        mov.i   }silk2, >silk2\n"
             . "        mov.i   bmb,    >1000\n"
             . "        jmp     silk1,  <2000\n"
             . "bmb     dat     #0,     #0\n\n"
             . "end init\n";
    return $code;
}

sub evaluate {
    my ($s1, $s2) = @_;
    open(my $fh, '>', 'temp_opt.red') or die $!;
    print $fh make_warrior($s1, $s2);
    close($fh);

    my $cmd = "./src/pmars -r 500 -s 8000 -c 80000 -p 8000 -l 100 -d 100 temp_opt.red doc/examples/validate.red";
    my $out = `$cmd`;
    my @lines = split(/\n/, $out);
    if (@lines) {
        my $last_line = $lines[-1];
        if ($last_line =~ /Results:\s+(\d+)\s+(\d+)\s+(\d+)/) {
            return ($1, $2);
        }
    }
    return (0, 0);
}

my @candidates;
for my $i (1000 .. 4000) {
    if ($i % 2 != 0 && $i % 5 != 0) {
        push @candidates, $i;
    }
}

my $best_score = 0;
my $best_s1 = 1761;
my $best_s2 = 2407;

my ($w, $t) = evaluate($best_s1, $best_s2);
$best_score = $w * 3 + $t;
print "Baseline ($best_s1, $best_s2): wins=$w, ties=$t, score=$best_score\n";

for my $iter (1 .. 50) {
    my $s1 = $candidates[int(rand(@candidates))];
    my $s2 = $candidates[int(rand(@candidates))];
    my ($w, $t) = evaluate($s1, $s2);
    my $score = $w * 3 + $t;
    if ($score > $best_score) {
        $best_score = $score;
        $best_s1 = $s1;
        $best_s2 = $s2;
        print "New best: ($s1, $s2) with score $best_score (wins=$w, ties=$t)\n";
    }
}

print "Final selected steps: ($best_s1, $best_s2)\n";
open(my $fh, '>', 'warrior.red') or die $!;
print $fh make_warrior($best_s1, $best_s2);
close($fh);
