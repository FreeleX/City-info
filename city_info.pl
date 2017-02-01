#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
use Const::Fast;

use lib 'lib';

use CityInfoDemo::CityReport qw( $OUTPUT_FORMAT_JSON );

const my $DEFAULT_FILE_PATH => 'cities_db.txt';

my $city_name;
my $file_path = $DEFAULT_FILE_PATH;

my $options_parser = Getopt::Long::Parser->new();

my $got_options = $options_parser->getoptions(
    'city=s' => \$city_name,
    'file=s' => \$file_path
);

if ( !$got_options ) {
    carp('Cannot parse command line arguments');
}

my $report = CityInfoDemo::CityReport->new( {
        source_file_path => $file_path,
        output_format    => $OUTPUT_FORMAT_JSON,
        # output_fh        => \*STDERR,
    }
);

$report->city($city_name) if $city_name;

$report->all();

exit 0;
