
######################################################################
#
# Dynamic Template
#
# If you use a dynamic template then this function is called every
# time a page is served to generate dynamic parts of it.
# 
# The dynamic template feature may be disabled to reduce server load.
#
# When enabling/disabling it, run 
# generate_apacheconf
# generate_static
# generate_views
# generate_abstracts
#
######################################################################

$c->{dynamic_template}->{enable} = 1;

# This method is called for every page to add/refine any parts that are
# specified in the template as <epc:pin ref="name" />

#$c->{dynamic_template}->{function} = sub {
#	my( $repository, $parts ) = @_;
#
#};

# To support backwards-compatibility the new-style key tools plugins are
# included here
# $c->{plugins}->{"Screen::Login"}->{appears}->{key_tools} = 100;
# $c->{plugins}->{"Screen::Register"}->{actions}->{register}->{appears}->{key_tools} = 150;
$c->{plugins}->{"Screen::Logout"}->{appears}->{key_tools} = 10000;
$c->{plugins}->{"Screen::Admin::Config::Edit::XPage"}->{actions}->{edit}->{appears}->{key_tools} = 1250;
$c->{plugins}->{"Screen::Admin::Phrases"}->{actions}->{edit}->{appears}->{key_tools} = 1350;
$c->{plugins}->{"Screen::OtherTools"}->{appears}->{key_tools} = 20000;

#
# TODO: Good idea, but how can we test the view?
#
$c->{dynamic_template}->{function} = sub {
    my( $repository, $parts ) = @_;
    #print $repository->current_url( path => "static" ) . "\n";
    if ( 0 ) {
        my $xml = $repository->xml();
        my $map = $xml->create_element( "div", class => "leaflet-container leaflet-fade-anim leaflet-grab leaflet-touch-drag", id => "mapid", style => "width: 100%; height: 400px; position: relative; outline: medium none;", tabindex => "0");
        $parts->{mapdiv} = $map;
    }
};
