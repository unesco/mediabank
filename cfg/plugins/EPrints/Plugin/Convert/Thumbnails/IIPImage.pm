package EPrints::Plugin::Convert::Thumbnails::IIPImage;

use EPrints::Plugin::Convert::Thumbnails;
@ISA = qw/ EPrints::Plugin::Convert::Thumbnails /;

use strict;

sub new
{
	my( $class, %opts ) = @_;

	my $self = $class->SUPER::new( %opts );

	$self->{name} = "IIPImage";

	return $self;
}
