#!/usr/bin/env perl
# Summarize saved CoreWar JSONL traces by start distance and winner.
use strict; use warnings; use JSON::PP;
for my $rd (@ARGV ? @ARGV : (0,1)) {
  my @rows; my %cnt;
  for my $fn (sort glob "/logs/rounds/$rd/sim_*.jsonl") {
    open my $fh, '<', $fn or next;
    my @lines = <$fh>; close $fh;
    next unless @lines >= 2;
    my $first = decode_json($lines[0]);
    my $last = decode_json($lines[-1]);
    my $winner = $last->{winner}; $winner = 'DRAW_OR_UNKNOWN' unless defined $winner and length $winner;
    my $dist = ($first->{starts}[1][0] - $first->{starts}[0][0]) % 8000;
    push @rows, [$dist, $winner, $last->{draw} || 0, $fn];
    $cnt{$winner}++;
  }
  print "ROUND $rd n ", scalar(@rows), " ", join(' ', map { "$_=$cnt{$_}" } sort keys %cnt), "\n";
  for (my $b=0; $b<8000; $b+=500) {
    my (%bc,$n); for (@rows) { if ($_->[0] >= $b && $_->[0] < $b+500) { $n++; $bc{$_->[1]}++ } }
    print "$b $n ", join(' ', map { "$_=$bc{$_}" } sort keys %bc), "\n" if $n;
  }
  my @loss = sort {$a<=>$b} map { $_->[0] } grep { $_->[1] ne 'gpt-5-5' } @rows;
  print "non-win start distances: @loss\n";
}
