#!perl
use 5.008001; use utf8; use strict; use warnings;

# This module is used when testing Locale::KeyedText.
# It contains some utility methods used by the various LKT_*.t scripts.

package # hide this class name from PAUSE indexer
t_LKT_Util;

######################################################################

sub message {
	my (undef, $detail) = @_;
	print "# $detail\n";
}

######################################################################

sub serialize {
	my (undef, $input, $is_key) = @_;
	return join( '', 
		ref($input) eq 'HASH' ? 
			( '{ ', ( map { 
				( t_LKT_Util->serialize( $_, 1 ), t_LKT_Util->serialize( $input->{$_} ) ) 
			} sort keys %{$input} ), '}, ' ) 
		: ref($input) eq 'ARRAY' ? 
			( '[ ', ( map { 
				( t_LKT_Util->serialize( $_ ) ) 
			} @{$input} ), '], ' ) 
		: defined($input) ?
			'\''.$input.'\''.($is_key ? ' => ' : ', ')
		: 'undef'.($is_key ? ' => ' : ', ')
	);
}

######################################################################

1;
