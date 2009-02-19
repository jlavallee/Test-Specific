use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Test::Specific',
    license             => 'perl',
    dist_author         => 'Jeff Lavallee <jeff@zeroclue.com>',
    dist_version_from   => 'lib/Test/Specific.pm',
    build_requires => {
        'Test::More'            => 0,
        'Digest::MD5'           => '',
        'XML::Simple'           => '',
        'XML::Parser'           => '',
        'File::Temp'            => '',
        'Test::Builder::Tester' => '',
    },
    add_to_cleanup      => [ 'Test-Specific-*' ],
);

$builder->create_build_script();
