# Add the field "carousel featured" to the eprint
$c->add_dataset_field( "eprint",
	{
		name => "carousel_featured",
		type => "boolean",
		volatile => 1,
	}
);

# Change this value to change the size of your thumbnail - Add this to your zz_thumbnails.pl
# $c->{plugins}->{'Convert::Thumbnails'}->{params}->{sizes} = {(
#    carousel => [980,450],
# )};

# Add new size to list of files to be generated
#$c->{thumbnail_types} = sub {
#        my( $list, $repo, $doc ) = @_;
#        push @$list, qw( xxx, xxx, xxx, carousel ); 
#};

{

package EPrints::Script::Compiled;

sub run_carousel
{
	my( $self, $state, $n ) = @_;

	my $repo = $state->{repository};

	my $ids = $repo->dataset( "archive" )->search(
		filters => [
			{
				meta_fields => [qw( carousel_featured )],
				value => "TRUE",
			}
		]
	)->ids;

	my $carousel = $repo->xml->create_document_fragment;

	for( 1 .. $n->[0] )
	{
		my $id = splice @$ids, rand @$ids, 1;
		my $eprint = $repo->dataset( "archive" )->dataobj( $id );
		next unless defined $eprint;

		$carousel->appendChild( $eprint->render_citation_link( "carousel", active => [ $_ == 1 ? "active" : "", "STRING" ] ) );
	}

	return [ $carousel, "XHTML" ];
}

sub run_carousel_image
{
	my( $self, $state, $eprint ) = @_;

	if( ! $eprint->[0]->isa( "EPrints::DataObj::EPrint") )
	{
		$self->runtime_error( "carousel_image() must be called on an eprint object." );
	}
	my $repo = $state->{repository};

	my @docs = $eprint->[0]->get_all_documents;
	for( @docs )
	{
		return [ $_ ] if $_->is_set( "content" ) && $_->value( "content" ) eq "carousel";
	}

	return [ undef ];
}

}
