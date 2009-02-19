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
                    looks_like_money

                    strings_eq
                    strings_eq_ignoring_whitespace

                    is_equivalent_xml
                    is_parsable_xml

                    text_files_eq
                    binary_files_eq

                    dies
                    warns

                    sql_is_preparable
                /;

my $Test = Test::Builder->new;

=head1 NAME

Test::Specific - offers Test::More style test functions that are more specific than "ok()".

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Test::Specific is like Test::More - it exports a bunch of useful routines for testing.

TODO: add examples

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.


=over 4

is_defined
is_not_defined
is_true
is_not_true
is_integer
looks_like_money
text_files_eq
binary_files_eq
sql_is_preparable
is_equivalent_xml
is_parsable_xml
dies
warns
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

sub dies {
    my( $coderef, $exception) = @_;

    eval {
        &$coderef;
    };
    my $error = $@;

    unless( $error ){
        $Test->ok( 0, "Codeblock didn't die" );
    }else{
        $Test->like( $error, $exception, );
    }
}
sub warns {
    my( $coderef, $exception) = @_;

    my $warning;
    local $SIG{__WARN__} = sub {
        $warning = shift;
    };

    &$coderef;

    unless( $warning ){
        $Test->ok( 0, "Codeblock didn't warn" );
    }else{
        $Test->like( $warning, $exception, );
    }
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

    #$Test->cmp_ok(sprintf('%.10f',$input),
    #              '==',
    #              sprintf('%.10f',$expected),
    #             );
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
  $Test->ok( _strings_eq($input, $expected) );
}



sub _strings_eq {
  my ( $input, $expected ) = @_;
  return $input eq $expected;
}

