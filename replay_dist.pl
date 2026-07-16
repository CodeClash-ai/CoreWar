use JSON::PP; my $j=JSON::PP->new;
my @d; for my $f (glob('/logs/rounds/2/sim_*.jsonl')){open F,$f; my $m=$j->decode(<F>); push @d,$m->{starts}[1][0]; close F}
for my $cand (@ARGV){ my ($w,$l,$t)=(0,0,0); for my $d (@d){ my $out=`./src/pmars -@ config/94nop.opt -b -F $d $cand warrior.red 2>/dev/null | tail -1`; if($out=~/Results:\s+(\d+)\s+(\d+)\s+(\d+)/){$w+=$1;$l+=$2;$t+=$3} } print "$cand vs warrior at round2 distances: $w $l $t score ".($w*3+$t)."-".($l*3+$t)."\n" }
