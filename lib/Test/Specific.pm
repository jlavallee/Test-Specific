package Test::Specific;

use warnings;
use strict;
use Digest::MD5;
use XML::Simple;
use XML::Parser;
use File::Temp qw/tempdir tempfile/;
use Test::Builder;

use base qw/Exporter/;

our @EXPORT = qw/
                    is_defined
                    is_not_defined
                    is_true
                    is_not_true

                    is_integer
                    numbers_close
                    numbers_eq
                    numbers_order_of_magnitude

                    strings_eq
                    strings_eq_ignoring_whitespace

                /;

my $Test = Test::Builder->new;

=head1 NAME

Test::Specific - offers Test::More style test functions that are more specific than "ok()".

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Test::Specific provides a collection of specific test functions.

=head1 EXPORT

=over 4

is_defined
is_not_defined
is_true
is_not_true
is_integer
numbers_close
numbers_eq
numbers_order_of_magnitude
strings_eq
strings_eq_ignoring_whitespace

=back

=cut

sub is_defined {
    my( $input, $name) = @_;

    $Test->ok( defined $input ? 1 : 0, $name );
}

sub is_not_defined {
    my( $input, $name) = @_;

    $Test->ok( defined $input ? 0 : 1, $name );
}

sub is_true {
    my( $input, $name) = @_;
    $Test->ok( $input , $name );
}

sub is_not_true {
    my ( $input, $name) = @_;
    $Test->ok( do { not $input }, $name );
}


sub numbers_close {
    my ( $input, $input2 ) = @_;

    if ( not defined $input or $input !~ /^-?[\d\.]+/ ) {
        $Test->ok( 0 );
        $Test->diag( "first argument @{[ defined $input ? $input : '' ]} is not a number" );
        return;
    }
    elsif ( not defined $input2 or $input2 !~ /^-?[\d\.]+/ ) {
        $Test->ok( 0 );
        $Test->diag( "second argument @{[ defined $input2 ? $input2 : '' ]} is not a number" );
        return;
    }

    if ( sprintf('%.10f',$input) ne sprintf('%.10f',$input2) ){
        $Test->ok( 0 );
        $Test->diag( ( defined $input    ? $input : '' )
                    .' and '
                    .( defined $input2 ? $input2 : '' )
                    .' are not close'
               );
    }else{
        $Test->ok(1);
    }
}

sub numbers_eq {
    my ( $input, $expected ) = @_;

    $Test->cmp_ok( $input,
                  '==',
                  $expected
                 );
}

sub numbers_order_of_magnitude {
    my ( $input, $expected ) = @_;   

    if (    not defined $input 
         or not defined $expected
         or ( $input >= 0 and ( $expected / 10 > $input or $expected * 10 < $input ) )
         or ( $input <  0 and ( $expected / 10 < $input or $expected * 10 > $input ) )
       ) {
        $Test->ok( 0 );
        $Test->diag( ( defined $input    ? $input : '' )
                    .' and '
                    .( defined $expected ? $expected : '' )
                    .' are not within an order of magnitude of each other'
               );
    }else{
        $Test->ok( 1 );
    }
}

sub strings_eq {
  my ($input, $expected ) = @_;
  $Test->ok( _strings_eq($input, $expected) )
    or $Test->diag("      got: $input\nexpected: $expected");
}



sub _strings_eq {
  my ( $input, $expected ) = @_;
  return $input eq $expected;
}

sub strings_eq_ignoring_whitespace {
  my ( $input, $expected ) = @_;

  $Test->ok( _strings_eq_ignoring_whitespace($input, $expected) )
    or $Test->diag("      got: $input\nexpected: $expected");
}

sub _strings_eq_ignoring_whitespace {
  my ( $input, $expected ) = @_;
  my ( $orig_input, $orig_expected ) = ( $input, $expected );

  for my $string ( $input, $expected ){
    $string =~ s/\n//gm;
    $string =~ s/^\s+|\s+$//g;
    $string =~ s/\s+/ /g; 

    if ( _looks_like_xml_or_html( $string ) ) {
      $string =~ s/\s+([<>])/$1/gm;
      $string =~ s/>\s+</></g;
    }
  }
  return _strings_eq($input, $expected);
}

sub _looks_like_xml_or_html {
    my ( $string ) = @_;
    return 1 if $string =~ m#^\s*<[.=\w\s"/!:?-]+>#mg;
}

sub is_integer {
  my ( $input ) = @_;
  $Test->ok( defined $input
             and $input =~ /^\-?\d+$/
           )
    or $Test->diag( ( defined $input ? $input : '' )." does not look like an integer");
}
  


1;


__END__

=head1 FUNCTIONS

=cut

=head2 is_defined( $input )

This method tests that its input is defined

=cut

=head2 is_not_defined( $input )

This method tests that its input is not defined

=cut

=head2 is_true( $input )

This method tests that its input is true

=cut

=head2 is_not_true( $input )

This method tests that its input is not true

=cut

=head2 is_integer( $input )

This method tests that the input *looks like* an integer.  

Maybe it should be named "looks_like_integer"

=cut


=head2 strings_eq( $input, $expected )

This method tests that 2 strings are equal.

=cut

=head2 strings_eq_ignoring_whitespace( $input, $expected )

This method tests that 2 strings are equal, ignoring whitespaced differences

=cut

=head2 numbers_close( $input, $expected )

    Tests that two numbers are close.  Close is defined as being equal to 10 decimal places

=cut

=head2 numbers_eq( $input, $expected )

    Tests that two numbers are equal

=cut

=head2 numbers_order_of_magnitude( $input, $expected )

    Tests that two numbers are within an order of magnitude of eachother.

=cut


=head1 AUTHOR

Jeff Lavallee, C<< <jeff at zeroclue.com> >>

=head1 TODO

The tests for this could be a lot more complete.  Please feel free to submit 
additional test cases (especailly if they expose bugs!)


=head1 BUGS

Please report any bugs or feature requests to
C<bug-test-specific at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-Specific>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Test::Specific

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Test-Specific>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Test-Specific>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test-Specific>

=item * Search CPAN

L<http://search.cpan.org/dist/Test-Specific>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2006 Jeff Lavallee, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Test::Specific
