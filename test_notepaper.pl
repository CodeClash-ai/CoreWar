use strict;
use warnings;

my $notepaper_code = <<'NOTEPAPER';
;redcode-94
;name Notepaper
;author Notepaper
;assert VERSION >= 80

step1   equ 5555
step2   equ 6505
step3   equ 5743

init    spl     1,      <3445
        spl     1,      <5005
        spl     1,      <5366

silk1   spl     @0,     step1
        mov.i   }silk1, >silk1
silk2   spl     @0,     step2
        mov.i   }silk2, >silk2
silk3   spl     @0,     step3
        mov.i   }silk3, >silk3
        mov.i   bmb,    >1000
        jmp     silk1,  <2000
bmb     dat     #0,     #0

end init
NOTEPAPER

open(my $fh, '>', 'notepaper.red') or die $!;
print $fh $notepaper_code;
close($fh);

my $cmd = "./src/pmars -r 500 -s 8000 -c 80000 -p 8000 -l 100 -d 100 warrior.red notepaper.red";
print `$cmd`;
