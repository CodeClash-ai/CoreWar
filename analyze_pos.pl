use strict; use warnings;
for my $file (@ARGV){
 open my $fh,'<',$file or next;
 my $hdr=<$fh>; $hdr =~ /"starts":\s*\[\s*\[\s*0\s*,\s*98\s*\]\s*,\s*\[\s*(\d+)\s*,/ or do { warn "no hdr $file\n"; next; }; my $start=$1;
 my $last; my $winner='tie'; my $t=0;
 while(<$fh>){
  if(/"winner":"([^"]+)"/){$winner=$1; last}
  $last=$_ if /"c":/;
 }
 next unless $last;
 $last =~ /"t":(\d+)/ and $t=$1;
 my @own; while($last =~ /\[(\d+),1\]/g){ push @own, ($1-$start+8000)%8000; }
 print "FILE $file start $start t $t winner $winner n ".scalar(@own)."\n";
 my @sorted=sort{$a<=>$b}@own;
 print join(' ', @sorted),"\n";
}
