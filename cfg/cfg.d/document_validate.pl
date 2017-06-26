######################################################################
#
# validate_document( $document, $repository, $for_archive )
#
######################################################################
# $document
# - Document object
# $repository
# - Repository object (the current repository)
# $for_archive
# - boolean (see comments at the start of the validation section)
#
# returns: @problems
# - ARRAY of DOM objects (may be null)
#
######################################################################
# Validate a document. validate_document_meta will be called auto-
# matically, so you don't need to duplicate any checks.
#
######################################################################


$c->{validate_document} = sub{
    my( $document, $repository, $for_archive ) = @_;
    my @problems = ();
    my $xml = $repository->xml();

    # CHECKS IN HERE
    # "other" documents must have a description set
    #if( $document->value( "format" ) eq "other" && !EPrints::Utils::is_set( $document->value( "formatdesc" ) ) ){
    #    my $fieldname = $xml->create_element( "span", class=>"ep_problem_field:documents" );
    #    push @problems, $repository->html_phrase(
    #        "validate:need_description" ,
    #        type=>$document->render_citation("brief"),
    #        fieldname=>$fieldname
    #    );
    #}
    # carousel images must have a defined size
    if ( $document->value( "content" ) eq "carousel"){
        my $fieldname = $xml->create_element( "span", class=>"ep_problem_field:documents" );
        push @problems, $repository->html_phrase($document->value( "media_height" ), fieldname=>$fieldname);
    }

    # security can't be "public" if date embargo set
    if( $document->value( "security" ) eq "public" && EPrints::Utils::is_set( $document->value( "date_embargo" ) ) ){
        my $fieldname = $xml->create_element( "span", class=>"ep_problem_field:documents" );
        push @problems, $repository->html_phrase(
            "validate:embargo_check_security" ,
            fieldname=>$fieldname
        );
    }

    # if security is paypal, then we need a price
    if( $document->value( "security" ) eq "paypal" && int($document->value( "price" )) le 0 ){
        my $fieldname = $xml->create_element( "span", class=>"ep_problem_field:documents" );
        $fieldname->appendChild($xml->create_text_node("Price must be higher then 0"));
        push @problems, $repository->html_phrase( "document_fieldname_price", fieldname=>$fieldname );
    }

    # embargo expiry date must be in the future
    if( EPrints::Utils::is_set( $document->value( "date_embargo" ) ) ){
        my $value = $document->value( "date_embargo" );
        my ($thisyear, $thismonth, $thisday) = EPrints::Time::get_date_array();
        my ($year, $month, $day) = split( '-', $value );
        if( $year < $thisyear || ( $year == $thisyear && $month < $thismonth ) || ( $year == $thisyear && $month == $thismonth && $day <= $thisday ) ){
            my $fieldname = $xml->create_element( "span", class=>"ep_problem_field:documents" );
            push @problems,	$repository->html_phrase( "validate:embargo_invalid_date", fieldname=>$fieldname );
        }
    }

    return( @problems );
};
