#!perl -T

use Test::More tests => 6;

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
