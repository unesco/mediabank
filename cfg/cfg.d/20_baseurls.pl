# These configuration variables are mostly unused and should be deprecated.

# old-style configuration names
$c->{"urlpath"} = $c->{"http_root"};
$c->{"base_url"} = $c->{"http_root"} . "/";
$c->{"perl_url"} = $c->{"http_root"} . "/cgi";
$c->{"frontpage"} = $c->{"http_root"} . "/";
$c->{"userhome"} = $c->{"http_root"} . "/cgi/users/home";

# If you don't want EPrints to respond to a specific URL add it to the
# exceptions here. Each exception is matched against the uri using regexp:
#  e.g. /myspecial/cgi
# Will match http://yourrepo/myspecial/cgi
$c->{rewrite_exceptions} = [];

$c->{enable_web_imports} = 1;
$c->{enable_file_imports} = 1;
