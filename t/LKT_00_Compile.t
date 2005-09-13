#!perl
use 5.008001; use utf8; use strict; use warnings;

use Test::More;
use version;

plan( 'tests' => 13 );

use_ok( 'Locale::KeyedText' );
is( $Locale::KeyedText::VERSION, qv('1.6.1'), "Locale::KeyedText is the correct version" );

use lib 't/lib';

use_ok( 't_LKT_Util' );
can_ok( 't_LKT_Util', 'message' );
can_ok( 't_LKT_Util', 'serialize' );

use_ok( 't_LKT_A_L_Eng' );
can_ok( 't_LKT_A_L_Eng', 'get_text_by_key' );

use_ok( 't_LKT_A_L_Fre' );
can_ok( 't_LKT_A_L_Fre', 'get_text_by_key' );

use_ok( 't_LKT_B_L_Eng' );
can_ok( 't_LKT_B_L_Eng', 'get_text_by_key' );

use_ok( 't_LKT_B_L_Fre' );
can_ok( 't_LKT_B_L_Fre', 'get_text_by_key' );

1;
