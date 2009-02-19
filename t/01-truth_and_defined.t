#!perl -T

use Test::More tests => 19;
use Test::Builder::Tester;
use Test::Builder::Tester::Color;


use Test::Specific;


# first the pass tests

is_true( 1,              'is true works for 1' );
is_true( 'one',          'is true works for one' );

is_not_true( '',         'is not true works for \'\'' );
is_not_true( 0,          'is not true works for 0' );
is_not_true( undef,      'is not true works for undef' );


is_defined( 1,           'is defined works for 1' );
is_defined( '',          'is defined works for \'\'' );
is_defined( 'one',       'is defined works for one' );

is_not_defined( undef,   'is defined works for 1' );






# now the fail tests......

run_fail_tests( 'is_true', 0, undef, '' );    

# TODO: add test for that special case "not true value" or whatever it was....
run_fail_tests( 'is_not_true',    1, -1, 'some string' );

# what else should cause is_defined to fail?
run_fail_tests( 'is_defined',     undef );

run_fail_tests( 'is_not_defined', 1, -1, '' );




sub run_fail_tests {
    my ( $function, @test_values ) = @_;
    for my $test_value ( @test_values ){
        test_out('not ok 1'); 
        test_fail(+1);
        &$function( $test_value );
        test_test( "$function correctly fails for ".( $test_value ? $test_value : '' ) );
    }
}
