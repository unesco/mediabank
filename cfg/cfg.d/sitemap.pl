######################################################################
#
# Local sitemap URLs
#
######################################################################

# Adds local sitemap URLs to the repository sitemap.xml file

$c->add_trigger( EP_TRIGGER_LOCAL_SITEMAP_URLS, sub {
    my( %args ) = @_;
    my( $repository, $urlset ) = @args{qw( repository urlset )};
    $urlset->appendChild( EPrints::Utils::make_sitemap_url( $repository, {
        loc => $repository->config( "base_url" ).'/view/creators/',
        changefreq => 'monthly'
    }));

    return EP_TRIGGER_OK;
});
