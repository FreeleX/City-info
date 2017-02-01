package CityInfoDemo::GeoArea::Country::Record;

use strict;
use warnings;

use Const::Fast;

use CityInfoDemo::GeoArea::Record;
use CityInfoDemo::GeoArea::Country::Store;

use parent 'CityInfoDemo::GeoArea::Record';

const my @FIELDS         => qw( population capital );
const my $FIELD_MAPPINGS => {};
const my $STORE_NAME     => 'CityInfoDemo::GeoArea::Country::Store';

my $internal_id = 0;

sub new {
    my ( $class, $args_ref, $store ) = @_;

    my $self = $class->SUPER::new( $args_ref, $store );

    $self->_init($args_ref);

    return $self;
}

sub _init {
    my ( $self, $args_ref, $store ) = @_;

    $self->SUPER::_init( $args_ref, $store );

    my $new_id = $internal_id++;

    $self->{id} = $new_id;

    return 1;
}

sub fields {
    my ($self) = @_;

    my @parent_list = $self->SUPER::fields();

    return @parent_list, @FIELDS;
}

sub field_mapping {
    my ( $self, $field ) = @_;

    return exists $FIELD_MAPPINGS->{$field} ? $FIELD_MAPPINGS->{$field} : undef;
}

sub get_store_name {
    return $STORE_NAME;
}

1;
