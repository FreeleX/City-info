package CityInfoDemo::Printer::JSON;

use strict;
use warnings;

use JSON;

use parent 'CityInfoDemo::Printer::Abstract';

sub new {
    my ($class) = @_;

    return bless {}, $class;
}

sub _format {
    my ( $self, $data ) = @_;

    my $json      = JSON->new()->canonical()->pretty();
    my $json_text = $json->encode($data);

    return $json_text;
}

1;
