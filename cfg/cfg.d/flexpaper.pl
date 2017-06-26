
$c->{executables}->{pdf2swf} = "/usr/bin/pdf2swf";

# add iipimage to the list of thumbnail types generated for DataObj::Documents
$c->add_trigger( EP_TRIGGER_THUMBNAIL_TYPES, sub {
	my( %params ) = @_;

	my $dataobj = $params{dataobj};
	my $list = $params{list};

	return 0 unless $dataobj->isa( "EPrints::DataObj::Document" );

	push @$list, "flexpaper";

	return 0;
}, priority => 100);

# thumbnail size
$c->{plugins}->{"Convert::Thumbnails::FlexPaper"}->{params}->{sizes} = {
	flexpaper => [999,999], # dummy
};

# thumbnail size
$c->{plugins}->{"Convert::Thumbnails::FlexPaper"}->{params}->{convert_formats} = {qw(
	pdf	application/pdf
	ps	application/postscript
)};

# thumbnail conversion method
$c->{plugins}->{"Convert::Thumbnails::FlexPaper"}->{params}->{call_convert} = sub 
{
	my( $plugin, $dir, $doc, $src, $geom, $size ) = @_;

	my $pdf2swf = $plugin->{'pdf2swf'};

	if (!defined($geom)) {
		EPrints::abort("NO GEOM");
	}

  if ($src =~ /(\.[^.]+)$/ ne "pdf") {
		return ();
	}

	my $fn = $size . ".swf";
	my $dst = "$dir/$fn";

	$geom = "$geom->[0]x$geom->[1]";

	$plugin->_system( $pdf2swf,  $src, "-f", "-T 9", "-t", "-s", "storeallcharacters", "-s", "disable_polygon_conversion", "-o", $dst);

	$plugin->{_mime_type} = "application/x-shockwave-flash"; # application/pdf ?

	if( -s $dst ){
		return ($fn);
	}

	return ();
};
