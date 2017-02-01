package CityInfoDemo::Printer::Abstract;

use strict;
use warnings;

use Carp qw( confess );

sub new {
    my ($class) = @_;

    return bless {}, $class;
}

sub _format {
    my ( $self, $data ) = @_;

    confess 'Should be redefined in subclass';

    return 1;
}

sub print {
    my ( $self, $data, $fh ) = @_;

    $fh ||= \*STDOUT;

    print $fh $self->_format($data);

    return 1;
}

1;
