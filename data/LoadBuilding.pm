package LoadBuilding;
use strict;
use warnings;

use YAML qw'LoadFile thaw';
use Scalar::Util qw'reftype blessed';
require Exporter;

our @ISA = 'Exporter';
our @EXPORT = qw'LoadBuilding';

use 5.12.2;

sub _load{
  my($input) = @_;
  if( ref $input ){
    if( reftype $input eq 'SCALAR' ){
      return thaw $$input;
    }
  }else{
    return LoadFile $input;
  }
}

sub LoadBuilding{
  my( $config ) = @_;
  __PACKAGE__->Load( $config );
}

sub Load{
  my($self,$config) = @_;
  my $class = blessed $self || $self;
  
  $self = bless {},$class unless ref $self;
  $self->{yaml} = _load($config);
  for my $data ( values %{$self->{yaml}} ){
    @{$data->{tags}} = sort @{ $data->{tags} };
  }
  $self
}

sub types{
  my($self) = @_;
  my %type;
  my $yaml = $self->{yaml};
  for my $building ( sort keys %$yaml ){
    my $type = $yaml->{$building}{type};
    push @{$type{$type}}, $building;
  }
  return \%type;
}