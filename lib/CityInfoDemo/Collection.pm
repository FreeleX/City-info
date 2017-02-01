package CityInfoDemo::Collection;

use strict;
use warnings;

use parent 'CityInfoDemo';

sub new {
    my ( $class, $list_ref ) = @_;

    my $self = $list_ref && @{$list_ref} ? $list_ref : [];

    return bless $self, $class;
}

sub as_data_list {
    my ($self) = @_;

    my @list;

    for my $item ( @{$self} ) {
        push @list, $item->as_data();
    }

    return @list;
}

1;
