package CityInfoDemo::GeoArea::Country::Store::Net;

use strict;
use warnings;

use CityInfoDemo::GeoArea::Country::Store::Net::Reader;

use parent 'CityInfoDemo::GeoArea::Country::Store';

sub new {
    my ( $class, $args_ref ) = @_;

    my $self = bless {}, $class;

    $self->_init($args_ref);

    return $self;
}

sub _init {
    my ( $self, $args_ref ) = @_;

    $self->SUPER::_init($args_ref);

    $self->{_file_path} = $args_ref->{file_path};

    return;
}

sub _file_path {
    my ($self) = @_;

    return $self->{_file_path};
}

sub _reader {
    my ($self) = @_;

    $self->{_reader} ||= CityInfoDemo::GeoArea::Country::Store::Net::Reader->new();

    return $self->{_reader};
}

1;
