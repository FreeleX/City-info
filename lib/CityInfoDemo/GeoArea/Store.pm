package CityInfoDemo::GeoArea::Store;

use strict;
use warnings;

use Carp qw( confess );

use parent 'CityInfoDemo::AbstractStore';

sub new {
    my ( $class, $args_ref ) = @_;

    my $impl = $class->_new_impl($args_ref);

    $impl->_init($args_ref);

    return $impl;
}

sub _init {
    my ( $self, $args_ref ) = @_;

    $self->{_records_by_name} = {};

    return 1;
}

sub _new_impl {
    my ( $class, $args_ref ) = @_;

    my $impl;

    my @options = grep { $args_ref->{$_} ? 1 : 0 } keys %{ $class->_get_mappings() };

    for my $option (@options) {
        my $impl_module = $class->_get_mappings()->{$option};

        if ($impl_module) {
            $impl = $impl_module->new($args_ref);
            last;
        }
    }

    return $impl;
}

sub get_record_name {
    my ($self) = @_;

    confess 'Should be redefined in subclass';

    return undef;
}

sub _get_for {
    my ( $self, $name ) = @_;

    return $self->{_records_by_name}->{$name};
}

sub _set_for {
    my ( $self, $name, $record ) = @_;

    return $self->{_records_by_name}->{$name} = $record;
}

sub get_by_name {
    my ( $self, $name ) = @_;

    my $record = $self->_get_for($name);

    if ( !$record ) {
        my $iterator = $self->_reader()->get_iterator();

        while ( my $info = $iterator->() ) {
            if ( $info->{name} eq $name ) {
                my $record = $self->get_record_name()->new( $info, $self );

                return $self->add($record);
            }
        }
    }

    return $record;
}

sub add {
    my ( $self, $record ) = @_;

    $self->SUPER::add($record);

    $self->_set_for( $record->get('name'), $record );

    return $record;
}

sub get_all {
    my ($self) = @_;

    $self->load_all();

    my @list = values %{ $self->{_records_by_name} };

    my @sorted_list = sort { $a->{id} <=> $b->{id} } @list;

    my $collection = $self->_get_collection_name()->new( \@sorted_list );

    return $collection;
}

sub load_all {
    my ($self) = @_;

    if ( %{ $self->{_records_by_name} } ) {
        return 1;
    }

    my @info_list = $self->_reader()->read_all();

    for my $info (@info_list) {
        my $record = $self->get_record_name()->new( $info, $self );

        $self->add($record)
    }

    return 1;
}

sub _reader {
    my ($self) = @_;

    confess 'Should be redefined in subclass';

    return undef;
}

sub _get_collection_name {
    my ($self) = @_;

    return $self->SUPER::_get_collection_name();
}

1;
