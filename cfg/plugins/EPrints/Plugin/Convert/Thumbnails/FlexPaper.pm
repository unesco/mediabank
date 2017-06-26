package EPrints::Plugin::Convert::Thumbnails::FlexPaper;

use EPrints::Plugin::Convert::Thumbnails;
@ISA = qw/ EPrints::Plugin::Convert::Thumbnails /;

use strict;

sub new
{
	my( $class, %opts ) = @_;

	my $self = $class->SUPER::new( %opts );

	$self->{name} = "FlexPaper";

	if( defined $self->{session} )
	{
		my $cfg = $self->{session}->get_repository->get_conf( "executables" );
		if( !defined( $self->{'pdf2swf'} = $cfg->{'pdf2swf'} ) )
		{
			$self->{'convert_formats'} = {};
		}
	}

	return $self;
}
