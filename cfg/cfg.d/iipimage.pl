# add iipimage to the list of thumbnail types generated for DataObj::Documents
$c->add_trigger( EP_TRIGGER_THUMBNAIL_TYPES, sub {
    my( %params ) = @_;
    my $dataobj = $params{dataobj};
    my $list = $params{list};

    return 0 unless $dataobj->isa( "EPrints::DataObj::Document" );

    push @$list, "iipimage";
    return 0;
}, priority => 100);

# thumbnail size
$c->{plugins}->{"Convert::Thumbnails::IIPImage"}->{params}->{sizes} = {
    iipimage => [999,999], # dummy
};

$c->{plugins}->{"Convert::Thumbnails::FlexPaper"}->{params}->{convert_formats} = {qw(
    bmp     image/bmp
    gif     image/gif
    ief     image/ief
    jpeg    image/jpeg
    jpe     image/jpeg
    jpg     image/jpeg
    jp2     image/jp2
    png     image/png
    tiff    image/tiff
    tif     image/tiff
    pnm     image/x-portable-anymap
    pbm     image/x-portable-bitmap
    pgm     image/x-portable-graymap
    ppm     image/x-portable-pixmap
)};

# thumbnail conversion method
$c->{plugins}->{"Convert::Thumbnails::IIPImage"}->{params}->{call_convert} = sub {
    my( $plugin, $dir, $doc, $src, $geom, $size ) = @_;
    my $convert = $plugin->{'convert'};

    if (!defined($geom)) {
        EPrints::abort("NO GEOM");
    }

    my $fn = $size . ".tif";
    my $dst = "$dir/$fn";
    my $tile_geom = "256x256";

    $plugin->_system($convert,  "$src", "-define", "tiff:tile-geometry=$tile_geom", "-compress", "jpeg", "-quality", "90%", "ptif:$dst");
    $plugin->{_mime_type} = "image/tiff";

    if( -s $dst ) {
        return ($fn);
    }

    return ();
};

#
# all thumbnails are visible, even if the original is for sale.
#

$c->add_trigger( EP_TRIGGER_DOC_URL_REWRITE, sub {
    my( %args ) = @_;
    my( $request, $doc, $relations, $filename ) = @args{qw( request document relations filename )};
    
    foreach my $r (@$relations) {
        $r =~ s/^has(.+)$/is$1Of/;
        $doc = $doc->search_related( $r )->item( 0 );

        if( !defined $doc ) {
            $request->status( 404 );
            return EP_TRIGGER_DONE;
        }
        $filename = $doc->get_main;

        # remove access restrictions from related version
        $request->set_handlers( PerlAccessHandler => [] );
    }

    $request->pnotes( dataobj => $doc );
    $request->pnotes( filename => $filename );
}, priority => 200 );

{package EPrints::Script::Compiled;

sub run_iipimage_thumbnail_url {
    my( $self, $state, $doc ) = @_;
    if( ! $doc->[0]->isa( "EPrints::DataObj::Document" ) ) {
        $self->runtime_error( "iipimage_thumbnail_url() must be called on a document object." );
    }
    my $repo = $state->{repository};
    my $url = $doc->[0]->thumbnail_url( "iipimage" );
    return [ undef, "STRING" ] unless defined $url;
    my $relation = "isiipimageThumbnailVersionOf";
    my $thumbnail = $doc->[0]->search_related( $relation )->item(0);

    $url = substr($thumbnail->local_path, (index($thumbnail->local_path, $repo->id) -1)) . "/iipimage.tif";
    #$url .= sprintf( "?FIF=%s/%s", $thumbnail->local_path, URI::Escape::uri_escape_utf8( $thumbnail->value( "main" ), "^A-Za-z0-9\-\._~\/" ) );
    return [ $url, "STRING" ];
}}
