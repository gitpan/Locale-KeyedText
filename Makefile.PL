use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
	NAME	=> 'Locale::KeyedText',
	VERSION_FROM => 'lib/Locale/KeyedText.pm', # finds $VERSION
	PREREQ_PM => {
	},
);
