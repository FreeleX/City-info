package CityInfoDemo::GeoArea::City::Store;

use strict;
use warnings;

use Const::Fast;

use CityInfoDemo::GeoArea::City::Record;
use CityInfoDemo::GeoArea::City::Store::File;

use parent 'CityInfoDemo::GeoArea::Store';

const my $RECORD_NAME => 'CityInfoDemo::GeoArea::City::Record';
const my $MAPPINGS    => {
    file_path => 'CityInfoDemo::GeoArea::City::Store::File',
};

sub new {
    my ( $class, $args_ref ) = @_;

    my $impl = $class->SUPER::new($args_ref);

    if ( !$impl ) {
        confess('Do not know how to initalize city storage');
    }

    return $impl;
}

sub _init {
    my ( $self, $args_ref ) = @_;

    $self->SUPER::_init($args_ref);

    if ( $args_ref->{country_store} ) {
        $self->bind_store( $args_ref->{country_store} );
    }

    return;
}

sub bind_store {
    my ( $self, $args_ref ) = @_;

    return $self->SUPER::bind_store($args_ref);
}

sub _get_mappings {
    return $MAPPINGS;
}

sub get_record_name {
    return $RECORD_NAME;
}

1;
