package CityInfoDemo::GeoArea::City::Store::File;

use strict;
use warnings;

use CityInfoDemo::GeoArea::City::Store::File::Reader;

use parent 'CityInfoDemo::GeoArea::City::Store';

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

    $self->{_reader} ||= CityInfoDemo::GeoArea::City::Store::File::Reader->new( $self->_file_path() );

    return $self->{_reader};
}

1;
