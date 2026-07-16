use strict; use warnings; use JSON::PP;
for my $fn (@ARGV){open my $fh,'<',$fn or die $!; my $l1=<$fh>; my $l2=<$fh>; my $h=decode_json($l1); my $r=decode_json($l2); my @own=sort {$a<=>$b} map {$_->[0]} grep {$_->[1]==0} @{$r->{c}}; print "$fn start=".$h->{starts}[0][0].",".$h->{starts}[0][1]." count=".(scalar @own)."\n@own\n";}
