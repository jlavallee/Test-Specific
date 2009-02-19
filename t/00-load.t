#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Test::Specific' );
}

diag( "Testing Test::Specific $Test::Specific::VERSION, Perl $], $^X" );
