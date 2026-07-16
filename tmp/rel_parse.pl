use JSON::PP;
for my $rd (0,1){
 print "ROUND $rd\n";
 my @f=sort glob "/logs/rounds/$rd/sim_*.jsonl";
 for my $fn (@f[0..2]){
  open my $fh,'<',$fn or die $!;
  my $first=decode_json(scalar <$fh>);
  my $w=$first->{warriors}; my $oppidx=($w->{0}=~/return/?0:1); my $ouridx=1-$oppidx;
  my $sopp=$first->{starts}[$oppidx][0];
  print "$fn oppidx=$oppidx starts ".encode_json($first->{starts})."\n";
  for(1..5){my $line=<$fh>; last unless defined $line; my $o=decode_json($line);
   print " t $o->{t} p_rel_opp ".join(',', map {($_-$sopp)%8000} @{$o->{p}||[]})." n ".encode_json($o->{n})." d ".encode_json($o->{d})."\n  opp writes rel ";
   my @cs=map {[($_->[0]-$sopp)%8000,$_->[1]]} grep {$_->[1]==$oppidx} @{$o->{c}||[]};
   print join(' ', map {"[$_->[0],$_->[1]]"} @cs[0..(@cs<50?$#cs:49)]);
   print "\n  our writes rel opp ";
   my @us=map {[($_->[0]-$sopp)%8000,$_->[1]]} grep {$_->[1]==$ouridx} @{$o->{c}||[]};
   print join(' ', map {"[$_->[0],$_->[1]]"} @us[0..(@us<20?$#us:19)]);
   print "\n";
  }
 }
}
