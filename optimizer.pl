#!/usr/bin/perl
use strict;
use warnings;

sub make_warrior {
    my ($s1, $s2) = @_;
    my $text = ";redcode-94\n"
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
    return $text;
}

sub evaluate {
    my ($s1, $s2, $opponent) = @_;
    $opponent //= "doc/examples/dwarf.red";
    
    open my $fh, '>', 'temp_opt.red' or die $!;
    print $fh make_warrior($s1, $s2);
    close $fh;
    
    my $cmd = "./src/pmars -r 1000 -s 8000 -c 80000 -p 8000 -l 100 -d 100 temp_opt.red $opponent 2>/dev/null";
    my $output = `$cmd`;
    
    if ($output =~ /Results:\s+(\d+)\s+(\d+)\s+(\d+)/) {
        return ($1, $2, $3);
    }
    return (0, 0, 0);
}

my $best_score = 0;
my $best_s1 = 1761;
my $best_s2 = 2407;

my ($w, $t, $l) = evaluate($best_s1, $best_s2);
$best_score = $w * 3 + $t;
print "Baseline ($best_s1, $best_s2): wins=$w, ties=$t, losses=$l, score=$best_score\n";

for (my $i = 0; $i < 30; $i++) {
    my $s1 = int(rand(3000)) + 1000;
    my $s2 = int(rand(3000)) + 1000;
    
    next if $s1 % 2 == 0 or $s2 % 2 == 0;
    
    my ($w, $t, $l) = evaluate($s1, $s2);
    my $score = $w * 3 + $t;
    if ($score > $best_score) {
        $best_score = $score;
        $best_s1 = $s1;
        $best_s2 = $s2;
        print "New best: ($s1, $s2) with score $best_score (wins=$w, ties=$t, losses=$l)\n";
    }
}

print "Search complete. Best steps: ($best_s1, $best_s2) with score $best_score\n";
