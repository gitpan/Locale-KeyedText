#!perl

use 5.008001; use utf8; use strict; use warnings;

BEGIN { $| = 1; print "1..102\n"; }

######################################################################
# First ensure the modules to test will compile, are correct versions:

use lib 't/lib';
use Locale::KeyedText '1.01';
# see end of this file for loading of test Template modules

######################################################################
# Here are some utility methods:

# Set this to 1 to see complete result text for each test
my $verbose = shift( @ARGV ) ? 1 : 0;  # set from command line

my $test_num = 0;

sub result {
	my ($worked, $detail) = @_;
	$test_num++;
	$verbose or 
		$detail = substr( $detail, 0, 50 ).
		(length( $detail ) > 47 ? "..." : "");	print "@{[$worked ? '' : 'not ']}ok $test_num $detail\n";
}

sub message {
	my ($detail) = @_;
	print "-- $detail\n";
}

sub vis {
	my ($str) = @_;
	$str =~ s/\n/\\n/g;  # make newlines visible
	$str =~ s/\t/\\t/g;  # make tabs visible
	return( $str );
}

sub serialize {
	my ($input,$is_key) = @_;
	return( join( '', 
		ref($input) eq 'HASH' ? 
			( '{ ', ( map { 
				( serialize( $_, 1 ), serialize( $input->{$_} ) ) 
			} sort keys %{$input} ), '}, ' ) 
		: ref($input) eq 'ARRAY' ? 
			( '[ ', ( map { 
				( serialize( $_ ) ) 
			} @{$input} ), '], ' ) 
		: defined($input) ?
			"'$input'".($is_key ? ' => ' : ', ')
		: "undef".($is_key ? ' => ' : ', ')
	) );
}

######################################################################
# Now perform the actual tests:

message( "START TESTING Locale::KeyedText" );

######################################################################

