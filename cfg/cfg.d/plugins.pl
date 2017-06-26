# Export
$c->{plugins}->{"Export::Text"}->{params}->{disable} = 1;
$c->{plugins}->{"Export::Atom"}->{params}->{disable} = 1;
$c->{plugins}->{"Export::EndNote"}->{params}->{disable} = 1;
$c->{plugins}->{"Export::Mets"}->{params}->{disable} = 1;
$c->{plugins}->{"Export::MODS"}->{params}->{disable} = 1;
$c->{plugins}->{"Export::DIDL"}->{params}->{disable} = 1;
$c->{plugins}->{"Export::COinS"}->{params}->{disable} = 1;
$c->{plugins}->{"Export::ContextObject"}->{params}->{disable} = 1;
$c->{plugins}->{"Export::Refer"}->{params}->{disable} = 1;
$c->{plugins}->{"Export::RIS"}->{params}->{disable} = 1;
$c->{plugins}->{"Export::Simple"}->{params}->{disable} = 1;
# Import
$c->{plugins}->{"Import::CSV"}->{params}->{disable} = 0;
$c->{plugins}->{"Import::BibTeX"}->{params}->{disable} = 1;
$c->{plugins}->{"Import::DOI"}->{params}->{disable} = 1;
$c->{plugins}->{"Import::DSpace"}->{params}->{disable} = 1;
$c->{plugins}->{"Import::PubMedID"}->{params}->{disable} = 1;
$c->{plugins}->{"Import::PubMedXML"}->{params}->{disable} = 1;
$c->{plugins}->{"Import::OpenXML"}->{params}->{disable} = 1;
$c->{plugins}->{"Import::XSLT::Atom"}->{params}->{disable} = 1;
$c->{plugins}->{"Import::XSLT:XML"}->{params}->{disable} = 0;
$c->{plugins}->{"Import::XSLT::OpenXMLBibl"}->{params}->{disable} = 1;

# UNESCO specific rendering of language links #852
$c->{plugin_alias_map}->{"Screen::Login::Internal"} = "Screen::Login::UNESCOLogin";
$c->{plugin_alias_map}->{"Screen::Login::UNESCOLogin"} = undef;
