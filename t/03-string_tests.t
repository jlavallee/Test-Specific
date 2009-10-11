#!perl -T

use Test::More tests => 8;
use Test::Builder::Tester;
use Test::Builder::Tester::Color;

use Test::Specific;


strings_eq( 'simple string', 'simple string', 'strings eq works for simple string' );
strings_eq( 'some rather longer &#&@$^(@*&^$ string', 
            'some rather longer &#&@$^(@*&^$ string', 
            'strings eq works for some rather longer string' 
);
strings_eq( '', '', 'strings eq works for empty string' );


strings_eq_ignoring_whitespace( 'simple     string', 'simple string', 'strings eq ignoring whitespace works for simple string' );
strings_eq_ignoring_whitespace( 'some     rather     longer     &#&@$^(@*&^$     string',     
                                'some rather longer &#&@$^(@*&^$ string', 
                                'strings eq ignoring whitespace works for some rather longer string' 
);
strings_eq_ignoring_whitespace( '', '', 'strings eq ignoring whitespace works for empty string' );



run_value_pair_fail_tests( 'strings_eq_ignoring_whitespace', "#       got: %s\n# expected: %s",
                           'foo bar baz' => 'foo bar',
                           'foo bar' => 'foo  bar  baz',
                         );



sub run_value_pair_fail_tests {
    my ( $function, $message, %tests ) = @_;
    while( my ($input, $input2) = each %tests) {
        test_out('not ok 1'); 
        test_fail(+5);
        test_err(sprintf( $message, 
                 defined $input ? $input : '',
                 defined $input2 ? $input2 : ''
                ) );
        &$function( $input, $input2 );
        test_test( sprintf('%s correctly fails for %s, %s', $function, 
                   defined $input ? $input : '',
                   defined $input2 ? $input2 : ''
                 ) );
    }
}