{
	message( "testing new_message() and Message object methods" );

	my ($did, $should, $msg1);

	$did = serialize( Locale::KeyedText->new_message() );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_message() returns '$did'" );

	$did = serialize( Locale::KeyedText->new_message( undef ) );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_message( undef ) returns '$did'" );

	$did = serialize( Locale::KeyedText->new_message( '' ) );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_message( '' ) returns '$did'" );

	$did = serialize( Locale::KeyedText->new_message( '0 ' ) );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_message( '0 ' ) returns '$did'" );

	$did = serialize( Locale::KeyedText->new_message( 'x-' ) );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_message( 'x-' ) returns '$did'" );

	$did = serialize( Locale::KeyedText->new_message( 'x:' ) );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_message( 'x:' ) returns '$did'" );

	$msg1 = Locale::KeyedText->new_message( '0' );
	result( UNIVERSAL::isa( $msg1, "Locale::KeyedText::Message" ), 
		"msg1 = new_message( '0' ) ret MSG obj" );
	$did = $msg1->as_string();
	$should = "0: ";
	result( $did eq $should, "on init msg1->as_string() returns '$did'" );

	$msg1 = Locale::KeyedText->new_message( 'zZ9' );
	result( UNIVERSAL::isa( $msg1, "Locale::KeyedText::Message" ), 
		"msg1 = new_message( 'zZ9' ) ret MSG obj" );
	$did = $msg1->as_string();
	$should = "zZ9: ";
	result( $did eq $should, "on init msg1->as_string() returns '$did'" );

	$did = serialize( Locale::KeyedText->new_message( 'foo', [] ) );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_message( 'foo', [] ) returns '$did'" );

	$did = serialize( Locale::KeyedText->new_message( 'foo', { ' '=>'g' } ) );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_message( 'foo', { ' '=>'g' } ) returns '$did'" );

	$did = serialize( Locale::KeyedText->new_message( 'foo', { ':'=>'g' } ) );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_message( 'foo', { ':'=>'g' } ) returns '$did'" );

	$msg1 = Locale::KeyedText->new_message( 'foo', undef );
	result( UNIVERSAL::isa( $msg1, "Locale::KeyedText::Message" ), 
		"msg1 = new_message( 'foo', undef ) ret MSG obj" );
	$did = $msg1->as_string();
	$should = "foo: ";
	result( $did eq $should, "on init msg1->as_string() returns '$did'" );

	$msg1 = Locale::KeyedText->new_message( 'foo', {} );
	result( UNIVERSAL::isa( $msg1, "Locale::KeyedText::Message" ), 
		"msg1 = new_message( 'foo', {} ) ret MSG obj" );
	$did = $msg1->as_string();
	$should = "foo: ";
	result( $did eq $should, "on init msg1->as_string() returns '$did'" );

	$msg1 = Locale::KeyedText->new_message( 'foo', { 'bar' => 'baz' } );
	result( UNIVERSAL::isa( $msg1, "Locale::KeyedText::Message" ), 
		"msg1 = new_message( 'foo', { 'bar' => 'baz' } ) ret MSG obj" );
	$did = $msg1->as_string();
	$should = "foo: bar=baz";
	result( $did eq $should, "on init msg1->as_string() returns '$did'" );

	$msg1 = Locale::KeyedText->new_message( 'foo', { 'bar'=>'baz','c'=>'-','0'=>'1','z'=>'','y'=>'0' } );
	result( UNIVERSAL::isa( $msg1, "Locale::KeyedText::Message" ), 
		"msg1 = new_message( 'foo', { 'bar'=>'baz','c'=>'d','0'=>'1','z'=>'','y'=>'0' } ) ret MSG obj" );
	$did = $msg1->as_string();
	$should = "foo: 0=1, bar=baz, c=-, y=0, z=";
	result( $did eq $should, "on init msg1->as_string() returns '$did'" );

	$did = serialize( $msg1->get_message_key() );
	$should = "'foo', ";
	result( $did eq $should, "on init msg1->get_message_key() returns '$did'" );

	$did = serialize( $msg1->get_message_variable() );
	$should = "undef, ";
	result( $did eq $should, "on init msg1->get_message_variable() returns '$did'" );

	$did = serialize( $msg1->get_message_variable( undef ) );
	$should = "undef, ";
	result( $did eq $should, "on init msg1->get_message_variable( undef ) returns '$did'" );

	$did = serialize( $msg1->get_message_variable( '' ) );
	$should = "undef, ";
	result( $did eq $should, "on init msg1->get_message_variable( '' ) returns '$did'" );

	$did = serialize( $msg1->get_message_variable( '0' ) );
	$should = "'1', ";
	result( $did eq $should, "on init msg1->get_message_variable( '0' ) returns '$did'" );

	$did = serialize( $msg1->get_message_variable( 'zzz' ) );
	$should = "undef, ";
	result( $did eq $should, "on init msg1->get_message_variable( 'zzz' ) returns '$did'" );

	$did = serialize( $msg1->get_message_variable( 'bar' ) );
	$should = "'baz', ";
	result( $did eq $should, "on init msg1->get_message_variable( 'bar' ) returns '$did'" );

	$did = serialize( $msg1->get_message_variables() );
	$should = "{ '0' => '1', 'bar' => 'baz', 'c' => '-', 'y' => '0', 'z' => '', }, ";
	result( $did eq $should, "on init msg1->get_message_variables() returns '$did'" );
}

######################################################################

