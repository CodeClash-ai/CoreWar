#!/usr/bin/env perl
use strict; use warnings; use JSON::PP;
my $file = shift || '/logs/rounds/0/sim_0.jsonl';
open my $fh, '<', $file or die "$file: $!\n";
my $hdr = decode_json(<$fh>);
my ($our_start,$our_len) = @{$hdr->{starts}[0]};
my ($opp_start,$opp_len) = @{$hdr->{starts}[1]};
my %seen; my @opp;
while(<$fh>) {
  last if /"winner"/;
  my $j = decode_json($_);
  for my $cell (@{$j->{c}||[]}) {
    my ($addr,$owner)=@$cell;
    next unless $owner == 1;
    # original opponent-owned locations outside load range are its bomb trail
    my $rel = (($addr - $opp_start) % 8000 + 8000) % 8000;
    next if $rel >= 0 && $rel < $opp_len;
    push @opp, $addr unless $seen{$addr}++;
  }
  last if @opp > 20;
}
print "opponent starts at $opp_start length $opp_len\n";
print "first opponent bomb addresses: @opp\n";
if (@opp >= 3) {
  my @steps; for my $i (1..$#opp) { push @steps, (($opp[$i]-$opp[$i-1]) % 8000); }
  print "deltas mod 8000: @steps\n";
  my $d = $steps[0]; $d -= 8000 if $d > 4000;
  print "likely Dwarf-like bombing step: $d\n";
}
