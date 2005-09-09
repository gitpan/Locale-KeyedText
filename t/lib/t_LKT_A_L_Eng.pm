#!perl
use 5.008001; use utf8; use strict; use warnings;

package # hide this class name from PAUSE indexer
t_LKT_A_L_Eng;

my $xy = 'AE';
my %text_strings = (
    'one' => $xy.' - word {fork} { fork } {spoon} {{fork}}',
    'two' => $xy.' - sky pie rye',
);

sub get_text_by_key {
    my (undef, $msg_key) = @_;
    return $text_strings{$msg_key};
}

1;
