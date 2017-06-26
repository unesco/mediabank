$c->{summary_page_contact} = [qw/
	creators_name
	creators_dept
/];

$c->{summary_page_image} = [qw/
	person_shown
	organisation
	event
	where_shown
	date
/];

$c->{summary_page_artwork} = [qw/
  	title_artwork
  	date_artwork
	creator_artwork
	source_artwork
	source_ID_artwork
	copyright_artwork
/];

$c->{summary_page_status} = [qw/
	related_url
	credit_line
	copyright_notice
	right_usage
	source
/];

$c->{summary_page_metadata} = [qw/
	subjects
	sword_depositor
	userid
	datestamp
	lastmod
	commentary
/];

# IMPORTANT NOTE ABOUT SUMMARY PAGES
#
# While you can completely customise them using the perl subroutine
# below, it's easier to edit them via citation/eprint/summary_page.xml


######################################################################

=item $xhtmlfragment = eprint_render( $eprint, $repository, $preview )

This subroutine takes an eprint object and renders the XHTML view
of this eprint for public viewing.

Takes two arguments: the L<$eprint|EPrints::DataObj::EPrint> to render and the current L<$repository|EPrints::Session>.

Returns three XHTML DOM fragments (see L<EPrints::XML>): C<$page>, C<$title>, (and optionally) C<$links>, and (also
optionally) the name of a template C<$template>.

If $preview is true then this is only being shown as a preview. The C<$template> isn't honoured in this situation.
(This is used to stop the "edit eprint" link appearing when it makes
no sense.)

=cut

######################################################################

$c->{eprint_render} = sub
{
	my( $eprint, $repository, $preview ) = @_;

	my $succeeds_field = $repository->dataset( "eprint" )->field( "succeeds" );
	my $commentary_field = $repository->dataset( "eprint" )->field( "commentary" );

	my $flags = { 
		has_multiple_versions => $eprint->in_thread( $succeeds_field ),
		in_commentary_thread => $eprint->in_thread( $commentary_field ),
		preview => $preview,
	};
	my %fragments = ();

	# Put in a message describing how this document has other versions
	# in the repository if appropriate
	if( $flags->{has_multiple_versions} )
	{
		my $latest = $eprint->last_in_thread( $succeeds_field );
		if( $latest->value( "eprintid" ) == $eprint->value( "eprintid" ) )
		{
			$flags->{latest_version} = 1;
			$fragments{multi_info} = $repository->html_phrase( "page:latest_version" );
		}
		else
		{
			$fragments{multi_info} = $repository->render_message(
				"warning",
				$repository->html_phrase( 
					"page:not_latest_version",
					link => $repository->render_link( $latest->get_url() ) ) );
		}
	}		


	# Now show the version and commentary response threads
	if( $flags->{has_multiple_versions} )
	{
		$fragments{version_tree} = $eprint->render_version_thread( $succeeds_field );
	}
	
	if( $flags->{in_commentary_thread} )
	{
		$fragments{commentary_tree} = $eprint->render_version_thread( $commentary_field );
	}

	foreach my $key ( keys %fragments ) { $fragments{$key} = [ $fragments{$key}, "XHTML" ]; }
	
	my $page = $eprint->render_citation( "summary_page", %fragments, flags=>$flags );

	my $title = $eprint->render_citation("brief");

	my $links = $repository->xml()->create_document_fragment();
	if( !$preview ) {
    #$links->appendChild( $repository->plugin( "Export::Simple" )->dataobj_to_html_header( $eprint ) );
		#$links->appendChild( $repository->plugin( "Export::DC" )->dataobj_to_html_header( $eprint ) );
	}

	#to define a specific template to render the abstract with, you can do something like:
	# my $template;
	# if( $eprint->value( "type" ) eq "article" ){
	# 	$template = "article_template";
	# }
	# return ( $page, $title, $links, $template );
	return( $page, $title, $links );
};

$c->{render_compound_url} = sub {
    my( $session, $field, $value ) = @_; 
    
    my $f = $field->get_property( "fields_cache" );
    my $fmap = {};  
    foreach my $field_conf ( @{$f} ){
        my $fieldname = $field_conf->{name};
        my $field = $field->{dataset}->get_field( $fieldname );
        $fmap->{$field_conf->{sub_name}} = $field;
    }
    
    my $ul = $session->make_element( "ul", class => "list-unstyled" );
    
    foreach my $row ( @{$value} ) {
        my $li = $session->make_element( "li" );
        my $link = $session->render_link( $row->{url} );
        if( defined $row->{type} ){
            $link->appendChild( $fmap->{type}->render_single_value( $session, $row->{type} ) );
        } else {
            my $text = $row->{url};
            if( length( $text ) > 40 ) { $text = substr( $text, 0, 40 )."..."; }
            $link->appendChild( $session->make_text( $text ) );
        }
        $li->appendChild( $link );
        $ul->appendChild( $li );
    }
    return $ul;
};

$c->{render_compound_country} = sub {
    my( $session, $field, $value ) = @_; 
    my $div = $session->make_element( "div", class => "compound" );
    
    if ( $value->{sublocation} ne "") {
        $div->appendChild( $session->make_element( "span", class => "sublocation" ));
        $div->appendChild( $session->make_text( $value->{sublocation} . ", " ) );
    }
    if ( $value->{city} ne "") {
        $div->appendChild( $session->make_element( "span", class => "city" ));
        $div->appendChild( $session->make_text( $value->{city} . ", " ) );
    }
    if ( $value->{state} ne "") {
        $div->appendChild( $session->make_element( "span", class => "state" ));
        $div->appendChild( $session->make_text( $value->{state} . ", " ) );
    }
    if ( $value->{country} ne "") {
        $div->appendChild( $session->make_element( "span", class => "country" ));
        my $link = $session->make_element( "a", href => $session->config( "http_root" ) . "/view/countries/" . $value->{country} . ".html" );
        $link->appendChild( $session->html_phrase( "countries_typename_" . $value->{country} ) );
        $div->appendChild($link);
    }
    return $div;
};

$c->{render_short_subject} = sub {
    my( $session, $field, $value ) = @_; 
    
    my $subject = new EPrints::DataObj::Subject( $session, $value );
    if( !defined $subject ) {
        return $session->make_text( "$value (To be Translated)" );
    }
    return $subject->render_description;
}
