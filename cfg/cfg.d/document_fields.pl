# By default there are no custom fields in document objects, but this file
# provides you with an example should you wish to (c.f. eprint_fields.pl)

#$c->{fields}->{document} = [
#	{
#		name => "application",
#		type => "set",
#		options => [
#			'msword95',
#			'msword2000',
#			'msword2007',
#		],
#	},
#];
{
package EPrints::Script::Compiled;

    sub run_original_documents {
        my( $self, $state, $eprint ) = @_; 
        if( ! $eprint->[0]->isa( "EPrints::DataObj::EPrint") ) {
            $self->runtime_error( "documents() must be called on an eprint object." );
        }
        return [ [grep { $_->is_set( "content" ) && $_->value( "content" ) eq "original" } $eprint->[0]->get_all_documents()],  "ARRAY" ];
    };
    sub run_cover_image {
        my( $self, $state, $eprint ) = @_;
        if( ! $eprint->[0]->isa( "EPrints::DataObj::EPrint") ) {
            $self->runtime_error( "cover_image() must be called on an eprint object." );
        }
        return [ [grep { $_->is_set( "content" ) && $_->value( "content" ) eq "coverimage" } $eprint->[0]->get_all_documents()],  "ARRAY" ];
    }
}
