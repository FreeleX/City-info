package CityInfoDemo::Utils;

use strict;
use warnings;

use Exporter 'import';
use Number::Format ();

use parent 'CityInfoDemo';

our @EXPORT_OK = qw( format_with_commas );

my $number = Number::Format->new(
    -thousands_sep => ',',
    -decimal_point => '.',
);

sub format_with_commas {
    my ($value) = @_;

    return $number->format_number($value);
}

1;