{
	message( "testing new_translator() and most Translator object methods" );

	my ($did, $should, $trn1);

	$did = serialize( Locale::KeyedText->new_translator() );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_translator() returns '$did'" );

	$did = serialize( Locale::KeyedText->new_translator( undef, undef ) );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_translator( undef, undef ) returns '$did'" );

	$did = serialize( Locale::KeyedText->new_translator( [], undef ) );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_translator( [], undef ) returns '$did'" );

	$did = serialize( Locale::KeyedText->new_translator( undef, [] ) );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_translator( undef, [] ) returns '$did'" );

	$trn1 = Locale::KeyedText->new_translator( [], [] );
	result( UNIVERSAL::isa( $trn1, "Locale::KeyedText::Translator" ), 
		"trn1 = new_translator( [], [] ) ret TRN obj" );
	$did = $trn1->as_string();
	$should = "SETS: ; MEMBERS: ";
	result( $did eq $should, "on init trn1->as_string() returns '$did'" );

	$did = serialize( Locale::KeyedText->new_translator( '', [] ) );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_translator( '', [] ) returns '$did'" );

	$did = serialize( Locale::KeyedText->new_translator( '0 ', [] ) );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_translator( '0 ', [] ) returns '$did'" );

	$did = serialize( Locale::KeyedText->new_translator( 'x-', [] ) );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_translator( 'x-', [] ) returns '$did'" );

	$trn1 = Locale::KeyedText->new_translator( '0', [] );
	result( UNIVERSAL::isa( $trn1, "Locale::KeyedText::Translator" ), 
		"trn1 = new_translator( '0', [] ) ret TRN obj" );
	$did = $trn1->as_string();
	$should = "SETS: 0; MEMBERS: ";
	result( $did eq $should, "on init trn1->as_string() returns '$did'" );

	$trn1 = Locale::KeyedText->new_translator( 'zZ9', [] );
	result( UNIVERSAL::isa( $trn1, "Locale::KeyedText::Translator" ), 
		"trn1 = new_translator( 'zZ9', [] ) ret TRN obj" );
	$did = $trn1->as_string();
	$should = "SETS: zZ9; MEMBERS: ";
	result( $did eq $should, "on init trn1->as_string() returns '$did'" );

	$trn1 = Locale::KeyedText->new_translator( ['zZ9'], [] );
	result( UNIVERSAL::isa( $trn1, "Locale::KeyedText::Translator" ), 
		"trn1 = new_translator( ['zZ9'], [] ) ret TRN obj" );
	$did = $trn1->as_string();
	$should = "SETS: zZ9; MEMBERS: ";
	result( $did eq $should, "on init trn1->as_string() returns '$did'" );

	$trn1 = Locale::KeyedText->new_translator( ['zZ9','aaa'], [] );
	result( UNIVERSAL::isa( $trn1, "Locale::KeyedText::Translator" ), 
		"trn1 = new_translator( ['zZ9','aaa'], [] ) ret TRN obj" );
	$did = $trn1->as_string();
	$should = "SETS: zZ9, aaa; MEMBERS: ";
	result( $did eq $should, "on init trn1->as_string() returns '$did'" );

	$did = serialize( Locale::KeyedText->new_translator( [], '' ) );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_translator( [], '' ) returns '$did'" );

	$did = serialize( Locale::KeyedText->new_translator( [], '0 ' ) );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_translator( [], '0 ' ) returns '$did'" );

	$did = serialize( Locale::KeyedText->new_translator( [], 'x-' ) );
	$should = "undef, ";
	result( $did eq $should, "Locale::KeyedText->new_translator( [], 'x-' ) returns '$did'" );

	$trn1 = Locale::KeyedText->new_translator( [], '0' );
	result( UNIVERSAL::isa( $trn1, "Locale::KeyedText::Translator" ), 
		"trn1 = new_translator( [], '0' ) ret TRN obj" );
	$did = $trn1->as_string();
	$should = "SETS: ; MEMBERS: 0";
	result( $did eq $should, "on init trn1->as_string() returns '$did'" );

	$trn1 = Locale::KeyedText->new_translator( [], 'zZ9' );
	result( UNIVERSAL::isa( $trn1, "Locale::KeyedText::Translator" ), 
		"trn1 = new_translator( [], 'zZ9' ) ret TRN obj" );
	$did = $trn1->as_string();
	$should = "SETS: ; MEMBERS: zZ9";
	result( $did eq $should, "on init trn1->as_string() returns '$did'" );

	$trn1 = Locale::KeyedText->new_translator( [], ['zZ9'] );
	result( UNIVERSAL::isa( $trn1, "Locale::KeyedText::Translator" ), 
		"trn1 = new_translator( [], ['zZ9'] ) ret TRN obj" );
	$did = $trn1->as_string();
	$should = "SETS: ; MEMBERS: zZ9";
	result( $did eq $should, "on init trn1->as_string() returns '$did'" );

	$trn1 = Locale::KeyedText->new_translator( [], ['zZ9','aaa'] );
	result( UNIVERSAL::isa( $trn1, "Locale::KeyedText::Translator" ), 
		"trn1 = new_translator( [], ['zZ9','aaa'] ) ret TRN obj" );
	$did = $trn1->as_string();
	$should = "SETS: ; MEMBERS: zZ9, aaa";
	result( $did eq $should, "on init trn1->as_string() returns '$did'" );

	$trn1 = Locale::KeyedText->new_translator( ['goo','har'], ['wer','thr'] );
	result( UNIVERSAL::isa( $trn1, "Locale::KeyedText::Translator" ), 
		"trn1 = new_translator( ['goo','har'], ['wer','thr'] ) ret TRN obj" );
	$did = $trn1->as_string();
	$should = "SETS: goo, har; MEMBERS: wer, thr";
	result( $did eq $should, "on init trn1->as_string() returns '$did'" );

	$did = serialize( $trn1->get_template_set_names() );
	$should = "[ 'goo', 'har', ], ";
	result( $did eq $should, "on init trn1->get_template_set_names() returns '$did'" );

	$did = serialize( $trn1->get_template_member_names() );
	$should = "[ 'wer', 'thr', ], ";
	result( $did eq $should, "on init trn1->get_template_member_names() returns '$did'" );

	$trn1 = Locale::KeyedText->new_translator( ['go::o','::har'], ['w::er','thr::'] );
	result( UNIVERSAL::isa( $trn1, "Locale::KeyedText::Translator" ), 
		"trn1 = new_translator( ['go::o','::har'], ['w::er','thr::'] ) ret TRN obj" );
	$did = $trn1->as_string();
	$should = "SETS: go::o, ::har; MEMBERS: w::er, thr::";
	result( $did eq $should, "on init trn1->as_string() returns '$did'" );
}

