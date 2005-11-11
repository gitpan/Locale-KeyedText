#!perl
use 5.008007;
use utf8;
use strict;
use warnings;

use Locale::KeyedText;
use MyLib;

###########################################################################
###########################################################################

sub main {
    # user indicates language pref as command line argument
    my @user_lang_prefs = grep { $_ =~ m/^[a-zA-Z]+$/x } @ARGV;
    @user_lang_prefs = 'Eng'
        if +@user_lang_prefs == 0;

    my $translator = Locale::KeyedText::Translator->new({
        'set_names'    => ['MyApp::L::', 'MyLib::L::'],
        'member_names' => \@user_lang_prefs,
    });

    show_message( $translator, Locale::KeyedText::Message->new({
        'msg_key' => 'MYAPP_HELLO' }) );

    INPUT_LINE:
    {
        show_message( $translator, Locale::KeyedText::Message->new({
            'msg_key' => 'MYAPP_PROMPT' }) );

        my $user_input = <STDIN>;
        chomp $user_input;

        # user simply hits return on an empty line to quit the program
        last INPUT_LINE
            if $user_input eq q{};

        eval {
            my $result = MyLib->my_invert( $user_input );
            show_message( $translator, Locale::KeyedText::Message->new({
                'msg_key'  => 'MYAPP_RESULT',
                'msg_vars' => {
                    'ORIGINAL' => $user_input,
                    'INVERTED' => $result,
                },
            }) );
        };
        show_message( $translator, $@ )
            if $@; # input error, detected by library

        redo INPUT_LINE;
    }

    show_message( $translator, Locale::KeyedText::Message->new({
        'msg_key' => 'MYAPP_GOODBYE' }) );

    return;
}

sub show_message {
    my ($translator, $message) = @_;
    my $user_text = $translator->translate_message( $message );
    if (!$user_text) {
        print STDERR "internal error: can't find user text for a message:\n"
            . '   ' . $message->as_debug_string() . "\n"
            . '   ' . $translator->as_debug_string() . "\n";
        return;
    }
    print STDOUT $user_text . "\n";
    return;
}

###########################################################################
###########################################################################

use Readonly;
Readonly my %text_stringsE => (
    'MYAPP_HELLO' => q[Welcome to MyApp.],
    'MYAPP_GOODBYE' => q[Goodbye!],
    'MYAPP_PROMPT'
        => q[Enter a number to be inverted, or press ENTER to quit.],
    'MYAPP_RESULT' => q[The inverse of "<ORIGINAL>" is "<INVERTED>".],
);

{ package MyApp::L::Eng; # module
    sub get_text_by_key {
        my (undef, $msg_key) = @_;
        return $text_stringsE{$msg_key};
    }
} # module MyApp::L::Eng

###########################################################################
###########################################################################

use Readonly;
Readonly my %text_stringsF => (
    'MYAPP_HELLO' => q[Bienvenue allé MyApp.],
    'MYAPP_GOODBYE' => q[Salut!],
    'MYAPP_PROMPT'
        => q[Fournir nombre être inverser, ou appuyer sur]
           . q[ ENTER être arrêter.],
    'MYAPP_RESULT' => q[Renversement "<ORIGINAL>" est "<INVERTED>".],
);

{ package MyApp::L::Fre; # module
    sub get_text_by_key {
        my (undef, $msg_key) = @_;
        return $text_stringsF{$msg_key};
    }
} # module MyApp::L::Fre

###########################################################################
###########################################################################

main();
