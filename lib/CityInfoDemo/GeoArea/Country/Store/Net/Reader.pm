package CityInfoDemo::GeoArea::Country::Store::Net::Reader;

use strict;
use warnings;

use Const::Fast;
use REST::Client;
use JSON;

const my $ALL_URL => 'https://restcountries.eu/rest/v1/all';

sub new {
    my ( $class, $file_path ) = @_;

    my $self = bless {}, $class;

    return $self;
}

sub _client {
    my ($self) = @_;

    $self->{_client} ||= REST::Client->new();

    return $self->{_client};
}

sub read_all {
    my ($self) = @_;

    $self->_client()->GET($ALL_URL);

    my $response = $self->_client()->responseContent();

    my $data = JSON->new()->decode($response);

    return @{$data};
}

1;
