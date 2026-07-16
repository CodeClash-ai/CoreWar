use JSON::PP; use strict; use warnings;
my $json=JSON::PP->new;
for my $rd (0..2){
 my @files=glob("/logs/rounds/$rd/sim_*.jsonl"); my (%cnt,%cnt1,@win);
 for my $f (@files){ open my $F,'<',$f or next; my $line=<$F>; next unless defined $line && $line=~/\S/; my $meta=$json->decode($line); my $st=$meta->{starts}[1][0];
  my $first; while(my $l=<$F>){ next unless $l=~/\S/; $first=$json->decode($l); last } close $F; next unless $first && $first->{c};
  for my $c (@{$first->{c}}){ my($a,$o)=@$c; if($o==0){$cnt{$a%8000}++} else {$cnt1{($a-$st+8000)%8000}++}}
  my $tail=`tail -1 $f`; my $last=eval{$json->decode($tail)}; push @win,$st if $last && (($last->{winner}//'') eq 'notepaper');
 }
 print "round $rd files ".scalar(@files)." np top\n"; my @ks=sort {$cnt{$b}<=>$cnt{$a}} keys %cnt; for my $i (0..29){my $k=$ks[$i]; last unless defined $k; print "$k:$cnt{$k} "} print "\nour top\n"; @ks=sort {$cnt1{$b}<=>$cnt1{$a}} keys %cnt1; for my $i (0..15){my $k=$ks[$i]; last unless defined $k; print "$k:$cnt1{$k} "} print "\nnp wins @win n=".scalar(@win)."\n";
}
