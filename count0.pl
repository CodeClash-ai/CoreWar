use strict; my %cnt;
for my $file (@ARGV){open F,$file; <F>; my $line=<F>; while($line =~ /\[(\d+),0\]/g){$cnt{$1}++}}
for my $k (sort{$cnt{$b}<=>$cnt{$a}||$a<=>$b} keys %cnt){print "$k $cnt{$k}\n" if $cnt{$k}>20}
