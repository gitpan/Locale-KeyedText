#!perl
use 5.008001;
use utf8;
use strict;
use warnings;

if ($] < 5.008007) {
    warn q{
---------------------------------------------------------------------------
  This distribution prefers the newest Perl 5.x.y version, which is 5.8.7
  at the time of this writing, but Perl versions down to 5.8.1 will not be
  blocked and should likely continue to work for awhile.
  You can also ignore any warnings during installation about the use of
  "=encoding utf8" in the pod documentation.
  Continuing in 3 seconds...
---------------------------------------------------------------------------
    };
    sleep 3;
}

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
        'Scalar::Util' => 0,
        # These mainly are for the test suite.
        'Test::More' => 0,
    },
);

1; # Magic true value required at end of a reuseable file's code.
