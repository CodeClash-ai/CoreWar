use strict; use warnings;
my($file,$n,@ph)=@ARGV; @ph=(1000,2000,3000,4000,5000,6000,7000,0,500,1500,2500,3500) unless @ph;
open my $fh,'>',$file or die $!;
print $fh ";redcode-94\n;name hyb$n\n;assert CORESIZE == 8000\nstep equ 1031\nstart";
for my $i (1..$n){ print $fh ($i==1?"   spl     stone1\n":"        spl     stone$i\n"); }
print $fh "        spl     1,      <1031\n        spl     1,      <1030\n        spl     1,      <1029\n";
print $fh "paper   spl     \@0,     <2032\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        spl     \@0,     <3035\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        spl     \@0,     <4036\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        spl     \@0,     <5039\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        spl     \@0,     <6040\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        spl     \@0,     <7043\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        jmp     paper,  <7043\n";
for my $i (1..$n){ my $bomb=($i%2)?'sb':'db'; my $p=$ph[($i-1)%@ph]; print $fh "stone$i  mov.i   $bomb,     $p\n        add.ab  #step,  stone$i\n        jmp     stone$i\n"; }
print $fh "sb      spl     #0,     #0\ndb      dat.f   #0,     #0\n        end     start\n";
