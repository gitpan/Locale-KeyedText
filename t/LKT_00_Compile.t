#!perl
use 5.008001;
use utf8;
use strict;
use warnings;

use Test::More;
use version;

plan( 'tests' => 2 );

use_ok( 'Locale::KeyedText' );
is( $Locale::KeyedText::VERSION, qv('1.6_3'), 'Locale::KeyedText is the correct version' );

1; # Magic true value required at end of a reuseable file's code.
