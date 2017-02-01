package CityInfoDemo::GeoArea::City::Record;

use strict;
use warnings;

use Const::Fast;

use CityInfoDemo::Utils qw( format_with_commas );

use CityInfoDemo::GeoArea::Country::Record;

use parent 'CityInfoDemo::GeoArea::Record';

const my @FIELDS         => qw( country population );
const my $FIELD_MAPPINGS => {
    country => {
        record => 'CityInfoDemo::GeoArea::Country::Record',
        store  => 'CityInfoDemo::GeoArea::Country::Store',
    },
};
const my $STORE_NAME          => 'CityInfoDemo::GeoArea::City::Store';
const my $COUNTRY_RECORD_NAME => 'CityInfoDemo::GeoArea::Country::Record';

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

sub as_data {
    my ($self) = @_;

    my $data = $self->SUPER::as_data();

    $self->_add_country_data($data);

    return $data;
}

sub _add_country_data {
    my ( $self, $city_data ) = @_;

    my $country_record = $city_data->{country};

    if ( !$self->_is_country_record($country_record) ) {
        return 0;
    }

    my $capital_name = $country_record->get('capital');
    my $has_capital = $capital_name ? 1 : 0;

    if ( $has_capital && lc($capital_name) eq lc( $city_data->{name} ) ) {
        $city_data->{is_capital}         = 1;
        $city_data->{country_population} = format_with_commas( $country_record->get('population') );
    }

    $city_data->{country} = $self->_to_country_name($country_record);

    return 1;
} ## end sub _add_country_data

sub _is_country_record {
    my ( $self, $record ) = @_;

    return $record && ref $record eq $COUNTRY_RECORD_NAME ? 1 : 0;
}

sub _to_country_name {
    my ( $self, $record ) = @_;

    return $record->get('name');
}

1;
