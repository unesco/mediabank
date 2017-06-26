=head1 NAME

Subclass SetLang and provide UNESCO specific rendering of language links #852

=cut

package EPrints::Plugin::Screen::UNESCOSetLang;

use EPrints::Plugin::Screen::SetLang;
@ISA = qw( EPrints::Plugin::Screen::SetLang );

use strict;

sub render_action_link
{
	my( $self ) = @_;

	my $session = $self->{session};

	my $xml = $session->xml;
	my $f = $xml->create_document_fragment;

	my $languages = $session->config( "languages" );

	if( @$languages == 1 )
	{
		return $f;
	}

	my $scripturl = URI->new( $session->current_url( path => "cgi", "set_lang" ), 'http' );
	my $curl = "";
	if( $session->get_online )
	{
		$curl = $session->current_url( host => 1, query => 1 );
	}

	my $ul = $xml->create_element( "ul", class => "dropdown-menu", role => "menu" );
	$f->appendChild( $ul );

	foreach my $langid (@$languages)
	{
		$scripturl->query_form(
			lang => $langid,
			referrer => $curl
		);
		my $clangid = $session->get_lang()->get_id;
		$session->change_lang( $langid );
		my $title = $session->phrase( "languages_typename_$langid" );
		$session->change_lang( $clangid );

		my $active = $langid eq $session->get_lang->get_id;

		my $li = $xml->create_element( "li", class => $active ? "$langid first active" : $langid );
		$ul->appendChild( $li );
		my $link = $xml->create_element( "a",
			href => "$scripturl",
			title => $title,
			class => $active ? "language-link active" : "language-link",
			lang => $langid,
		);
		$link->appendChild( $xml->create_text_node( $title ) );
		$li->appendChild( $link );
	}

	return $ul;
}

1;
