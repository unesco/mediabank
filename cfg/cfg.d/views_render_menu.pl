
# This is an example of a custom browse menu renderer.

# To use this add render_menu => "render_view_menu_3col_boxes" to a view in views.pl
# Example output
# <div class="row">
#   <div class="col-sm-6 col-md-4">
#     <div class="thumbnail">
#       <img src="..." alt="...">
#       <div class="caption">
#         <h3>Thumbnail label</h3>
#         <p>...</p>
#         <p><a href="#" class="btn btn-primary" role="button">Button</a> <a href="#" class="btn btn-default" role="button">Button</a></p> 
#       </div>
#     </div>
#   </div>
# </div>

$c->{render_view_menu_thumbnails_grid} = sub {
    my( $repository, $menu, $sizes, $values, $fields, $has_submenu, $view ) = @_;
    my $xml = $repository->xml();
    my $row = $xml->create_element( "div", class => "row voffset1" );
    foreach my $value ( @{$values} ) {
        my $size = 0;
        if ((ref($value) eq "HASH") or defined($value) ) {
            $size = 1;
        }
        next if( $menu->{hideempty} && $size == 0 );

        # work out what filename to link to
        my $fileid = $fields->[0]->get_id_from_value( $repository, $value );
        my $link = EPrints::Utils::escape_filename( $fileid );
        if( $has_submenu ) { $link .= '/'; } else { $link .= '.html'; }
        my $item = $xml->create_element( "div", class=>"col-lg-3 col-md-4 col-xs-6 col-sm-6" );
        my $thumb = $xml->create_element( "div", class=>"thumbnail" );
        my $athumb = $repository->render_link( $link );
        
        # get first item matching $value
        # note that we do not consider any higher menu levels so this will only work for the top level menu in a view
        my $list = $view->dataset->search(
		  custom_order=>$view->{order},
          satisfy_all=>1,
          filters=>$view->get_filters( [ $value ], 1 ),
          limit => 1
        );
        my $first = ( $list->get_records )[0];
       	if( defined $first ){
		  my $doc = ( $first->get_all_documents )[0];
		  if( defined $doc ){
			$thumb->appendChild( $xml->create_element( "img", src => $doc->thumbnail_url('medium') ) );
		  }
	   }
        my $caption = $xml->create_element( "div", class=>"caption" );
        my $title = $xml->create_element( "h3" );
        $title->appendChild( $fields->[0]->get_value_label( $repository, $value ) );
        $caption->appendChild( $title );
        $athumb->appendChild( $caption );
        $thumb->appendChild( $athumb );
        $item->appendChild( $thumb );
        $row->appendChild( $item );
        }
    return $row;
};

# Example output
#<div class="media">
#  <div class="media-left">
#    <a href="#">
#      <img class="media-object" src="..." alt="...">
#    </a>
#  </div>
#  <div class="media-body">
#    <h4 class="media-heading">Media heading</h4>
#    ...
#  </div>
#</div>
$c->{render_view_menu_media_list_countries} = sub {
    my( $repository, $menu, $sizes, $values, $fields, $has_submenu ) = @_;
    my $xml = $repository->xml();
    my $row = $xml->create_element( "div", class => "row countries_list" );

    foreach my $value ( @{$values} ) {
        my $size = 0;
        if ((ref($value) eq "HASH") or defined($value) ) {
            $size = 1;
        }
        next if( $menu->{hideempty} && $size == 0 );

        # work out what filename to link to
        my $fileid = $fields->[0]->get_id_from_value( $repository, $value );
        my $link = EPrints::Utils::escape_filename( $fileid );
        if( $has_submenu ) { $link .= '/'; } else { $link .= '.html'; }
        
        my $item = $xml->create_element( "div", class=>"media col-lg-3 col-md-3 col-xs-6 col-sm-6" );
        my $media = $xml->create_element( "div", class=>"pull-left flags" );
        my $amedia = $repository->render_link( $link );
	if( defined($value) ) {
	    if ( $value eq "UN") { $value = "unesco"; }
            $amedia->appendChild( $xml->create_element( "div", class=>"pull-left sprite-flags100-" . lc($value) ) );
        } else {
            $amedia->appendChild( $xml->create_element( "div", class=>"pull-left sprite-flags100-unesco" ) );
        }
        my $body = $xml->create_element( "div", class=>"media-body" );
        my $title = $xml->create_element( "h4", class=>"media-heading" );
        my $atitle = $repository->render_link( $link );
        my $text = $xml->create_element( "p" );
#        $text->appendChild($xml->create_text_node("description"));
        $title->appendChild( $fields->[0]->get_value_label( $repository, $value ) );
        $atitle->appendChild( $title );
        $body->appendChild( $atitle );
#        $body->appendChild( $text );
        $media->appendChild( $amedia );
        $item->appendChild( $media );
        $item->appendChild( $body );
        $row->appendChild( $item );
	}

	return $row;
};

# Example output
#<div class="media">
#  <div class="media-left">
#    <a href="#">
#      <img class="media-object" src="..." alt="...">
#    </a>
#  </div>
#  <div class="media-body">
#    <h4 class="media-heading">Media heading</h4>
#    ...
#  </div>
#</div>
$c->{render_view_menu_media_list} = sub {
    my( $repository, $menu, $sizes, $values, $fields, $has_submenu ) = @_;
    my $xml = $repository->xml();
    my $row = $xml->create_element( "div", class => "row media_list" );

    foreach my $value ( @{$values} ) {
        my $size = 0;
        if ((ref($value) eq "HASH") or defined($value) ) {
            $size = 1;
        }
        next if( $menu->{hideempty} && $size == 0 );

        # work out what filename to link to
        my $fileid = $fields->[0]->get_id_from_value( $repository, $value );
        my $link = EPrints::Utils::escape_filename( $fileid );
        if( $has_submenu ) { $link .= '/'; } else { $link .= '.html'; }
        
        my $item = $xml->create_element( "div", class=>"media col-lg-3 col-md-3 col-xs-6 col-sm-6" );
        my $media = $xml->create_element( "div", class=>"pull-left" );
        my $amedia = $repository->render_link( $link );
        
        my $list = $repository->dataset( "archive" )->search(
            satisfy_all=>1,
            filters=>[{
                meta_fields => $menu->{fields}, value => $value,
            }],
            limit => 1
        );
        my $first = ( $list->get_records )[0];
        if( defined $first ){
            my $doc = ( $first->get_all_documents )[0];
            if( defined $doc ){
                $amedia->appendChild( $xml->create_element( "img", src => $doc->thumbnail_url('medium') ) );
            }
        }
        my $body = $xml->create_element( "div", class=>"media-body" );
        my $title = $xml->create_element( "h4", class=>"media-heading" );
        my $atitle = $repository->render_link( $link );
        my $text = $xml->create_element( "p" );
        $title->appendChild( $fields->[0]->get_value_label( $repository, $value ) );
        $atitle->appendChild( $title );
        $media->appendChild( $amedia );
        $item->appendChild( $media );
        $item->appendChild( $body );
        $row->appendChild( $item );
	}
	return $row;
};
