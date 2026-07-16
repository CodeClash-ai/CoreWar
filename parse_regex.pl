use strict;
use warnings;

my $line = '{"t":0,"c":[[0,0],[1031,0],[2195,1]]}';
if ($line =~ /"c":\[(.*?)\]/) {
    my $c_block = $1;
    print "c_block: $c_block\n";
    while ($c_block =~ /\[(\d+),(\d+)\]/g) {
        print "Found: addr=$1, owner=$2\n";
    }
}
