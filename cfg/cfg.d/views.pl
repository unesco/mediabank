
# Browse views. allow_null indicates that no value set is 
# a valid result. 
# Multiple fields may be specified for one view, but avoid
# subject or allowing null in this case.



##
# set a global max_items limit:
#	$c->{browse_views_max_items} = 3000;

# set a per view max_item limit:
#        $c->{browse_views} = [{
#                ...
#                max_items => 3000,
#        }];
# To disable the limit set max_items to 0.


$c->{browse_views} = [
# browse by country.
{
    id => "countries",
    name => "countries",
    menus => [{
        fields => [ "where_shown_country" ],
        allow_null => 0,
        hideempty => 1,
    }],
    #max_items => 2000,
    render_menu => "render_view_menu_media_list_countries",
    order => "-date/title",
    template => 'map_view',
    variations => [
        "DEFAULT;render_fn=render_view_items_map_cluster",
    ],
    citation => "leaflet_thumbnail",
},
# browse by year.
{
    id => "date",
    menus => [{
        fields => [ "date;res=year" ],
        reverse_order => 0,
        allow_null => 1,
        new_column_at => [4,10],
        mode => "sections",
        open_first_section => 1,
        grouping_function => "EPrints::Update::Views::group_by_4_characters",
        group_range_function   => "EPrints::Update::Views::cluster_ranges_10",
    }],
    render_menu => "render_view_menu_media_list",
    order => "creators_name/title",
    variations => [
        "DEFAULT"
    ],
    citation => "thumbnail",
},
# browse by People featured.
{
    id => "vips",
    hideempty => 1,
    menus => [{
        fields => [ "person_shown" ],
        allow_null => 1,
        new_column_at => [4,10],
    }],
    render_menu => "render_view_menu_thumbnails_grid",
    order => "-date/title",
    variations => [
        "DEFAULT",
    ],
    citation => "thumbnail",
},
# browse by Event.
{
    id => "events",
    hideempty => 1,
    menus => [{
        fields => [ "event" ],
        allow_null => 1,
        new_column_at => [4,10],
    }],
    render_menu => "render_view_menu_thumbnails_grid",
    order => "-date/title",
    variations => [
        "DEFAULT",
    ],
    citation => "thumbnail",
},
# browse by Organisation.
{
    id => "organisations",
    hideempty => 1,
    menus => [{
        fields => [ "organisation" ],
        allow_null => 1,
        new_column_at => [4,10],
    }],
    render_menu => "render_view_menu_thumbnails_grid",
    order => "-date/title",
    variations => [
        "DEFAULT",
    ],
    citation => "thumbnail",
},
{
    id => "creators",
    hideempty => 1,
    menus => [{
        fields => [ "creators_name" ],
        allow_null => 1,
        new_column_at => [4,10],
    }],
    render_menu => "render_view_menu_thumbnails_grid",
    order => "-date/title",
    variations => [
        "DEFAULT",
    ],
    citation => "thumbnail",
},
{
    id => "collections",
    menus => [{
        fields => [ "keywords" ],
        hideempty => 1,
    }],
    order => "date/creators_name/title",
    include => 1,
    variations => [
        "DEFAULT",
    ],
    citation => "thumbnail",
},
{
    id => "subjects",
    menus => [{
        fields => [ "subjects" ],
        hideempty => 1,
    }],
    order => "date/creators_name/title",
    include => 1,
    variations => [
        "DEFAULT",
    ],
    citation => "thumbnail",
},
{
    id => "divisions",
    menus => [{
        fields => [ "divisions" ],
        hideempty => 1,
    },{
        fields => [ "date;res=year" ],
        reverse_order => 1,
        allow_null => 1,
        hideempty => 1,
    }],
    nolink => 1,
    order => "creators_name/title",
    include => 1,
    variations => [
        "creators_name;first_letter",
        "DEFAULT",
    ],
    citation => "thumbnail",
},
{
    id => "type",
    menus => [{
        fields => [ "type" ],
        allow_null => 0,
        hideempty => 1,
        },
        {
        fields => [ "subjects" ],
        allow_null => 0,
        hideempty => 1,
    }],
    order => "-date/title",
    variations => [
        "DEFAULT",
    ],
    citation => "thumbnail",
}
];

{
	package EPrints::Update::Views;
	sub render_export_bar {
		my( $repo ) = @_;
		return $repo->make_doc_fragment;
	}
}
