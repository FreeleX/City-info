package CityInfoDemo::GeoArea::Country::Store::Empty;

use strict;
use warnings;

use parent 'CityInfoDemo::GeoArea::Country::Store';

sub new {
    my ( $class, $args_ref ) = @_;

    my $self = bless {}, $class;

    return $self;
}

1;
