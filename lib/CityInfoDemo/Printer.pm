package CityInfoDemo::Printer;

use strict;
use warnings;

use Exporter 'import';
use Carp qw( confess );
use JSON;
use Const::Fast;

use CityInfoDemo::Printer::JSON;

use parent 'CityInfoDemo';

const our $OUTPUT_FORMAT_JSON => 'json';

our @EXPORT_OK = qw( $OUTPUT_FORMAT_JSON );

const my $MAPPINGS => {
    $OUTPUT_FORMAT_JSON => 'CityInfoDemo::Printer::JSON',
};

sub new {
    my ( $class, $args_ref ) = @_;

    my $impl_module = $MAPPINGS->{ $args_ref->{format} };

    my $impl;

    if ($impl_module) {
        $impl = $impl_module->new($args_ref);
    }

    if ( !$impl ) {
        confess('Do not know how to initialize printer object');
    }

    return $impl;
}

1;