######################################################################

{
	message( "testing Translator->translate_message() method" );

	my $AS = 't_Locale_KeyedText_A_L_';
	my $BS = 't_Locale_KeyedText_B_L_';
	my $CS = 't_Locale_KeyedText_C_L_';

	my ($did, $should, $msg1, $msg2, $msg3, $trn1, $trn2, $trn3, $trn4, $trn11);

	# First test that anything does or doesn't work, and test variable substitution.

	$msg1 = Locale::KeyedText->new_message( 'one' );
	result( 1, "msg1 = new_message( 'one' ) contains '".$msg1->as_string()."'" );

	$msg2 = Locale::KeyedText->new_message( 'one', {'spoon'=>'lift','fork'=>'0'} );
	result( 1, "msg2 = new_message( 'one', {'spoon'=>'lift','fork'=>'0'} ) contains '".$msg2->as_string()."'" );

	$msg3 = Locale::KeyedText->new_message( 'one', {'spoon'=> undef,'fork'=>''} );
	result( 1, "msg3 = new_message( 'one', {'spoon'=> undef,'fork'=>''} ) contains '".$msg3->as_string()."'" );

	$trn1 = Locale::KeyedText->new_translator( [$AS],['Eng'] );
	result( 1, "trn1 = new_translator( [$AS],['Eng'] ) contains '".$trn1->as_string()."'" );

	$trn2 = Locale::KeyedText->new_translator( [$BS],['Eng'] );
	result( 1, "trn2 = new_translator( [$BS],['Eng'] ) contains '".$trn2->as_string()."'" );

	$did = serialize( $trn1->translate_message() );
	$should = "undef, ";
	result( $did eq $should, "trn1->translate_message() returns '$did'" );

	$did = serialize( $trn1->translate_message( 'foo' ) );
	$should = "undef, ";
	result( $did eq $should, "trn1->translate_message( 'foo' ) returns '$did'" );

	$did = serialize( $trn1->translate_message( 'Locale::KeyedText::Message' ) );
	$should = "undef, ";
	result( $did eq $should, "trn1->translate_message( 'Locale::KeyedText::Message' ) returns '$did'" );

	$did = $trn1->translate_message( $msg1 );
	$should = "AE - word {fork} { fork } {spoon} {{fork}}";
	result( $did eq $should, "trn1->translate_message( msg1 ) returns '$did'" );

	$did = $trn1->translate_message( $msg2 );
	$should = "AE - word 0 { fork } lift {0}";
	result( $did eq $should, "trn1->translate_message( msg2 ) returns '$did'" );

	$did = $trn1->translate_message( $msg3 );
	$should = "AE - word  { fork }  {}";
	result( $did eq $should, "trn1->translate_message( msg3 ) returns '$did'" );

	$did = serialize( $trn2->translate_message( $msg2 ) );
	$should = "undef, ";
	result( $did eq $should, "trn2->translate_message( msg2 ) returns '$did'" );

	# Next test multiple module searching.

	$msg1 = Locale::KeyedText->new_message( 'one', {'spoon'=>'lift','fork'=>'poke'} );
	result( 1, "msg1 = new_message( 'one', {'spoon'=>'lift','fork'=>'poke'} ) contains '".$msg1->as_string()."'" );

	$msg2 = Locale::KeyedText->new_message( 'two' );
	result( 1, "msg2 = new_message( 'two' ) contains '".$msg2->as_string()."'" );

	$msg3 = Locale::KeyedText->new_message( 'three', { 'knife'=>'sharp' } );
	result( 1, "msg3 = new_message( 'three', { 'knife'=>'sharp' } ) contains '".$msg3->as_string()."'" );

	$trn1 = Locale::KeyedText->new_translator( [$AS,$BS],['Eng','Fre'] );
	result( 1, "trn1 = new_translator( [$AS],['Eng'] ) contains '".$trn1->as_string()."'" );

	$trn2 = Locale::KeyedText->new_translator( [$AS,$BS],['Fre','Eng'] );
	result( 1, "trn2 = new_translator( [$AS],['Eng'] ) contains '".$trn2->as_string()."'" );

	$trn3 = Locale::KeyedText->new_translator( [$BS,$AS],['Eng','Fre'] );
	result( 1, "trn3 = new_translator( [$AS],['Eng'] ) contains '".$trn3->as_string()."'" );

	$trn4 = Locale::KeyedText->new_translator( [$BS,$AS],['Fre','Eng'] );
	result( 1, "trn4 = new_translator( [$AS],['Eng'] ) contains '".$trn4->as_string()."'" );

	$did = serialize( $trn1->translate_message( $msg1 ) );
	$should = "'AE - word poke { fork } lift {poke}', ";
	result( $did eq $should, "trn1->translate_message( msg1 ) returns '$did'" );

	$did = serialize( $trn1->translate_message( $msg2 ) );
	$should = "'AE - sky pie rye', ";
	result( $did eq $should, "trn1->translate_message( msg2 ) returns '$did'" );

	$did = serialize( $trn1->translate_message( $msg3 ) );
	$should = "'BE - eat sharp', ";
	result( $did eq $should, "trn1->translate_message( msg3 ) returns '$did'" );

	$did = serialize( $trn2->translate_message( $msg1 ) );
	$should = "'AF - word poke { fork } lift {poke}', ";
	result( $did eq $should, "trn2->translate_message( msg1 ) returns '$did'" );

	$did = serialize( $trn2->translate_message( $msg2 ) );
	$should = "'AF - sky pie rye', ";
	result( $did eq $should, "trn2->translate_message( msg2 ) returns '$did'" );

	$did = serialize( $trn2->translate_message( $msg3 ) );
	$should = "'BF - eat sharp', ";
	result( $did eq $should, "trn2->translate_message( msg3 ) returns '$did'" );

	$did = serialize( $trn3->translate_message( $msg1 ) );
	$should = "'AE - word poke { fork } lift {poke}', ";
	result( $did eq $should, "trn3->translate_message( msg1 ) returns '$did'" );

	$did = serialize( $trn3->translate_message( $msg2 ) );
	$should = "'BE - sky pie rye', ";
	result( $did eq $should, "trn3->translate_message( msg2 ) returns '$did'" );

	$did = serialize( $trn3->translate_message( $msg3 ) );
	$should = "'BE - eat sharp', ";
	result( $did eq $should, "trn3->translate_message( msg3 ) returns '$did'" );

	$did = serialize( $trn4->translate_message( $msg1 ) );
	$should = "'AF - word poke { fork } lift {poke}', ";
	result( $did eq $should, "trn4->translate_message( msg1 ) returns '$did'" );

	$did = serialize( $trn4->translate_message( $msg2 ) );
	$should = "'BF - sky pie rye', ";
	result( $did eq $should, "trn4->translate_message( msg2 ) returns '$did'" );

	$did = serialize( $trn4->translate_message( $msg3 ) );
	$should = "'BF - eat sharp', ";
	result( $did eq $should, "trn4->translate_message( msg3 ) returns '$did'" );

	$trn11 = Locale::KeyedText->new_translator( [$CS],['Eng'] );
	result( 1, "trn11 = new_translator( [$CS],['Eng'] ) contains '".$trn11->as_string()."'" );

	$did = serialize( $trn11->translate_message( $msg1 ) );
	$should = "'poke shore lift', ";
	result( $did eq $should, "trn11->translate_message( msg1 ) returns '$did'" );

	$did = serialize( $trn11->translate_message( $msg2 ) );
	$should = "'sky fly high', ";
	result( $did eq $should, "trn11->translate_message( msg2 ) returns '$did'" );

	$did = serialize( $trn11->translate_message( $msg3 ) );
	$should = "'sharp zot', ";
	result( $did eq $should, "trn11->translate_message( msg3 ) returns '$did'" );
}

