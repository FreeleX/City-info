package CityInfoDemo::GeoArea::City::Store::File::Reader;

use strict;
use warnings;

use Const::Fast;
use Carp qw( carp croak );

const my $LINE_RE => qr/^(\d+)\. +(.+), +(.+) +- +([\d,\.]+)/;

sub new {
    my ( $class, $file_path ) = @_;

    my $self = bless {}, $class;

    $self->_init($file_path);

    return $self;
}

sub _init {
    my ( $self, $file_path ) = @_;

    my $fh;
    open( $fh, '<', $file_path ) or croak( sprintf( 'Failed to open for read: %s', $file_path ) );

    $self->{_fh}        = $fh;
    $self->{_file_path} = $file_path;

    return 1;
}

sub _fh {
    my ($self) = @_;

    return $self->{_fh};
}

sub get_iterator {
    my ($self) = @_;

    $self->_to_start();

    return sub {
        if ( eof $self->_fh() ) {
            return undef;
        }

        my $line = readline $self->_fh();
        chomp $line;

        return $self->_parse($line);
    };
}

sub _parse {
    my ( $self, $line ) = @_;

    if ( $line !~ $LINE_RE ) {
        carp sprintf( 'Failed to parse line: %s', $line ) if $line;
        return undef;
    }

    my ( $id, $name, $country, $population ) = ( $line =~ $LINE_RE );

    return {
        id         => $id,
        name       => $name,
        country    => $country,
        population => $population,
    };
}

sub _to_start {
    my ($self) = @_;

    seek( $self->_fh(), 0, 0 );

    readline $self->_fh();    # skip header

    return 1;
}

sub _read_whole_with_list_context {
    my ($self) = @_;

    my $fh = $self->_fh();

    my @lines = <$fh>;

    return @lines;
}

sub _read_whole_with_scope {
    my ($self) = @_;

    my $fh = $self->_fh();
    my $text;

    {
        local $/ = undef;
        $text = <$fh>
    }

    my @lines = split( "\n", $text );

    return @lines;
}

sub read_all {
    my ($self) = @_;

    $self->_to_start();

    # my @lines = $self->_read_whole_with_list_context();
    my @lines = $self->_read_whole_with_scope();

    my @city_records;

    for my $line (@lines) {
        my $info = $self->_parse($line);

        if ($info) {
            push @city_records, $info;
        }
    }

    return @city_records;
} ## end sub read_all

sub DESTROY {
    my ($self) = @_;

    close $self->_fh();
}

1;
