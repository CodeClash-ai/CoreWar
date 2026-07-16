use JSON::PP;
for my $rd (0,1){
 my (%c,@wins,@loss);
 for my $fn (glob "/logs/rounds/$rd/sim_*.jsonl"){
  open my $fh,'<',$fn; my $first=decode_json(scalar <$fh>); my $last; $last=$_ while <$fh>; close $fh;
  my $o=decode_json($last); my $w=$o->{winner}//($o->{draw}?"draw":"?"); $c{$w}++;
  my $oppidx=($first->{warriors}{0}=~/return/?0:1); my $ouridx=1-$oppidx;
  my $dist=($first->{starts}[$oppidx][0]-$first->{starts}[$ouridx][0])%8000;
  if($w eq 'gpt-5-5'){push @wins,$dist}else{push @loss,$dist}
 }
 print "ROUND $rd "; print join(' ',map{"$_=$c{$_}"}keys%c),"\n wins ",join(',',sort{$a<=>$b}@wins),"\n losses/draw ",join(',',sort{$a<=>$b}@loss),"\n";
}
