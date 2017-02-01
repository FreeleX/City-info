package CityInfoDemo::CityReport;

use strict;
use warnings;

use Exporter 'import';
use Const::Fast;

use CityInfoDemo::GeoArea::City::Store;
use CityInfoDemo::GeoArea::Country::Store;
use CityInfoDemo::Printer qw( $OUTPUT_FORMAT_JSON );

use parent 'CityInfoDemo';

our @EXPORT_OK = qw( $OUTPUT_FORMAT_JSON );

const my @CONFIG_FIELDS => qw( source_file_path output_format output_fh );

sub new {
    my ( $class, $args_ref ) = @_;

    my $self = bless {}, $class;

    $self->_init($args_ref);

    return $self;
}

sub _init {
    my ( $self, $args_ref ) = @_;

    @{ $self->{_config} }{@CONFIG_FIELDS} = @{$args_ref}{@CONFIG_FIELDS};

    return 1;
}

sub _defaults {
    my ($self) = @_;

    return {
        output_fh => \*STDOUT,
    };
}

sub _config {
    my ( $self, $name ) = @_;

    my $value = $self->{_config}->{$name};

    return defined $value ? $value : $self->_defaults->{$name};
}

sub _net_country_store {
    my ($self) = @_;

    $self->{_net_country_store} ||= CityInfoDemo::GeoArea::Country::Store->new( {
            net      => 1,
            autoload => 1,
        },
    );

    return $self->{_net_country_store};
}

sub _store {
    my ($self) = @_;

    $self->{_store} = CityInfoDemo::GeoArea::City::Store->new( {
            file_path     => $self->_config('source_file_path'),
            country_store => $self->_net_country_store(),
        },
    );

    return $self->{_store};
}

sub _printer {
    my ($self) = @_;

    $self->{_printer} ||= CityInfoDemo::Printer->new( {
            format => $self->_config('output_format'),
        },
    );

    return $self->{_printer};
}

sub city {
    my ( $self, $city_name ) = @_;

    my $output_fh = $self->_config('output_fh');
    my $record    = $self->_store()->get_by_name($city_name);

    if ( !$record ) {
        print $output_fh sprintf( "No info found for %s\n", $city_name );

        return 0;
    }

    print $output_fh sprintf( "Short info for %s:\n", $city_name );

    $self->_printer()->print( $record->as_data(), $output_fh );

    print $output_fh "\n";

    return 1;
} ## end sub city

sub all {
    my ($self) = @_;

    my $output_fh = $self->_config('output_fh');
    my @list      = $self->_store()->get_all()->as_data_list();

    if ( !@list ) {
        print $output_fh sprintf("No cities info found\n");

        return 0;
    }

    print $output_fh sprintf("Short info for all cities:\n");

    $self->_printer()->print( \@list, $output_fh );

    print $output_fh "\n";

    return 1;
} ## end sub all

1;
