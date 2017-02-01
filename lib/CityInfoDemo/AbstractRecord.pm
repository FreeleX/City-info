package CityInfoDemo::AbstractRecord;

use strict;
use warnings;

use Carp qw( confess );
use Const::Fast;

use parent 'CityInfoDemo';

const my @FIELDS         => qw( id );
const my $FIELD_MAPPINGS => {};

sub new {
    my ( $class, $args_ref, $store ) = @_;

    my $self = bless {}, $class;

    $self->_init( $args_ref, $store );

    return $self;
}

sub store {
    my ( $self, $store ) = @_;

    if ($store) {
        $self->{_store} = $store;
    }
    else {
        $self->{_store} ||= $self->get_store_name()->new();
    }

    return $self->{_store};
}

sub fields {
    return @FIELDS;
}

sub field_mapping {
    my ($self) = @_;

    confess 'Should be redefined in subclass';

    return 1;
}

sub get_store_name {
    my ($self) = @_;

    confess 'Should be redefined in subclass';

    return 1;
}

sub _init {
    my ( $self, $args_ref, $store ) = @_;

    if ($store) {
        $self->store($store);
    }

    my @all_fields = $self->fields();

    for my $field (@all_fields) {
        my $has_mappings = $self->field_mapping($field) ? 1 : 0;

        if ($has_mappings) {
            $self->{$field} = $self->_get_field_record( $field, $args_ref );
        }
        else {
            $self->{$field} = $self->_get_field_value( $field, $args_ref );
        }
    }

    return 1;
} ## end sub _init

sub _get_field_record {
    my ($self) = @_;

    confess 'Should be redefined in subclass';

    return undef;
}

sub _get_field_value {
    my ( $self, $field, $args_ref ) = @_;

    return $args_ref->{$field};
}

sub as_data {
    my ($self) = @_;

    my $info = {};

    my @all_fields = $self->fields();

    @{$info}{@all_fields} = @{$self}{@all_fields};

    return $info
}

sub get {
    my ( $self, $name ) = @_;

    return $self->{$name};
}

1;
