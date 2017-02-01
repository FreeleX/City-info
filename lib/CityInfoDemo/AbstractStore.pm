package CityInfoDemo::AbstractStore;

use strict;
use warnings;

use Carp qw( confess );
use Scalar::Util qw( weaken );
use Const::Fast;

use CityInfoDemo::Collection;

use parent 'CityInfoDemo';

const my $COLLECTION_NAME => 'CityInfoDemo::Collection';

sub new {
    my ($class) = @_;

    my $self = bless {}, $class;

    return $self;
}

sub _reader {
    my ($self) = @_;

    confess 'Should be redefined in subclass';

    return 1;
}

sub get_record_name {
    my ($self) = @_;

    confess 'Should be redefined in subclass';

    return 1;
}

sub bind_store {
    my ( $self, $store ) = @_;

    my $name = $store->get_record_name()->get_store_name();

    $self->{_binded_stores}->{$name} ||= $store;

    return 1;
}

sub binded_store {
    my ( $self, $name ) = @_;

    $self->{_binded_stores}->{$name} ||= $name->new();

    return $self->{_binded_stores}->{$name};
}

sub add {
    my ( $self, $record ) = @_;

    $record->store($self);

    $self->_store_records_children($record);

    return 1;
}

sub _store_records_children {
    my ( $self, $record ) = @_;

    my @all_fields = $record->fields();

    for my $field (@all_fields) {
        my $mapping = $record->field_mapping($field);
        my $value   = $record->get($field);

        if ( $mapping && $value ) {
            weaken($value);
            my $strong_ref = $value;

            my $store_name = $mapping->{store};

            $self->binded_store($store_name)->add($strong_ref);
        }
    }

    return 1;
} ## end sub _store_records_children

sub get_all {
    my ($self) = @_;

    confess 'Should be redefined in subclass';

    return 1;
}

sub _get_collection_name {
    my ($self) = @_;

    return $COLLECTION_NAME;
}

1;