sub strings_eq_ignoring_whitespace {
  my ( $input, $expected ) = @_;

  $Test->ok( _strings_eq_ignoring_whitespace($input, $expected) );
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

sub _make_temp_file {
    my ( $content, $suffix ) = @_;
    $suffix ||= '.txt';
    my ($fh, $filename) = tempfile( DIR => tempdir( CLEANUP => 1 ), SUFFIX => $suffix );
    print $fh $content;
    return ( $fh, $filename );
}

# TODO: use Test::Files....

sub text_files_eq {
    my ( $input_filename, $test_filename ) = @_;

    unless( _binary_files_eq( $input_filename, $test_filename ) ){
        _text_files_eq( $input_filename, $test_filename );
    }
}

sub binary_files_eq {
    my ( $input_filename, $test_filename ) = @_;

    die "Binary files $input_filename and $test_filename are not equal at "
       .(caller)[2]." of package ".(caller)[0]."\n" 
        unless _binary_files_eq( $input_filename, $test_filename );
}

sub _binary_files_eq {
    my ( $input_filename, $test_filename ) = @_;

    my ( $input_fh, $test_fh ) = _multi_open( $input_filename, $test_filename );

    my $input_ctx = Digest::MD5->new;
    my $test_ctx  = Digest::MD5->new;

    $input_ctx->addfile( $input_fh );
    $test_ctx->addfile(  $test_fh  );

    my $input_digest = $input_ctx->hexdigest;
    my $test_digest  = $test_ctx->hexdigest;

    _multi_close( $input_fh, $test_fh );
    return $input_digest eq $test_digest ;
}

sub _multi_open {
    my ( @filenames ) = @_;

    my @fhs;
    foreach my $filename ( @filenames ) {
        open( my $fh, $filename ) 
            or die "couldn't open $filename for reading: $!\n";
        push @fhs, $fh;
    }
    return @fhs;
}

sub _multi_close {
    my ( @fhs ) = @_;

    foreach my $fh ( @fhs ) {
        close $fh or die "couldn't close filehandle: $!\n";
    }
}


sub _text_files_eq {
    my ( $input_filename, $test_filename ) = @_;

    my ( $input_fh, $test_fh ) = _multi_open( $input_filename, $test_filename );
    while(<$input_fh>){
        my $test_line = <$test_fh>;
        die "'$_'  from $input_filename ne '$test_line'  from $test_filename "
           ." at line # $. of $test_filename at " 
           .(caller)[2]." of package ".(caller)[0]."\n" 
            unless _strings_eq( $_, $test_line );
    }
    # we might have read off the end of the input file but not test
    my $test_line = <$test_fh> ;
    if( defined $test_line ){
        die "$test_filename contains extra lines(s), starting with line # $.:\n"
           .$test_line
           ." at line # $. of $test_filename at " 
           .(caller)[2]." of package ".(caller)[0]."\n" ;
    }
    _multi_close( $input_fh, $test_fh );
}

sub sql_is_preparable {
    my ( $dbh, $sql) = @_;
    die "DBH invalid" unless defined $dbh and $dbh->ping;
    $dbh->prepare( $sql ) or die "could not prepare $sql: ".$dbh->errstr."\n";
}

sub is_equivalent_xml {
    my ( $input, $expected ) = @_;
    my $inputObj    = XML::Simple->new(ForceArray => 1, AttrIndent => 1);
    my $expectedObj = XML::Simple->new(ForceArray => 1, AttrIndent => 1);

    my $inputRef    = $inputObj->XMLin( $input );
    my $expectedRef = $expectedObj->XMLin( $expected );

    my $inputString  = $inputObj->XMLout( $inputRef );
    my $expectedString = $expectedObj->XMLout( $expectedRef );
    die "XML documents are not equivalent\n\n$inputString\n ne \n$expectedString\n at line ".(caller)[2]." of package ".(caller)[0]."\n" unless _strings_eq_ignoring_whitespace($inputString, $expectedString);
}

sub is_parsable_xml {
  my ( $xml) = @_;

  my $parser = XML::Parser->new;
  my $obj = eval {$parser->parse( $xml )};


  if($@){
    if(ref $@){
      die $@->getMessage();
    }else{
      die $@;
    }
  }
}

sub is_integer {
  my ( $input ) = @_;
  $Test->ok( defined $input
             and $input =~ /^\-?\d+$/
           )
    or $Test->diag( ( defined $input ? $input : '' )." does not look like an integer");
}
  

sub looks_like_money {
  my ( $input, ) = @_;
  $Test->ok( defined $input
             and $input ne ''
             and sprintf("%0.3f", $input) =~ /^\d+\.\d{2}0$/
             and sprintf("%0.10f", $input) =~ /^\d+\.\d{2}00000000$/
           )
    or $Test->diag( ( defined $input ? $input : '' )." does not look like money");
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

=head2 looks_like_money( $input )

This method tests that the input *looks like* money. 

=cut

=head2 dies($coderef, $exception)

Tests that the given codeblock dies.  If $exception is passed,
asserts that the exception matches the regexp.  $exception
can be a regex in the form '/foo/' or qr/foo/.

=cut

=head2 warns($coderef, $exception)

Tests that the given codeblock warns.  If $exception is passed,
asserts that the exception matches the regexp.  $exception
can be a regex in the form '/foo/' or qr/foo/.

=cut

=head2 is_equivalent_xml($input, $expected)

This method tests that 2 pieces of XML are equivalent.

=cut

=head2 is_parsable_xml($xml)

This method tests that a piece of XML is parsable.

=cut

=head2 hashes_eq($input, $expected)

This method tests that 2 hashes are equal

=cut

=head2 num_close($input, $expected)

This method tests that 2 numbers are close.
Close is defined to be 10 decimal places.

=cut

=head2 num_eq( $input, $expected )

This method tests that 2 numbers are equal.

=cut

=head2 strings_eq( $input, $expected )

This method tests that 2 strings are equal.

=cut

=head2 strings_eq_ignoring_whitespace( $input, $expected )

This method tests that 2 strings are equal, ignoring whitespace.

=cut

=head2 binary_files_eq( $input_filename, $test_filename )

    Tests that two binary files have identical contents

=cut 

=head2 text_files_eq( $input_filename, $test_filename )

    Tests that two text files have identical contents

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

=head2 sql_is_preparable( $dbh, $sql )

    Tests that the supplied SQL text can be prepared using the given database handle.

=cut


=head1 AUTHOR

Jeff Lavallee, C<< <jeff at zeroclue.com> >>

=head1 TODO

The tests for this could be a lot more complete.  Please feel free to submit 
additional test cases (especailly if they expose bugs!)



It would be nice to print better diagnostics - the values passed in, for example.  

Unfortunately, Test::Builder::Tester doesn't seem to play very nicely with using
Test::Builder->diag() to print such messages.  If you know the right way, please
let me know.  Thanks!

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
