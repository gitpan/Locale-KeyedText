#!perl
use 5.008001; use utf8; use strict; use warnings;

package # hide this class name from PAUSE indexer
t_Locale_KeyedText_B_L_Fre;

my $xy = 'BF';
my %text_strings = (
	'two' => $xy.' - sky pie rye',
	'three' => $xy.' - eat {knife}',
);

sub get_text_by_key {
	my (undef, $msg_key) = @_;
	return $text_strings{$msg_key};
}

1;
