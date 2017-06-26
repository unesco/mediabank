my $c->{ml_fields_search_substitutions} = {
	'title' => 'ml_title',
	'abstract' => 'ml_abstract',
  'headline' => 'ml_headline',
};

foreach my $s (qw/ simple advanced /)
{
	my $search_fields = $c->{search}->{$s}->{'search_fields'};

	#iterate through fields on the search form
	for (my $sf = 0; $sf <= $#{$search_fields}; $sf++)
	{
		#iterate through metadata fields on each field on the form
		for (my $mf = 0; $mf <= $#{$search_fields->[$sf]->{meta_fields}}; $mf++)
		{
			#swap the name if it's in the substitution map
			my $fieldname = $search_fields->[$sf]->{meta_fields}->[$mf];
			if ($c->{ml_fields_search_substitutions}->{$fieldname})
			{
				$search_fields->[$sf]->{meta_fields}->[$mf] = $c->{ml_fields_search_substitutions}->{$fieldname};
			}
		}
	}

}
