#!perl -T

use Test::More tests => 43;
use Test::Builder::Tester;
use Test::Builder::Tester::Color;

use Test::Specific;


is_integer(                        1,           'is integer works for 1');
is_integer(                      100,         'is integer works for 100');
is_integer(                       -1,          'is integer works for -1');
is_integer(                        0,           'is integer works for 0');
is_integer(              -1000000000, 'is integer works for -1000000000');
is_integer(               1000000000,  'is integer works for 1000000000');
is_integer( '9999999999999999999999',  'is integer works for lots of 9s');

looks_like_money( 5.95, 'looks like money works for 5.95' );


numbers_order_of_magnitude( 1,     9,  'numbers order of magnitude works for 1, 9' );
numbers_order_of_magnitude( 10,   90,  'numbers order of magnitude works for 10, 90' );
numbers_order_of_magnitude( -1,   -9,  'numbers order of magnitude works for -1, -9' );
numbers_order_of_magnitude( -10, -90,  'numbers order of magnitude works for -10, -90' );


numbers_close(  1.00000000001,  1.00000000002,   'numbers close works for 1.00000000001 and 1.00000000002');
numbers_close( -1.00000000005, -1.00000000009,   'numbers close works for 1.00000000001 and 1.00000000009');

numbers_eq(  1,  1,       'numbers eq works for 1, 1' );
numbers_eq( -1, -1,       'numbers eq works for -1, -1' );


# note that the last one fails because it overflows to 1e+22
run_single_value_fail_tests( 'is_integer', '# %s does not look like an integer',
                             undef, '', 1.12312, -1.1, -99999999999.999, 999999999999999999999999999,
                           );

run_single_value_fail_tests( 'looks_like_money', '# %s does not look like money',
                             undef, '', 1.12312, -1.1, -99999999999.999, -3.357, 
                           );


run_value_pair_fail_tests( 'numbers_order_of_magnitude', '# %s and %s are not within an order of magnitude of each other',
                           1 => 100, 1 => 11, -1 => 10, -2 => -20.0001, 100 => 10_000, 0 => undef,
                         );

run_value_pair_fail_tests( 'numbers_close', '# %s and %s are not close',
                           1 => 100, 1 => 11, -1 => 10, -2 => -20.0001, 100 => 10_000, 0 => 0.1,
                         );

run_value_pair_fail_tests( 'numbers_close', '# first argument %s is not a number',
                           undef => 1, foo => undef, bar => 1,
                         );
run_value_pair_fail_tests( 'numbers_close', '# second argument %2$s is not a number',
                           1 => undef, 4 => 'bar',
                         );





sub run_single_value_fail_tests {
    my ( $function, $message, @test_values ) = @_;
    for my $test_value ( @test_values ){
        test_out('not ok 1'); 
        test_fail(+2);
        test_err(sprintf( $message, defined $test_value ? $test_value : '' ) );
        &$function( $test_value );
        test_test( sprintf('%s correctly fails for %s', $function, defined $test_value ? $test_value : '' ) );
    }
}

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

