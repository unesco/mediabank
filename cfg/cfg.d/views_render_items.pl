# This is an example of a custom browse items renderer.

# Note: This function needs to return a UTF-8 encoded string NOT XHTML DOM.
# (this is to speed things up).

# To use this add render_fn=render_view_items_3col_boxes" to the options of a variation of a view.
# eg:
#               variations => [
#                       "DEFAULT;render_fn=render_view_items_3col_boxes",
#               ],

$c->{render_view_items_bootstrap_grid} = sub{
    my( $repository, $item_list, $view_definition, $path_to_this_page, $filename ) = @_;
    my $xml = $repository->xml();
    my $columns = 3;
    my $cells = 0;
    my $rows = $xml->create_element( "rows" );

    foreach my $item ( @{$item_list} ) {
        if ( $cells > 0 && $cells % $columns == 0) {
            my $row = $xml->create_element( "div", class => "row voffset1" );
            my $link = $item->get_url;
            my $item = $xml->create_element( "div", class=>"col-lg-3 col-md-4 col-xs-6 col-sm-6" );
            my $thumb = $xml->create_element( "div", class=>"thumbnail" );
            my $athumb = $repository->render_link( $link );
            $row->appendChild( $item->render_citation_link );
            $rows->appenChild($row);
            $cells += 1;
        }
    }
    return $rows;
};

#
# Leaflet citation for an eprint.
# i.e. L.marker([51.5, -0.09]).addTo(mymap).bindPopup("<b>Hello world!</b><br />I am a popup.").openPopup();
#

$c->{render_view_items_map} = sub {
    my( $repository, $item_list, $view_definition, $path_to_this_page, $filename ) = @_;

    my $map = $repository->xml->create_document_fragment;
    $map->appendChild( $repository->make_javascript(sprintf(<<'EOJ',
var mymap = L.map('mapid').setView([51.505, -0.09], 3);
L.tileLayer('http://en.unesco.org/tiles/{id}/{z}/{x}/{y}.png', {
    maxZoom: 9,
    minZoom: 1,
    attribution: 'Map data © <a href="http://en.unesco.org">UNESCO</a> , ' + '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' + 'Imagery © <a href="http://mapbox.com">Mapbox</a>',
    id: 'geodata'
    }).addTo(mymap);
var logo = L.control({position: 'bottomleft'});
logo.onAdd = function(mymap){
    var div = L.DomUtil.create('div', 'mylogo');
    div.innerHTML= "<img src=" + eprints_http_root + "/images/map_logo.png />";
    return div;
}
logo.addTo(mymap);
var myIcon = L.icon({
    iconUrl: eprints_http_root + '/images/marker-icon.png',
    iconSize: [25, 41],
    iconAnchor: [13, 62],
    popupAnchor: [0, -63]
});
EOJ
    )) );
    my $init_lat;
    my $init_long;
    foreach my $item ( @{$item_list} ) {
        my $link = $item->get_url;
        if ($item->get_value( "latitude" )){
            $map->appendChild( $repository->make_javascript(sprintf(<<'EOJ',
L.marker([%d,%d], {icon: myIcon}).addTo(mymap).bindPopup(`%s`");
EOJ
            (map {( $_ )}
                $item->get_value( "latitude" ),
                $item->get_value( "longitude" ),
                $item->render_citation_link("leaflet_thumbnail"),
            )
            )) );
            $init_lat = $item->get_value( "latitude" );
            $init_long = $item->get_value( "longitude" );
        }
    }
    if ($init_lat){
        $map->appendChild ( $repository->make_javascript(sprintf(<<'EOJ',
mymap.setView([%d,%d], 3);
EOJ
        (map {( $_ )}
            $init_lat,
            $init_long,
        )
        )) );
    }
    return $map;
};

#
# Leaflet citation for an eprint.
# i.e. L.marker([51.5, -0.09]).addTo(mymap).bindPopup("<b>Hello world!</b><br />I am a popup.").openPopup();
#

$c->{render_view_items_map_cluster} = sub {
    my( $repository, $item_list, $view_definition, $path_to_this_page, $filename ) = @_;
    my $map = $repository->xml->create_document_fragment;
    $map->appendChild( $repository->make_javascript(sprintf(<<'EOJ',
var mymap = L.map('mapid').setView([51.505, -0.09], 3);
L.tileLayer('http://en.unesco.org/tiles/{id}/{z}/{x}/{y}.png', {
    maxZoom: 9,
    minZoom: 1,
    attribution: 'Map data © <a href="http://en.unesco.org">UNESCO</a> , ' + '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' + 'Imagery © <a href="http://mapbox.com">Mapbox</a>',
    id: 'geodata'
    }).addTo(mymap);
var logo = L.control({position: 'bottomleft'});
logo.onAdd = function(mymap){
    var div = L.DomUtil.create('div', 'mylogo');
    div.innerHTML= "<img src=" + eprints_http_root + "/images/map_logo.png />";
    return div;
}
logo.addTo(mymap);
var markerClusterer = L.markerClusterGroup({
    maxClusterRadius: 40,
    spiderfyOnMaxZoom: true,
    polygonOptions: {
        color: '#2d84c8',
        weight: 4,
        opacity: 1,
        fillOpacity: 0.5
    },
});
var myIcon = L.icon({
    iconUrl: eprints_http_root + '/images/marker-icon.png',
    iconSize: [25, 41],
    iconAnchor: [13, 40],
    popupAnchor: [0, -40]
});
var point;
var newLatLng;
EOJ
    )) );
    my $init_lat;
    my $init_long;
    $map->appendChild($repository->xml->create_element( "h3", class=>""))->appendChild($repository->xml->create_text_node( "List" ));
    foreach my $item ( @{$item_list} ) {
        my $link = $item->get_url;
        if ($item->get_value( "latitude" )){
            $map->appendChild( $repository->make_javascript(sprintf(<<'EOJ',
point = mymap.latLngToContainerPoint(L.latLng([%d,%d]));
newLatLng = mymap.containerPointToLatLng(L.point([point.x + 0.5, point.y -5]));
markerClusterer.addLayer(L.marker(newLatLng, {icon: myIcon}).bindPopup(`%s`));
EOJ
            (map {( $_ )}
                $item->get_value( "latitude" ),
                $item->get_value( "longitude" ),
                $item->render_citation_link("leaflet_thumbnail"),
            )
            )) );
            $init_lat = $item->get_value( "latitude" );
            $init_long = $item->get_value( "longitude" );
        }
        $map->appendChild($repository->xml->create_element( "div", class=>"well"))->appendChild($item->render_citation_link("media"));
    }
    if ($init_lat){
        $map->appendChild ( $repository->make_javascript(sprintf(<<'EOJ',
mymap.addLayer(markerClusterer);
mymap.setView([%d,%d], 3);
EOJ
        (map {( $_ )}
            $init_lat,
            $init_long,
        )
        )) );
    }
    return $map;
};
