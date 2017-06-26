
$c->{set_eprint_automatic_fields} = sub {
    my( $eprint ) = @_;

    #######
    #
    # Hide eprint from search if all documents are restricted. More an example than real use
    #
    #######
    my @docs = $eprint->get_all_documents();
    my $textstatus = "none";
    if( scalar @docs > 0 ) {
        $textstatus = "public";
        foreach my $doc ( @docs ) {
            if( !$doc->is_public ) {
                $textstatus = "restricted";
                last;
            }
        }
    }
    $eprint->set_value( "full_text_status", $textstatus );

    #######
    #
    # Populate the leaf-values
    # see cfg/cfg.d/zz_tags.pl
    #
    #######
    if( $eprint->dataset->has_field( "tags" ) && $eprint->is_set( "tags" ) ) {
        my @keywords;
        my @tags;

        #prepare keywords array
        foreach my $tag (@{$eprint->get_value( "tags" )}) {
          $tag =~ s/^.*;\s*//; # only get the leaf part
          $tag = lc($tag);
          $tag =~ s/\s+/_/g;
          push @keywords, $tag;
        }

        @keywords = sort @keywords;

        # push into keywords
        $eprint->set_value( "keywords", \@keywords );
    }

    #######
    #
    # Populate latitude longitude based on Geonames.org
    #######
    if( $eprint->dataset->has_field( "where_shown" ) && $eprint->is_set( "where_shown_country" )){
        use Geo::GeoNames;

        my $username = "unesco";
        my $ua = LWP::UserAgent->new( agent => "eprints geocoder");
        $ua->env_proxy;
        my $geocoder = Geo::GeoNames->new( username => $username, ua => $ua );
        my $location = $eprint->get_value( "where_shown_city" ) . " " . $eprint->get_value( "where_shown_country" ) . " " . $eprint->get_value( "where_shown_sublocation" );
        my $result = $geocoder->search(q => $location, maxRows => 1);

        # push into latitude / longitude
        $eprint->set_value( "latitude", $result->[0]->{'lat'} );
        $eprint->set_value( "longitude", $result->[0]->{'lng'} );
    }
};
