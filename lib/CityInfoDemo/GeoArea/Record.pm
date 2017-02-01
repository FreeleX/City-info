package CityInfoDemo::GeoArea::Record;

use strict;
use warnings;

use Carp qw( confess );
use Const::Fast;

use CityInfoDemo::AbstractRecord;

use parent 'CityInfoDemo::AbstractRecord';

const my @FIELDS => qw( name );

sub new {
    my ( $class, $args_ref, $store ) = @_;

    my $self = $class->SUPER::new( $args_ref, $store );

    return $self;
}

sub fields {
    my ($self) = @_;

    my @parent_list = $self->SUPER::fields();

    return @parent_list, @FIELDS;
}

sub _get_field_record {
    my ( $self, $field, $args_ref ) = @_;

    my $mappings = $self->field_mapping($field);

    my $field_store_name = $mappings->{store};
    my $field_store      = $self->store()->binded_store($field_store_name);

    my $name   = $args_ref->{$field};
    my $record = $field_store->get_by_name($name);

    if ( !$record ) {
        my $field_record_name = $mappings->{record};

        $record = $field_record_name->new( { name => $name }, $field_store );
        $field_store->add($record)
    }

    return $record;
} ## end sub _get_field_record

sub store {
    my ( $self, $args_ref ) = @_;

    return $self->SUPER::store($args_ref);
}

sub field_mapping {
    my ( $self, $args_ref ) = @_;

    return $self->SUPER::field_mapping($args_ref);
}

1;
