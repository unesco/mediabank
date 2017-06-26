# Change this value to change the size of your thumbnail
# enable audio previews
$c->{plugins}->{'Convert::Thumbnails'}->{params}->{audio} = 1;
# change libfaac to aac
$c->{plugins}->{"Convert::Thumbnails"}->{params}->{audio_mp4} = {
        audio_codec => "libvo_aacenc", # not libfaac
        audio_bitrate => "96k",
        audio_sampling => "44100",
        container => "mp4",
};
# enable video previews
$c->{plugins}->{'Convert::Thumbnails'}->{params}->{video} = 1;
$c->{plugins}->{"Convert::Thumbnails"}->{params}->{video_mp4} = {
        audio_codec => "libvo_aacenc", # not libfaac
        audio_bitrate => "96k",
        audio_sampling => "44100",
        video_codec => "libx264",
        video_frame_rate => "20.00",
        video_bitrate => "1000k",
        container => "mp4",
};
$c->{plugins}->{"Convert::Thumbnails"}->{params}->{video_height} = "720";
$c->{plugins}->{'Convert::Thumbnails'}->{params}->{sizes} = {
    small => [100,100], # default
    medium => [300,300], # default
    large => [500,500],
    preview => [1000],
    large_16x9 => [500,282], # used for videos
    carousel => [980,450],
};

$c->{thumbnail_types} = sub {
        my( $list, $repo, $doc ) = @_;
        push @$list, qw(
            large
            preview
            large_16x9
            carousel
        ); 
};

# 
# This is to generate the actual Thumbnails from image content type.
#

$c->{plugins}->{'Convert::Thumbnails'}->{params}->{call_convert} = sub {
	my( $self, $dir, $doc, $src, $geom, $size ) = @_;
 
	my $convert = $self->{'convert'};
	my $version = $self->convert_version;
 
	if (!defined($geom)) {
		EPrints::abort("NO GEOM " . $src . " " . $size );
	}
 
	my $fn = $size . ".jpg";
	my $dst = "$dir/$fn";
 
	$geom = "$geom->[0]x$geom->[1]";

	if ( !$size ) {
    } else {
        $self->_system($convert, "-strip", "-colorspace", "RGB", "-trim", "+repage", "-resize", "$geom^", "-gravity", "center", "-background", "white", "-extent", $geom, $src."[0]", "JPEG:$dst");
    }
 
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
