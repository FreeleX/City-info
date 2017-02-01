package CityInfoDemo::GeoArea::Country::Store;

use strict;
use warnings;

use Carp qw( confess );
use Const::Fast;

use CityInfoDemo::GeoArea::Country::Record;
use CityInfoDemo::GeoArea::Country::Store::Net;
use CityInfoDemo::GeoArea::Country::Store::Empty;

use parent 'CityInfoDemo::GeoArea::Store';

const my $RECORD_NAME => 'CityInfoDemo::GeoArea::Country::Record';
const my $MAPPINGS    => {
    net => 'CityInfoDemo::GeoArea::Country::Store::Net',
};

sub new {
    my ( $class, $args_ref ) = @_;

    my $impl = $class->SUPER::new($args_ref);

    if ( !$impl ) {
        $impl = Country::Store::Empty->new($args_ref);
    }

    return $impl;
}

sub _init {
    my ( $self, $args_ref ) = @_;

    $self->SUPER::_init($args_ref);

    if ( $args_ref->{autoload} ) {
        $self->load_all();
    }

    return 1;
}

sub get_by_name {
    my ( $self, $name ) = @_;

    my $record = $self->_get_for($name);

    return $record;
}

sub _get_for {
    my ( $self, $args_ref ) = @_;

    return $self->SUPER::_get_for($args_ref);
}

sub _get_mappings {
    return $MAPPINGS;
}

sub get_record_name {
    return $RECORD_NAME;
}

sub _reader {
    my ($self) = @_;

    confess 'Should be redefined in subclass';

    return undef;
}

sub load_all {
    my ($self) = @_;

    return $self->SUPER::load_all();
}

1;
