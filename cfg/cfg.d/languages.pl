# Default language
$c->{defaultlanguage} = 'en';
# Other enabled languages
$c->{languages} = [ 'en', 'fr', 'es', 'ru', 'ar', 'zh' ];
# UNESCO specific rendering of language links #852
$c->{plugin_alias_map}->{"Screen::SetLang"} = "Screen::UNESCOSetLang";
$c->{plugin_alias_map}->{"Screen::UNESCOSetLang"} = undef;
# domain for the login and lang. cookies to be set in.
$c->{cookie_domain} = $c->{host};