######################################################################

{
	message( "confirming availability of all test Template modules" );

	# done after all translate_message() calls as that method should be 
	# 'requiring' these itself, and we don't want to "interfere" with that.

	eval {
		require t_Locale_KeyedText_A_L_Eng;
		t_Locale_KeyedText_A_L_Eng->get_text_by_key( 'foo' );
	};
	result( $@ eq "", "load and invoke t_Locale_KeyedText_A_L_Eng; \$\@ contains '$@'" );

	eval {
		require t_Locale_KeyedText_A_L_Fre;
		t_Locale_KeyedText_A_L_Fre->get_text_by_key( 'foo' );
	};
	result( $@ eq "", "load and invoke t_Locale_KeyedText_A_L_Eng; \$\@ contains '$@'" );

	eval {
		require t_Locale_KeyedText_B_L_Eng;
		t_Locale_KeyedText_B_L_Eng->get_text_by_key( 'foo' );
	};
	result( $@ eq "", "load and invoke t_Locale_KeyedText_A_L_Eng; \$\@ contains '$@'" );

	eval {
		require t_Locale_KeyedText_B_L_Fre;
		t_Locale_KeyedText_B_L_Fre->get_text_by_key( 'foo' );
	};
	result( $@ eq "", "load and invoke t_Locale_KeyedText_A_L_Eng; \$\@ contains '$@'" );
}

######################################################################

message( "DONE TESTING Locale::KeyedText" );

######################################################################
######################################################################

package # hide this class name from PAUSE indexer
t_Locale_KeyedText_C_L_Eng;

sub get_text_by_key {
	my %text_strings = (
		'one' => "{fork} shore {spoon}",
		'two' => "sky fly high",
		'three' => "{knife} zot",
	);
	return( $text_strings{$_[1]} );
}

######################################################################

1;
