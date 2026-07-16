use strict; use warnings;
my($file,@ph)=@ARGV; @ph=(1030,2031,3034,4035,5038,6039,7042,1029,2030,3033,4034,5037,6038,7041) unless @ph;
my $n=@ph;
open my $fh,'>',$file or die $!;
print $fh ";redcode-94\n;name hybph$n\n;assert CORESIZE == 8000\nstep equ 1031\nstart";
for my $i (1..$n){ print $fh ($i==1?"   spl     stone1\n":"        spl     stone$i\n"); }
print $fh "        spl     1,      <1031\n        spl     1,      <1030\n        spl     1,      <1029\npaper   spl     \@0,     <2032\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        spl     \@0,     <3035\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        spl     \@0,     <4036\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        spl     \@0,     <5039\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        spl     \@0,     <6040\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        spl     \@0,     <7043\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        mov.i   }paper, >paper\n        jmp     paper,  <7043\n";
for my $i (1..$n){ my $bomb=($i%2)?'sb':'db'; my $p=$ph[$i-1]; print $fh "stone$i  mov.i   $bomb,     $p\n        add.ab  #step,  stone$i\n        jmp     stone$i\n"; }
print $fh "sb      spl     #0,     #0\ndb      dat.f   #0,     #0\n        end     start\n";
