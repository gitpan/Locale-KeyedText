#!perl
use 5.008001;
use utf8;
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME' => 'Locale::KeyedText',
    'VERSION_FROM' => 'lib/Locale/KeyedText.pm', # finds $VERSION
    'ABSTRACT' => 'Refer to user messages in programs by keys',
    'AUTHOR' => 'Darren R. Duncan <perl@DarrenDuncan.net>',
#    'LICENSE' => 'lgpl',
    'PREREQ_PM' => {
        # These mainly add features to Perl 5 that are built-in to Perl 6.
        'version' => 0,
        'only' => 0,
        'Readonly' => '1.03',
        'Class::Std' => '0.0.4',
        'Class::Std::Utils' => '0.0.2',
        # These mainly are for the test suite.
        'Test::More' => 0,
    },
);

1; # Magic true value required at end of a reuseable file's code.
