use strict; use warnings;
my($file,$n,$step,@ph)=@ARGV; @ph=(1000,2000,3000,4000,5000,6000,7000,0) unless @ph;
open my $fh,'>',$file or die $!;
print $fh ";redcode-94\n;name test lattice $n\n;assert CORESIZE == 8000\nstep equ $step\nstart ";
for my $i (1..$n-1){ print $fh ($i==1?"  spl b1\n":"        spl b$i\n"); }
print $fh "        jmp b0\n";
for my $i (0..$n-1){ my $bomb=($i%2)?'db':'sb'; my $p=$ph[$i%@ph]; print $fh "b$i      mov.i $bomb, $p\n        add.ab #step, b$i\n        jmp b$i\n"; }
print $fh "sb spl #0,#0\ndb dat.f #0,#0\nend start\n";
