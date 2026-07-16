#!/usr/bin/env perl
use strict; use warnings; use JSON::PP;
my %pos; my %won; my $n=0;
for my $fn (sort glob "/logs/rounds/0/sim_*.jsonl"){
 open my $fh,"<",$fn or next; my $h=decode_json(<$fh>); my $opp=$h->{starts}[1][0]; my $len=$h->{starts}[1][1];
 my %seen; my $last;
 while(<$fh>){ if(/"winner"/){$last=decode_json($_); last} my $j=decode_json($_); for my $c (@{$j->{c}||[]}){ next unless $c->[1]==1; my $rel=($c->[0]-$opp)%8000; $rel+=8000 if $rel<0; $seen{$rel}=1; }}
 $n++; my $w=$last->{winner}//'draw'; my $good=($w eq 'gpt-5-5');
 for my $r (sort {$a<=>$b} keys %seen){$pos{$r}++; $won{$r}+=$good}
}
print "n=$n\n"; for my $r (sort {$pos{$b}<=>$pos{$a} || $a<=>$b} keys %pos){ printf "%4d count=%3d wins=%2d\n",$r,$pos{$r},$won{$r}; last if $.>100 }
