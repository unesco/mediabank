
$c->{search}->{advanced} = 
{
	search_fields => [
		{ meta_fields => [ "ml_title" ] },
		{ meta_fields => [ "creators_name" ] },
		{ meta_fields => [ "ml_abstract" ] },
		{ meta_fields => [ "date" ] },
		{ meta_fields => [ "where_shown_country" ] },
		{ meta_fields => [ "person_shown" ] },
		{ meta_fields => [ "event" ] },
		{ meta_fields => [ "organisation" ] },
		{ meta_fields => [ "tags" ] },
		{ meta_fields => [ "subjects" ] },
		{ meta_fields => [ "type" ] },
	],
	preamble_phrase => "cgi/advsearch:preamble",
	title_phrase => "cgi/advsearch:adv_search",
	citation => "media",
	page_size => 20,
	order_methods => {
		"byyear" 	 => "-date/creators_name/title",
		"byyearoldest"	 => "date/creators_name/title",
		"byname"  	 => "creators_name/-date/title",
		"bytitle" 	 => "title/creators_name/-date"
	},
	default_order => "byyear",
	show_zero_results => 1,
};
